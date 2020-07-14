//
//  Net.swift
//  CardApp
//
//  Created by Анастасия Корнеева on 7/15/20.
//

import Foundation
import Alamofire

typealias NetCompletionHandler = (_ error: NetError?, _ json: [String: Any]?) -> Void
typealias ResponseCompletion = (Result<Any?, NetError>) -> Void

class Net {
    static let sh = Net()

    // MARK: - urls

    private let baseUrl: String = "https://ringtones-kodi.s3.amazonaws.com/"

    // MARK: - alamofire

    private let alamofireManager: Alamofire.Session = Session.default

    // MARK: - initialization

    private init() {}

    // MARK: - requests

    func request<T: Decodable>(urlPath: String,
                               reqModel: Encodable?,
                               httpMethod: HTTPMethod? = nil,
                               headers: [String: String]? = nil,
                               urlParams: [String: String]? = nil,
                               okHandler: @escaping ((T) -> Void),
                               errorHandler: @escaping ((NetError) -> Void)) {
        self.request(urlPath: urlPath,
                     reqModel: reqModel,
                     httpMethod: httpMethod,
                     headers: headers,
                     urlParams: urlParams) { (result) in
            switch result {
            case .failure(let error):
                errorHandler(error)
            case .success(let response):
                switch self.decode(modelType: T.self, data: response) {
                case .success(let model):
                    okHandler(model)
                case .failure(let error):
                    errorHandler(NetError.decoding(error: error))
                }
            }
        }
    }

    private func request(urlPath: String,
                         reqModel: Encodable?,
                         httpMethod: HTTPMethod? = nil,
                         headers: [String: String]? = nil,
                         urlParams: [String: String]? = nil,
                         completionHandler: @escaping ResponseCompletion) {
        guard let url = URL(urlString: Net.sh.baseUrl,
                            path: urlPath,
                            params: urlParams) else {
                                completionHandler(.failure(NetError.parsing))
                                return
        }

        var modelParameters: [String: Any]?
        var method: HTTPMethod = .get

        if let model = reqModel {
            modelParameters = try? model.asDictionary()
            method = .post
        } else if let httpMethod = httpMethod {
            method = httpMethod
        }

        self.alamofireManager
            .request(url,
                     method: method,
                     parameters: modelParameters)
            .responseJSON { response in
            switch response.result {
            case .failure(let error):
                var amError: NetError = .network(errorText: (error as NSError).localizedDescription)
                if case .sessionTaskFailed(let error) = error,
                    (error as? URLError)?.code == URLError.Code.notConnectedToInternet {
                    amError = NetError.connectionIsOffline
                }
                completionHandler(.failure(amError))
            case .success(let data):
                let statusCode: Int = response.response?.statusCode ?? 0
                switch statusCode {
                case 200..<300:
                    completionHandler(.success(data))
                default:
                    completionHandler(.failure(.server(message: "\(statusCode)")))
                }
            }
        }
    }

    // MARK: - decoding

    private func decode<T: Decodable>(modelType: T.Type, data: Any?) -> Result<T, NetError> {
        guard let data = data else {
            return .failure(.parsing)
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch let error {
            return .failure(.decoding(error: error))
        }
    }
}

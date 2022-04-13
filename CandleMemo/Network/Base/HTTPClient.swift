//
//  HTTPClient.swift
//  CandleMemo
//
//  Created by Hoen on 2022/04/12.
//

import Combine
import Foundation

protocol HTTPClient {
    func sendRequest<T>(endpoint: Endpoint) -> AnyPublisher<T, RequestError> where T: Decodable, T: Encodable
}

extension HTTPClient {
    func sendRequest<T>(endpoint: Endpoint) -> AnyPublisher<T, RequestError> where T: Decodable, T: Encodable {

        guard let url = URL(string: endpoint.endURL) else {
            return AnyPublisher(
                Fail<T, RequestError>(error: RequestError.invalidURL)
            )
        }
        
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 10.0

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw RequestError.noResponse
                }
                
                guard response.statusCode == 200 else {
                    throw RequestError.unexpectedStatusCode
                }
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                RequestError.decode
            }
            .eraseToAnyPublisher()
        

//        do {
//            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
//            guard let response = response as? HTTPURLResponse else {
//                return .failure(.noResponse)
//            }
//
//            switch response.statusCode {
//            case 200...299:
//                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
//                    return .failure(.decode)
//                }
//                return .success(decodedResponse)
//
//            case 401:
//                return .failure(.unauthorized)
//            default:
//                return .failure(.unexpectedStatusCode)
//            }
//        } catch {
//            return .failure(.unknown)
//        }
    }
}

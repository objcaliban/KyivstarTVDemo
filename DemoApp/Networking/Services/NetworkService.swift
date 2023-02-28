//
//  NetworkService.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Alamofire
import Foundation

protocol NetworkServicing: AnyObject {
    func request<T: Decodable>(
        endpoint: Endpoint,headers: HTTPHeaders
    ) async throws -> T
}

class NetworkService: NetworkServicing {
    func request<T>(
        endpoint: Endpoint, headers: HTTPHeaders
    ) async throws -> T where T : Decodable {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint.url, method: endpoint.method, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { responce in
                    if let value = responce.value {
                        continuation.resume(returning: value)
                    } else if let error = responce.error {
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

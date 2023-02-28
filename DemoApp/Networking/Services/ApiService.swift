//
//  ApiService.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Alamofire
import Foundation

protocol ApiServicing: AnyObject {
    func fetchContentGroups() async throws -> [ContentGroup]
    func fetchPromotions() async throws -> PromotionsData
    func fetchCategories() async throws -> CategoryList
    func fetchAssetDetails() async throws -> AssetDetails
}

final class ApiService: NetworkService, ApiServicing {
    func fetchContentGroups() async throws -> [ContentGroup] {
        let endpoint = Endpoint.getContentGroups
        return try await request(endpoint: endpoint)
    }
    
    func fetchPromotions() async throws -> PromotionsData {
        let endpoint = Endpoint.getPromotions
        let promotionsData: PromotionsData = try await request(endpoint: endpoint)
        return promotionsData
    }
    
    func fetchCategories() async throws ->  CategoryList {
        let endpoint = Endpoint.getCategories
        return try await (request(endpoint: endpoint) as CategoryList)
    }
    
    func fetchAssetDetails() async throws -> AssetDetails {
        let endpoint = Endpoint.getAssetDetails
        return try await request(endpoint: endpoint)
    }
    
    private func request<T: Decodable>(endpoint: Endpoint)  async throws -> T {
        let headers = httpHeadersWithToken()
        return try await request(endpoint: endpoint, headers: headers)
    }
    
    private func httpHeadersWithToken() -> HTTPHeaders {
        var headers = HTTPHeaders()
        let tokenHeader = "Bearer u0xj6pw0fdf7m2l1dvcic7uolk45e79itgin54l8"
        headers.add(name: "Authorization", value: tokenHeader)
        return headers
    }
    
}

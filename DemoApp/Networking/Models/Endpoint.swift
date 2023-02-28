//
//  Endpoint.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Alamofire
import Foundation

enum Endpoint {
    case getContentGroups
    case getPromotions
    case getCategories
    case getAssetDetails
    
    var url: URL {
        baseUrl.appendingPathComponent(path)
    }
    
    var method: HTTPMethod {
        switch self {
        case .getContentGroups:
            return .get
        case .getPromotions:
            return .get
        case .getCategories:
            return .get
        case .getAssetDetails:
            return .get
        }
    }
    
    private var baseUrl: URL {
        URL(string: "https://api.json-generator.com/templates")!
    }
    
    private var path: String {
        switch self {
        case .getContentGroups:
            return "PGgg02gplft-/data"
        case .getPromotions:
            return "j_BRMrbcY-5W/data"
        case .getCategories:
            return "eO-fawoGqaNB/data"
        case .getAssetDetails:
            return "04Pl5AYhO6-n/data"
        }
    }
}


//
//  PromotionsData.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct PromotionsData: Identifiable, Codable {
    let id: String
    let name: String
    let promotions: [Promotion]
}

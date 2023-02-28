//
//  Promotion.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct Promotion: Identifiable, Codable {
    let id: String
    let name: String
    let image: URL
    let company: String
    let updatedAt: String
    let releaseDate: String
}

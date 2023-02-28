//
//  Asset.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct Asset: Identifiable, Codable {
    var id: String
    var name: String
    var image: URL
    var company: String
    var progress: Int
    var purchased: Bool
    var updatedAt: String
    var releaseDate: String
}

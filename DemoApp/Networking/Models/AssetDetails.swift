//
//  AssetDetails.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct AssetDetails: Identifiable, Codable {
    var id: String
    var name: String
    var image: URL
    var company: String
    var similar: [Asset]
    var duration: Int
    var progress: Int
    var purchased: Bool
    var updatedAt: String
    var description: String
    var releaseDate: String
}

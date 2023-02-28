//
//  Category.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct Category: Identifiable, Codable {
    let id: String
    let name: String
    let image: URL
}

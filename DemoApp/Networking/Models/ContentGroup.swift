//
//  ContentGroup.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import Foundation

struct ContentGroup: Identifiable, Codable {
    var id: String
    var name: String
    var type: [String]
    var assets: [Asset]
    var canBeDeleted: Bool
}

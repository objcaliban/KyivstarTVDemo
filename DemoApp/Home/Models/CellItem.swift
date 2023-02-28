//
//  CellItem.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import Foundation

struct CellItem: Hashable {
    var title: String
    var imagePath: URL
    
    var isPurchased: Bool?
    var description: String?
}

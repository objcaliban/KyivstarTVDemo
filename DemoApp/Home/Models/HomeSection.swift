//
//  Section.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import Foundation

enum HomeSectionType: CaseIterable {
    case promotion
    case categories
    case movieSeriesGroup
    case liveChannel
    case epg
}

struct HomeSection: Hashable {
    let title: String
    let type: HomeSectionType
    
    let canBeDeleted: Bool?
    
    init(title: String, type: HomeSectionType, canBeDeleted: Bool? = nil) {
        self.title = title
        self.type = type
        self.canBeDeleted = canBeDeleted
    }
}

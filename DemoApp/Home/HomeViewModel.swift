//
//  HomeViewModel.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import UIKit
import Combine

protocol SectionsProvider {
    func getSections() -> [HomeSection]
}

protocol HomeViewModelRepresentable: SectionsProvider {
    var subscriptions: Set<AnyCancellable> { get set }
    var publishedSections: PassthroughSubject<[SectionSnapshot], Error> { get }
    
    func loadSections()
    func removeSection(named title: String)
    func openAssetDetails()
}

class HomeViewModel: HomeViewModelRepresentable {
    enum ContentGroupType: String {
        case movie = "MOVIE"
        case series = "SERIES"
        case livechannel = "LIVECHANNEL"
        case epg = "EPG"
    }
    
    var subscriptions = Set<AnyCancellable>()
    var publishedSections = PassthroughSubject<[SectionSnapshot], Error>()
    
    private var sections = [HomeSection]()
    private let manager: ApiServicing = ApiService()
    private let openAssetDetailsCallback: () -> Void
    
    init(_ openAssetDetailsCallback: @escaping () -> Void) {
        self.openAssetDetailsCallback = openAssetDetailsCallback
    }
    
    func loadSections() {
        Task {
            try await withThrowingTaskGroup(of: [SectionSnapshot].self) {
                group -> [SectionSnapshot] in
                group.addTask { try await [self.getPromotions()] }
                group.addTask { try await [self.getCategories()] }
                group.addTask { try await self.getContentGroups() }
                
                var collected = [SectionSnapshot]()
                for try await value in group {
                    collected.append(contentsOf: value)
                }
                
                let order = HomeSectionType.allCases
                collected.sort {
                    guard let index1 = order.firstIndex(of: $0.section.type),
                          let index2 = order.firstIndex(of: $1.section.type) else {
                        return false
                    }
                    return index1 < index2
                }
                self.sections = collected.map { $0.section }
                self.publishedSections.send(collected)
                return collected
            }
            
            
        } catch: { err in
            print(err)
        }
    }
    
    func openAssetDetails() {
        openAssetDetailsCallback()
    }
    
    func getSections() -> [HomeSection] {
        return sections
    }
    
    func removeSection(named title: String) {
        sections.removeAll { $0.title == title }
    }
    
    private func getPromotions() async throws -> SectionSnapshot {
        let promotionsData = try await manager.fetchPromotions()
        let section = HomeSection(title: promotionsData.name, type: .promotion)
        let items = promotionsData.promotions.map { promotion in
            return CellItem(title: promotion.name, imagePath: promotion.image)
        }
        return SectionSnapshot(items: items, section: section)
    }
    
    private func getCategories() async throws -> SectionSnapshot {
        let categoriesData = try await manager.fetchCategories()
        let section = HomeSection(title: "Categories", type: .categories)
        let items = categoriesData.categories.map { category in
            return CellItem(title: category.name, imagePath: category.image)
        }
        return SectionSnapshot(items: items, section: section)
    }
    
        private func getContentGroups() async throws -> [SectionSnapshot] {
            let groups = try await manager.fetchContentGroups()
    
            var movieSeriesGroup = [ContentGroup]()
            var livechannelGroup = [ContentGroup]()
            var epgGroup = [ContentGroup]()
    
            groups.forEach { group in
                if let type = group.type.first {
                    switch ContentGroupType(rawValue: type) {
                    case .movie:
                        movieSeriesGroup.append(group)
                    case .series:
                        movieSeriesGroup.append(group)
                    case .livechannel:
                        livechannelGroup.append(group)
                    case .epg:
                        epgGroup.append(group)
                    case .none:
                        break
                    }
                }
            }
    
            var sections = [SectionSnapshot]()
    
            movieSeriesGroup.forEach { group in
                let section = HomeSection(title: group.name,
                                          type: .movieSeriesGroup,
                                          canBeDeleted: group.canBeDeleted)
                let items = group.assets.map { asset in
                    return CellItem(title: asset.name,
                                    imagePath: asset.image,
                                    isPurchased: asset.purchased)
                }
                sections.append(SectionSnapshot(items: items, section: section))
            }
    
            livechannelGroup.forEach { group in
                let section = HomeSection(title: group.name,
                                          type: .liveChannel,
                                          canBeDeleted: group.canBeDeleted)
                let items = group.assets.map { asset in
                    return CellItem(title: asset.name,
                                    imagePath: asset.image,
                                    isPurchased: asset.purchased)
                }
                sections.append(SectionSnapshot(items: items, section: section))
            }
    
            epgGroup.forEach { group in
                let section = HomeSection(title: group.name,
                                          type: .epg,
                                          canBeDeleted: group.canBeDeleted)
                let items = group.assets.map { asset in
                    return CellItem(title: asset.name,
                                    imagePath: asset.image,
                                    description: asset.company)
                }
                sections.append(SectionSnapshot(items: items, section: section))
            }
            return sections
        }
}

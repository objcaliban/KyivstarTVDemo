//
//  AssetDetailsViewModel.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 28.02.2023.
//

import Combine
import UIKit

protocol AssetDetailsViewModelRepresentable {
    var similarAssets: [Asset] { get }
    var assetDetails: AssetDetails? { get }
    var publisher: NotificationCenter.Publisher { get }
    
    func getAssetDetails()
}

class AssetDetailsViewModel: AssetDetailsViewModelRepresentable {
    var similarAssets = [Asset]()
    var assetDetails: AssetDetails?
    lazy var publisher = NotificationCenter.default.publisher(for: loadingNotification,
                                                              object: nil)
    
    private let manager: ApiServicing = ApiService()
    private let loadingNotification = Notification.Name("Loading finished")
    
    
    func getAssetDetails() {
        Task {
            let details = try await self.manager.fetchAssetDetails()
            self.assetDetails = details
            self.similarAssets = details.similar
            NotificationCenter.default.post(name: self.loadingNotification,
                                            object: nil)
        } catch: { error in
            print(error)
        }
    }
}

//
//  HomeCoordinator.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 24.02.2023.
//

import UIKit

class HomeFlowCoordinator: Coordinator {
    private weak var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let vm = HomeViewModel { [weak self] in
            let vm = AssetDetailsViewModel()
            let vc = AssetDetailsViewController(viewModel: vm)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let vc = HomeViewController(viewModel: vm)
        navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

//
//  AppCoordinator.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 24.02.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class AppCoordinator: Coordinator {
    private weak var window: UIWindow?
    private lazy var homeFlowCoordinator: Coordinator = {
        HomeFlowCoordinator(window: window)
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        startHomeFlow()
    }
    
    private func startHomeFlow() {
        homeFlowCoordinator.start()
    }
}


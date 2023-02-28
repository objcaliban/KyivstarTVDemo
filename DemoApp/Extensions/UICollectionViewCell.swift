//
//  UICollectionViewCell.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

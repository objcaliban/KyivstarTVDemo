//
//  AssetDetailsView.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 28.02.2023.
//

import SnapKit
import Kingfisher
import UIKit

class AssetDetailsView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constant.PlayButton.cornerRadius
        button.layer.borderWidth = Constant.PlayButton.borderWidth
        button.layer.borderColor = Constant.PlayButton.borderColor
        button.backgroundColor = Constant.PlayButton.backgroundColor
        
        let imageName = Constant.PlayButton.imageName
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = Constant.FavoriteButton.cornerRadius
        button.layer.borderColor = Constant.FavoriteButton.borderColor
        button.layer.borderWidth = Constant.FavoriteButton.borderWidth
        button.backgroundColor = Constant.FavoriteButton.backgroundColor
        
        let imageName = Constant.FavoriteButton.imageName
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = Constant.Separator.backgroundColor
        return separator
    }()
    
    private(set) var similarCollection: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with details: AssetDetails) {
        imageView.kf.setImage(with: details.image,
                              placeholder: UIImage(named: Constant.errorIconName))
    }
    
    private func createCollectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            let section = AssetDetailsSection.allCases[sectionIndex]
            
            switch section {
            case .info:
                return self.createInfoLayoutSection()
            case .similar:
                return self.createSimilarLayoutSection()
            }
        }
        
        return layout
    }
    
    private func createInfoLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createSimilarLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = Constant.Collection.itemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(156)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(4))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constant.Collection.sectionInset
        return section
    }
    
    private func setupSimilarCollection() {
        let layout = createCollectionLayout()
        similarCollection = UICollectionView(
            frame: .zero, collectionViewLayout: layout
        )
        guard let similarCollection = similarCollection else { return }
        
        addSubview(similarCollection)
        similarCollection.register(
            AssetCell.self,
            forCellWithReuseIdentifier: AssetCell.reuseIdentifier
        )
        similarCollection.register(InfoCell.self,
                                   forCellWithReuseIdentifier: InfoCell.reuseIdentifier)
    }
}

private extension AssetDetailsView {
    private func commonInit() {
        backgroundColor = .white
        addSubviews()
        setupSimilarCollection()
        setupSubviewsConstraints()
    }
    
    private func addSubviews() {
        addSubview(imageView)
        addSubview(playButton)
        addSubview(favoriteButton)
        addSubview(separator)
    }
    
    private func setupSubviewsConstraints() {
        setupImageViewConstraints()
        setupPlayButtonConstraints()
        setupFavoriteButtonConstraints()
        setupSeparatorConstraints()
        setupSimilarCollectionConstraints()
    }
    
    private func setupImageViewConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Constant.imageHeight)
        }
    }
    
    private func setupPlayButtonConstraints() {
        playButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
                .offset(Constant.PlayButton.topSpacing)
            make.left.equalToSuperview()
                .offset(Constant.PlayButton.leftSpacing)
            make.width.equalTo(Constant.PlayButton.width)
            make.height.equalTo(Constant.PlayButton.height)
        }
    }
    
    private func setupFavoriteButtonConstraints() {
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
                .offset(Constant.FavoriteButton.topSpacing)
            make.right.equalToSuperview()
                .offset(-Constant.FavoriteButton.rightSpacing)
            make.width.equalTo(Constant.FavoriteButton.width)
            make.height.equalTo(Constant.FavoriteButton.height)
        }
    }
    
    private func setupSeparatorConstraints() {
        separator.snp.makeConstraints { make in
            make.left.equalToSuperview()
                .offset(Constant.Separator.leftSpacing)
            make.right.equalToSuperview()
                .offset(-Constant.Separator.rightSpacing)
            make.top.equalTo(playButton.snp.bottom)
                .offset(Constant.Separator.topSpacing)
            make.height.equalTo(Constant.Separator.height)
        }
    }
    
    private func setupSimilarCollectionConstraints() {
        similarCollection?.snp.makeConstraints({ make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(separator.snp.bottom).offset(16)
        })
    }
}

// MARK: - Constant

private extension AssetDetailsView {
    private enum Constant {
        static let errorIconName = "error_icon"
        static let imageHeight = 211
        
        enum Collection {
            static let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .estimated(156)
            )
            static let sectionInset =  NSDirectionalEdgeInsets(top: 0,
                                                               leading: 20,
                                                               bottom: 24,
                                                               trailing: 20)
        }
        
        enum PlayButton {
            static let imageName = "PlayButton"
            static let width: CGFloat = 129
            static let height: CGFloat = 40
            static let leftSpacing: CGFloat = 24
            static let topSpacing: CGFloat = 12
            static let borderWidth: CGFloat = 1
            static let cornerRadius: CGFloat = height / 2
            static let borderColor = CGColor(red: 34.0 / 255.0,
                                             green: 159.0 / 255.0,
                                             blue: 255.0 / 255.0,
                                             alpha: 1)
            static let backgroundColor = UIColor(red: 0.0 / 255.0,
                                                 green: 99.0 / 255.0,
                                                 blue: 198.0 / 255.0,
                                                 alpha: 1)
        }
        
        enum FavoriteButton {
            static let imageName = "Vector"
            static let width: CGFloat = 66
            static let height: CGFloat = 40
            static let rightSpacing: CGFloat = 23
            static let topSpacing: CGFloat = 12
            static let borderWidth: CGFloat = 1
            static let cornerRadius: CGFloat = height / 2
            static let borderColor = CGColor(red: 254.0 / 255.0,
                                             green: 254.0 / 255.0,
                                             blue: 254.0 / 255.0,
                                             alpha: 1)
            static let backgroundColor = UIColor(red: 233.0 / 255.0,
                                                 green: 231.0 / 255.0,
                                                 blue: 231.0 / 255.0,
                                                 alpha: 1)
        }
        
        enum Separator {
            static let height: CGFloat = 1
            static let leftSpacing: CGFloat = 24
            static let rightSpacing: CGFloat = 23
            static let topSpacing: CGFloat = 16
            static let backgroundColor = UIColor(red: 233.0 / 255.0,
                                                 green: 231.0 / 255.0,
                                                 blue: 231.0 / 255.0,
                                                 alpha: 1)
        }
    }
}

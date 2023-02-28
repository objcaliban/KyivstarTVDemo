//
//  Categories.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import UIKit

class CategoriesCell: UICollectionViewCell {
    private let containerView = UIView()
    
    private var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Image.cornerRadius
        
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(imagePath: URL, title: String) {
        categoryImageView.kf.setImage(with: imagePath,
                                      placeholder: UIImage(named: Constant.errorIconName))
        categoryLabel.text = title
    }
}

extension CategoriesCell {
    private func setupConstraints() {
        setupSubviews()
        
        setupContainerViewConstraints()
        setupCategoryImageViewConstraints()
        setupCategoryLabelConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(categoryImageView)
        containerView.addSubview(categoryLabel)
    }
    
    private func setupContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupCategoryImageViewConstraints() {
        categoryImageView.snp.makeConstraints { make in
            make.height.equalTo(Constant.Image.height)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constant.Image.horisontalSpacing)
            make.right.equalToSuperview().offset(-Constant.Image.horisontalSpacing)
        }
    }
    
    private func setupCategoryLabelConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryImageView.snp.bottom).offset(Constant.Title.topSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CategoriesCell {
    enum Constant {
        static let errorIconName = "error_icon"
        
        enum Image {
            static let cornerRadius = 16.0
            
            static let verticalSpacing = 8.0
            static let horisontalSpacing = 4.0
            static let height = 104.0
        }
        
        enum Title {
            static let topSpacing = 8.0
        }
    }
}

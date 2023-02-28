//
//  PromotionsCell.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 25.02.2023.
//

import Kingfisher
import SnapKit
import UIKit

class PromotionCell: UICollectionViewCell {
    private let containerView = UIView()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.Poster.cornerRadius
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with imagePath: URL) {
        posterImageView.kf.setImage(with: imagePath,
                                    placeholder: UIImage(named: Constant.errorIconName))
    }
}

extension PromotionCell {
    private func setupConstraints() {
        setupSubviews()
        setupContainerViewConstraints()
        setupPosterImageViewConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
    }
    
    private func setupContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupPosterImageViewConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.height.equalTo(Constant.Poster.height)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constant.Poster.bottomSpacing)
            make.left.equalToSuperview().offset(Constant.Poster.horisontalSpacing)
            make.right.equalToSuperview().offset(-Constant.Poster.horisontalSpacing)
        }
    }
}

extension PromotionCell {
    enum Constant {
        static let errorIconName = "error_icon"
        
        enum Poster {
            static let cornerRadius = 16.0
            
            static let bottomSpacing = 14.0
            static let horisontalSpacing = 24.0
            static let height = 180.0
        }
    }
}

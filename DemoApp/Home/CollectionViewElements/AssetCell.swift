//
//  AssetCell.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 27.02.2023.
//

import GradientProgressBar
import UIKit

class AssetCell: UICollectionViewCell {
    private let containerView = UIView()
    
    private let progressView: GradientProgressBar = {
        let progressView = GradientProgressBar()
        progressView.gradientColors = [
            GradientProgressBar.firstGradientColor,
            GradientProgressBar.secondGradientColor
        ]
        progressView.backgroundColor = GradientProgressBar.backgroundColor
        progressView.setProgress(1, animated: true)
        
        return progressView
    }()
    
    private let assetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.View.cornerRadius
        
        return imageView
    }()
    
    private let lockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lock"))
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with imagePath: URL, title: String = "", isPurchased: Bool) {
        posterImageView.kf.setImage(with: imagePath,
                                    placeholder: UIImage(named: Constant.errorIconName))
        lockImageView.isHidden = isPurchased
        assetLabel.text = title
    }
}

extension AssetCell {
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(lockImageView)
        posterImageView.addSubview(progressView)
        containerView.addSubview(assetLabel)
    }
    
    private func setupSubviewsConstraints() {
        setupContainerViewConstraints()
        setupPosterImageViewConstraints()
        setupLockedImageViewConstraints()
        setupProgressViewConstraints()
        setupAssertLabelConstraints()
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
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constant.PosterImage.horizontalSpacing)
            make.right.equalToSuperview().offset(-Constant.PosterImage.horizontalSpacing)
            make.height.equalTo(Constant.PosterImage.height)
        }
    }
    
    private func setupLockedImageViewConstraints() {
        lockImageView.snp.makeConstraints { make in
            make.height.equalTo(Constant.LockImage.sideSize)
            make.width.equalTo(Constant.LockImage.sideSize)
            make.left.equalTo(containerView.snp.left)
                .offset(Constant.LockImage.leftSpacing)
            make.top.equalTo(containerView.snp.top)
                .offset(Constant.LockImage.topSpacing)
        }
    }
    
    private func setupAssertLabelConstraints() {
        assetLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(Constant.Title.topSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupProgressViewConstraints() {
        progressView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalTo(posterImageView.snp.bottom)
            make.right.equalTo(posterImageView.snp.right)
            make.height.equalTo(Constant.ProgressView.height)
        }
    }

}

extension AssetCell {
    private enum Constant {
        static let errorIconName = "error_icon"
        enum View {
            static let cornerRadius: CGFloat = 15
        }
        
        enum PosterImage {
            static let height = 156.0
            static let horizontalSpacing = 4.0
        }
        
        enum LockImage {
            static let imageName = "Lock"
            static let sideSize: CGFloat = 24
            static let topSpacing: CGFloat = 8
            static let leftSpacing: CGFloat = 8
        }
        
        enum ProgressView {
            static let height: CGFloat = 4
        }
        
        enum Title {
            static let topSpacing = 8.0
        }
    }
}

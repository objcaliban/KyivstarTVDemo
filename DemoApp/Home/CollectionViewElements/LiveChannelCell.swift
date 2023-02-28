//
//  LiveChanelCell.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import UIKit

class LiveChannelCell: UICollectionViewCell {
    private let containerView = UIView()
    
    private let channelImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Unknown"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.ChannelImage.cornerRadius
        return imageView
    }()
    
    private let lockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lock"))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lockImageView.isHidden = true
    }
    
    func setup(imagePath: URL, isPurchased: Bool) {
        lockImageView.isHidden = isPurchased
        channelImageView.kf.setImage(with: imagePath,
                                     placeholder: UIImage(named: Constant.errorIconName))
    }
}

extension LiveChannelCell {
    enum Constant {
        static let errorIconName = "error_icon"
        
        enum ChannelImage {
            static let cornerRadius = 52.0
            
            static let verticalSpacing = 8.0
            static let horisontalSpacing = 4.0
            static let height = 104.0
        }
        
        enum LockImage {
            static let height = 32.0
        }
    }
}

extension LiveChannelCell {
    private func setupConstraints() {
        setupSubviews()
        
        setupContainerViewConstraints()
        setupChannelImageViewConstraints()
        setupLockImageViewConstraints()
    }
    
    private func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(channelImageView)
        contentView.addSubview(lockImageView)
    }
    
    private func setupContainerViewConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupChannelImageViewConstraints() {
        channelImageView.snp.makeConstraints { make in
            make.height.equalTo(Constant.ChannelImage.height)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constant.ChannelImage.horisontalSpacing)
            make.right.equalToSuperview().offset(-Constant.ChannelImage.horisontalSpacing)
        }
    }
    
    private func setupLockImageViewConstraints() {
        lockImageView.snp.makeConstraints { make in
            make.top.equalTo(channelImageView.snp.top)
            make.left.equalTo(channelImageView.snp.left)
            make.height.equalTo(Constant.LockImage.height)
            make.width.equalTo(Constant.LockImage.height)
        }
    }
}

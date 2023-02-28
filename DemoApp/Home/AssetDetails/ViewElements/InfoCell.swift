//
//  InfoCell.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 28.02.2023.
//

import UIKit

class InfoCell: UICollectionViewCell {
    private let assetTitle: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 22)
        title.numberOfLines = 0
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        title.numberOfLines = 0
        title.textColor = .gray
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with title: String, description: String) {
        assetTitle.text =  title != "" ? title : "Unnamed"
        descriptionLabel.text = description
    }
    
    private func setupConstraints() {
        addSubviews()
        setupTitleConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(assetTitle)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupTitleConstraints() {
        assetTitle.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(7)
            make.top.equalToSuperview()
        })
    }
    
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints({ make in
            make.left.equalTo(assetTitle.snp.left)
            make.right.equalTo(assetTitle.snp.right)
            make.top.equalTo(assetTitle.snp.bottom)
            make.bottom.equalToSuperview()
        })
    }
}

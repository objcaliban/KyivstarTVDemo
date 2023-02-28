//
//  HomeHeaderView.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    var deleteCallback: (() -> Void)?
    
    private let headerTitle: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16)
        return title
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Del", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupButtonTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.isHidden = true
    }
    
    func setup(with title: String, isCanBeDeleted: Bool) {
        headerTitle.text = title
        deleteButton.isHidden = !isCanBeDeleted
    }
    
    private func setupButtonTarget() {
        deleteButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc private func buttonAction() {
        deleteCallback?()
    }
}

extension HomeHeaderView {
    private func setupConstraints() {
        addSubviews()
        setupTitleConstraints()
        setupButtonConstraints()
    }
    
    private func addSubviews() {
        addSubview(headerTitle)
        addSubview(deleteButton)
    }
    
    private func setupTitleConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
    
    private func setupButtonConstraints() {
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-Constant.buttonRightSpacing)
        }
    }
}

extension HomeHeaderView {
    private enum Constant {
        static let buttonRightSpacing = 25.0
    }
}

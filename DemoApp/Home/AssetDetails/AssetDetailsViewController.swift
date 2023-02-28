//
//  AssetDetailsViewController.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 28.02.2023.
//

import Combine
import UIKit

class AssetDetailsViewController: UIViewController {
    private var contentView = AssetDetailsView()
    private var viewModel: AssetDetailsViewModelRepresentable
    private var subscription: AnyCancellable?
    
    init(viewModel: AssetDetailsViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupContentView()
        viewModel.getAssetDetails()
        subscribeAssetDetails()
    }
    
    private func subscribeAssetDetails() {
        subscription = viewModel.publisher.sink { [weak self] _ in
            DispatchQueue.main.async {
                guard let assetDetails = self?.viewModel.assetDetails else { return }
                self?.contentView.similarCollection?.reloadData()
                self?.contentView.setup(with: assetDetails)
            }
            self?.subscription?.cancel()
        }
    }
}

private extension AssetDetailsViewController {
    private func setupContentView() {
        contentView.similarCollection?.dataSource = self
        view = contentView
    }
}

extension AssetDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.similarAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.reuseIdentifier, for: indexPath) as? InfoCell else {
                return UICollectionViewCell()
            }
            cell.setup(with: viewModel.assetDetails?.name ?? "",
                       description: viewModel.assetDetails?.description ?? "")
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCell.reuseIdentifier, for: indexPath) as? AssetCell else {
            return UICollectionViewCell()
        }
        let similarAsset = viewModel.similarAssets[indexPath.row]
        cell.setup(with: similarAsset.image,
                   isPurchased: similarAsset.purchased)
        return cell
    }
}

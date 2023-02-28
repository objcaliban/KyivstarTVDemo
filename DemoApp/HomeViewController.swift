//
//  ViewController.swift
//  DemoApp
//
//  Created by Pete Shpagin on 31.03.2021.
//

import Combine
import SnapKit
import UIKit

class HomeViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, CellItem>
    
    var sections = CurrentValueSubject<[HomeSection], Never>([])
    
    var newPromotionPage = 0
    var snapshot = NSDiffableDataSourceSnapshot<HomeSection, CellItem>()
    
    private weak var promotionsPageControlDelegate: PromotionsPageControlDelegate?
    private var viewModel: HomeViewModelRepresentable
    private var contentView = HomeView()
    
    private let kyivstarTVImageView: UIImageView = {
        let image = UIImage(named: Constant.kyivstarTVImageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: contentView.collectionView) {
            (collectionView, indexPath, cellItem) -> UICollectionViewCell? in
            
            let section = self.viewModel.getSections()[indexPath.section].type
            switch section {
            case .promotion:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PromotionCell.reuseIdentifier,
                    for: indexPath
                ) as? PromotionCell else { return UICollectionViewCell() }
                cell.setup(with: cellItem.imagePath)
                return cell
                
            case .categories:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CategoriesCell.reuseIdentifier,
                    for: indexPath
                ) as? CategoriesCell else { return UICollectionViewCell() }
                cell.setup(imagePath: cellItem.imagePath, title: cellItem.title)
                return cell
                
            case .movieSeriesGroup:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AssetCell.reuseIdentifier,
                    for: indexPath
                ) as? AssetCell else { return UICollectionViewCell() }
                cell.setup(with: cellItem.imagePath,
                           title: cellItem.title,
                           isPurchased: cellItem.isPurchased ?? false)
                return cell
                
            case .liveChannel:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: LiveChannelCell.reuseIdentifier,
                    for: indexPath
                ) as? LiveChannelCell else { return UICollectionViewCell() }
                cell.setup(imagePath: cellItem.imagePath,
                           isPurchased: cellItem.isPurchased ?? false)
                return cell
                
            case .epg:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EPGCell.reuseIdentifier,
                    for: indexPath
                ) as? EPGCell else { return UICollectionViewCell() }
                cell.setup(with: cellItem.imagePath,
                           title: cellItem.title,
                           description: cellItem.description ?? "",
                           isPurchased: cellItem.isPurchased ?? false)
                return cell
            }
        }
        return dataSource
    }()
    
    init(viewModel: HomeViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        promotionsPageControlDelegate = contentView
        
        contentView.sectionsProvider = viewModel
        contentView.collectionView.delegate = self
        
        navigationItem.titleView = kyivstarTVImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSupplementaryView()
        viewModel.loadSections()
        subscribeSections()
    }
    
    private func subscribeSections() {
        viewModel.publishedSections.sink { completion in
            print(completion)
        } receiveValue: { [weak self] snapshots in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let sections = snapshots.map { $0.section }
                self.snapshot.appendSections(sections)
                self.sections.send(sections)
                snapshots.forEach { snapshot in
                    self.snapshot.appendItems(
                        snapshot.items,
                        toSection: snapshot.section
                    )
                }
                self.dataSource.apply(self.snapshot)
                self.promotionsPageControlDelegate?.shouldUpdateNumberOfPages()
                
            }
        }.store(in: &viewModel.subscriptions)
    }
    
    private func configureSupplementaryView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeHeaderView.reuseIdentifier,
                for: indexPath) as? HomeHeaderView else {
                return UICollectionReusableView()
            }
            let section = self.viewModel.getSections()[indexPath.section]
            header.setup(
                with: section.title,
                isCanBeDeleted: section.canBeDeleted ?? false
            )
            header.deleteCallback = {
                self.viewModel.removeSection(named: section.title)
                self.snapshot.deleteSections([section])
                self.dataSource.apply(self.snapshot)
            }
            
            return header
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.openAssetDetails()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if newPromotionPage != indexPath.row {
            promotionsPageControlDelegate?.move(to: newPromotionPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            newPromotionPage = indexPath.row
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentView.collectionViewStartOffset == 0.0 {
            contentView.collectionViewStartOffset = scrollView.contentOffset.y
        }
        
        let newOffset = (contentView.collectionViewStartOffset - scrollView.contentOffset.y)
        promotionsPageControlDelegate?.offsetChanged(to: newOffset)
    }
}

extension HomeViewController {
    private enum Constant {
        static let kyivstarTVImageName = "kyivstarTV_logo"
    }
}

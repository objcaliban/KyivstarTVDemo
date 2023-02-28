//
//  HomeView.swift
//  DemoApp
//
//  Created by Anastasiia Yefremova on 26.02.2023.
//

import UIKit

protocol PromotionsPageControlDelegate: AnyObject {
    var collectionViewStartOffset: CGFloat { get set }
    func move(to page: Int)
    func offsetChanged(to points: CGFloat)
    func shouldUpdateNumberOfPages()
}

class HomeView: UIView {
    var collectionViewStartOffset: CGFloat = 0.0
    var sectionsProvider: SectionsProvider!
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: createCollectionLayout()
        )
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(collectionView)
        addSubview(pageControl)
        bringSubviewToFront(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(Constant.pageControlTopOffset)
        }
        registerCollectionViewElements()
    }
    
    private func registerCollectionViewElements() {
        collectionView.register(
            PromotionCell.self,
            forCellWithReuseIdentifier: PromotionCell.reuseIdentifier
        )
        collectionView.register(
            CategoriesCell.self,
            forCellWithReuseIdentifier: CategoriesCell.reuseIdentifier
        )
        collectionView.register(
            AssetCell.self,
            forCellWithReuseIdentifier: AssetCell.reuseIdentifier
        )
        collectionView.register(
            LiveChannelCell.self,
            forCellWithReuseIdentifier: LiveChannelCell.reuseIdentifier
        )
        collectionView.register(
            EPGCell.self,
            forCellWithReuseIdentifier: EPGCell.reuseIdentifier
        )
        collectionView.register(
            HomeHeaderView.self,
            forSupplementaryViewOfKind: Constant.Header.headerElementKind,
            withReuseIdentifier: HomeHeaderView.reuseIdentifier
        )
    }
    
    private func createCollectionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil }
            let section = self.sectionsProvider.getSections()[sectionIndex].type
            
            switch section {
            case .promotion:
                return self.createPromotionLayoutSection()
            case .categories:
                return self.createCategoriesLayout()
            case .liveChannel:
                return self.createLiveChannelLayout()
            case .movieSeriesGroup:
                return self.createMovieSeriesLayout()
            case .epg:
                return self.createEPGLayout()
            }
        }
        
        return layout
    }
    
    private func createPromotionLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Sections.promotionHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Sections.promotionHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
    
    private func createCategoriesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.categoriesWidth),
            heightDimension: .absolute(Constant.Sections.categoriesHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.categoriesWidth),
            heightDimension: .absolute(Constant.Sections.categoriesHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Header.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constant.Header.headerElementKind,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Sections.leadingInset,
            bottom: Constant.Sections.categoriesBottomSpacing,
            trailing: 0
        )
        
        return section
    }
    
    private func createMovieSeriesLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.assetsWidth),
            heightDimension: .absolute(Constant.Sections.assetsHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.assetsWidth),
            heightDimension: .absolute(Constant.Sections.assetsHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Header.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constant.Header.headerElementKind,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Sections.leadingInset,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
    
    private func createLiveChannelLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.categoriesWidth),
            heightDimension: .absolute(Constant.Sections.categoriesHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.categoriesWidth),
            heightDimension: .absolute(Constant.Sections.categoriesHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Header.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constant.Header.headerElementKind,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Sections.leadingInset,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
    
    private func createEPGLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Constant.Sections.epgWidth),
            heightDimension: .absolute(Constant.Sections.epgHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize,
                                                       subitem: item,
                                                       count: 1)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Constant.Header.headerHeight)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: Constant.Header.headerElementKind,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constant.Sections.leadingInset,
            bottom: 0,
            trailing: 0
        )
        
        return section
    }
}

extension HomeView: PromotionsPageControlDelegate {
    func move(to page: Int) {
        pageControl.currentPage = page
    }
    
    func offsetChanged(to offset: CGFloat) {
        pageControl.snp.updateConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(
                Constant.pageControlTopOffset + offset
            )
        }
    }
    
    func shouldUpdateNumberOfPages() {
        DispatchQueue.main.async { [self] in
            pageControl.numberOfPages = collectionView.numberOfItems(inSection: 0)
        }
    }
}

extension HomeView {
    private enum Constant {
        static let pageControlTopOffset = 157.0
        
        enum Header {
            static let headerElementKind = "section-title-header"
            static let headerHeight = 32.0
        }
        
        enum Sections {
            static let promotionHeight = 194.0
            static let leadingInset = 20.0
            
            static let categoriesHeight = 136.0
            static let categoriesWidth = 112.0
            static let categoriesBottomSpacing = 30.0
            
            static let assetsHeight = 240.0
            static let assetsWidth = 120.0
            
            static let liveChannelHeight = 144.0
            static let liveChannelWidth = 112.0
            
            static let epgHeight = 190.0
            static let epgWidth = 216.0
        }
    }
}

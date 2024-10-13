//
//  HomeViewController.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import UIKit

import SnapKit
import Then
import ReactorKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController, View {

    var disposeBag: DisposeBag = DisposeBag()

    var collectionView: UICollectionView!

    private var diffableDataSource: UICollectionViewDiffableDataSource<ContentType, Item>!
    private var snapshot: NSDiffableDataSourceSnapshot<ContentType, Item>!

    func bind(reactor: HomeReactor) {
        setupUI()
        bindAction(reactor)
        bindState(reactor)
    }

    func bindAction(_ reactor: HomeReactor) {
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindState(_ reactor: HomeReactor) {
        reactor.state
            .compactMap { $0.products }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, entity in
                owner.configureInitialSnapshot(sections: entity.data)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {
}

extension HomeViewController {

    func configureCellRegistrationAndDataSource() {
        let bannerCellRegistration = UICollectionView.CellRegistration<BannerCollectionCell, Item> { cell, _, item in
            var imageURL: String?
            if let banner = item.banner {
                imageURL = banner.thumbnailURL
            } else if let goods = item.goods {
                imageURL = goods.thumbnailURL
            } else if let style = item.style {
                imageURL = style.thumbnailURL
            }
            cell.apply(imageURL: imageURL)
        }

        diffableDataSource = UICollectionViewDiffableDataSource<ContentType, Item>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(
                    using: bannerCellRegistration,
                    for: indexPath,
                    item: item
                )
            }
        )
    }

    func configureSupplementaryViewRegistrationAndDataSource() {
        let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionResusableView>(elementKind: String(describing: HeaderCollectionResusableView.self)) { supplementaryView, elementKind, indexPath in
            supplementaryView.backgroundColor = .red
        }
        let footerRegistration = UICollectionView.SupplementaryRegistration<FooterCollectionResusableView>(elementKind: String(describing: FooterCollectionResusableView.self)) { supplementaryView, elementKind, indexPath in
            supplementaryView.backgroundColor = .blue
        }
        diffableDataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case String(describing: HeaderCollectionResusableView.self):
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerRegistration,
                    for: indexPath
                )
            case String(describing: FooterCollectionResusableView.self):
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration,
                    for: indexPath
                )
            default:
                return UICollectionReusableView()
            }
        }
    }

    func configureInitialSnapshot(sections: [ProductListEntity.Datum]) {
        snapshot = NSDiffableDataSourceSnapshot<ContentType, Item>()

        for section in sections {
            snapshot.appendSections([section.contents.type])
            var items: [Item]
            if let _banners = section.contents.banners {
                items = _banners.map { .init(banner: $0) }
                snapshot.appendItems(items)
            }
            if let _goods = section.contents.goods {
                items = _goods.map { .init(goods: $0) }
                snapshot.appendItems(items)
            }
            if let _styles = section.contents.styles {
                items = _styles.map { .init(style: $0) }
                snapshot.appendItems(items)
            }
        }

        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }

    func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let content = self.reactor?.currentState.products?.data[sectionIndex]
            let contentType: ContentType = content?.contents.type ?? .banner
            let headerType: HeaderType? = content?.header?.type
            let footerType: FooterType? = content?.footer?.type
            switch contentType {
            case .banner:
                return self.getBannerLayout(headerType: headerType, footerType: footerType)
            case .grid:
                return self.getBannerLayout(headerType: headerType, footerType: footerType)
            case .scroll:
                return self.getBannerLayout(headerType: headerType, footerType: footerType)
            case .style:
                return self.getBannerLayout(headerType: headerType, footerType: footerType)
            }
        }
    }

    func getBannerLayout(headerType: HeaderType?, footerType: FooterType?) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize: NSCollectionLayoutSize = .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let section = NSCollectionLayoutSection(group: .horizontal(layoutSize: groupSize, subitems: [item]))
        section.orthogonalScrollingBehavior = .continuous

        var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
        if let _ = headerType {
            let headerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
            let header: NSCollectionLayoutBoundarySupplementaryItem = .init(
                layoutSize: headerSize,
                elementKind: String(describing: HeaderCollectionResusableView.self),
                alignment: .top
            )
            boundarySupplementaryItems.append(header)
        }
        if let _ = footerType {
            let footerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: String(describing: FooterCollectionResusableView.self),
                alignment: .bottom
            )
            boundarySupplementaryItems.append(footer)
        }
        section.boundarySupplementaryItems = boundarySupplementaryItems

        return section
    }

    func setupUI() {
        view.backgroundColor = .yellow

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: getLayout()
        ).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = true
            $0.scrollIndicatorInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 4)
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.delegate = self
        }

        configureCellRegistrationAndDataSource()
        configureSupplementaryViewRegistrationAndDataSource()

        setupLayouts()
    }

    func setupLayouts() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

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

    private var diffableDataSource: DiffableDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionKind, Item>!

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionKind, Item>
    private typealias BannerCellRegistration = UICollectionView.CellRegistration<BannerCollectionCell, Item>
    private typealias ProductCellRegistration = UICollectionView.CellRegistration<ProductCollectionCell, Item>
    private typealias StyleCellRegistration = UICollectionView.CellRegistration<StyleCollectionCell, Item>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionResusableView>
    private typealias FooterRegistration = UICollectionView.SupplementaryRegistration<FooterCollectionResusableView>

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
            .map { $0.sections }
            .filter { $0.count > 0 }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, sections in
                let state = reactor.currentState

                owner.snapshot = NSDiffableDataSourceSnapshot<SectionKind, Item>()

                for (index, section) in sections.enumerated() {
                    owner.snapshot.appendSections([section.kind])

                    var endItemCnt = state.currentPages[index] * section.kind.itemsPerPage
                    if endItemCnt == 0 || endItemCnt > section.items.count {
                        endItemCnt = section.items.count
                    }
                    let items = Array(section.items[0..<endItemCnt])
                    owner.snapshot.appendItems(items)
                }

                owner.diffableDataSource.apply(owner.snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.currentPages }
            .filter { $0.count > 0 }
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, currentPage in
                for (sectionIndex, currentPage) in currentPage.enumerated() {
                    let prevPage = reactor.currentState.prevPages[sectionIndex]
                    guard prevPage < currentPage else {
                        continue
                    }
                    let section = reactor.currentState.sections[sectionIndex]
                    var endItemCnt = section.kind.itemsPerPage * currentPage

                    if endItemCnt > section.items.count {
                        endItemCnt = section.items.count
                    }

                    let startItemIdx = prevPage * section.kind.itemsPerPage
                    let items = Array(section.items[startItemIdx..<endItemCnt])
                    owner.snapshot.appendItems(items, toSection: section.kind)
                    owner.diffableDataSource.apply(owner.snapshot, animatingDifferences: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {
}

extension HomeViewController {

    func configureCellRegistrationAndDataSource() {
        let bannerCellRegistration = BannerCellRegistration { cell, _, item in
            guard let banner = item.banner else {
                return
            }
            let imageURL = banner.thumbnailURL
            cell.apply(imageURL: imageURL)
        }
        let productCellRegistration = ProductCellRegistration { cell, _, item in
            guard let goods = item.goods else {
                return
            }
            let imageURL = goods.thumbnailURL
            cell.apply(imageURL: imageURL)
        }
        let styleCellRegistration = StyleCellRegistration { cell, _, item in
            guard let style = item.style else {
                return
            }
            let imageURL = style.thumbnailURL
            cell.apply(imageURL: imageURL)
        }

        diffableDataSource = DiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                if let _ = item.banner {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: bannerCellRegistration,
                        for: indexPath,
                        item: item
                    )
                } else if let _ = item.goods {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: productCellRegistration,
                        for: indexPath,
                        item: item
                    )
                } else {
                    return collectionView.dequeueConfiguredReusableCell(
                        using: styleCellRegistration,
                        for: indexPath,
                        item: item
                    )
                }
            }
        )
    }

    func configureSupplementaryViewRegistrationAndDataSource() {
        let headerRegistration = HeaderRegistration(elementKind: String(describing: HeaderCollectionResusableView.self)) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self,
                  let reactor = self.reactor else {
                return
            }
            let state = reactor.currentState
            let section = state.sections[indexPath.section]

            if let header = section.header {
                supplementaryView.apply(
                    title: header.title,
                    iconURL: header.iconURL,
                    linkURL: header.linkURL
                )
            }
        }
        let footerRegistration = FooterRegistration(elementKind: String(describing: FooterCollectionResusableView.self)) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self,
                  let reactor = self.reactor else {
                return
            }
            let state = reactor.currentState

            supplementaryView.backgroundColor = .white
            let section = state.sections[indexPath.section]
            guard let footerType: FooterType = section.footer?.type else {
                return
            }
            supplementaryView.apply(
                footerType: footerType,
                iconURL: section.footer?.iconURL
            )

            switch footerType {
            case .more:
                supplementaryView.button.rx.tap
                    .filter {
                        state.sections[indexPath.section].items.count > state.currentPages[indexPath.section] * state.sections[indexPath.section].kind.itemsPerPage
                    }
                    .observe(on: MainScheduler.asyncInstance)
                    .map { Reactor.Action.moreButtonDidTap(sectionIndex: indexPath.section) }
                    .bind(to: reactor.action)
                    .disposed(by: supplementaryView.disposeBag)
            case .refresh:
                supplementaryView.button.rx.tap
                    .observe(on: MainScheduler.asyncInstance)
                    .map { Reactor.Action.refreshButtonDidTap(sectionIndex: indexPath.section) }
                    .bind(to: reactor.action)
                    .disposed(by: supplementaryView.disposeBag)
            }

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

    func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self,
                  let state = self.reactor?.currentState else {
                return nil
            }

            let sectionModel = state.sections[sectionIndex]

            var layoutSection: NSCollectionLayoutSection
            switch sectionModel.kind {
            case .banner:
                layoutSection = self.getBannerLayout()
            case .grid:
                layoutSection = self.getGridLayout()
            case .scroll:
                layoutSection = self.getScrollLayout()
            case .style:
                layoutSection = self.getStyleLayout()
            }

            var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
            if sectionModel.header != nil {
                let headerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
                let header: NSCollectionLayoutBoundarySupplementaryItem = .init(
                    layoutSize: headerSize,
                    elementKind: String(describing: HeaderCollectionResusableView.self),
                    alignment: .top
                )
                boundarySupplementaryItems.append(header)
            }
            if sectionModel.footer != nil,
               sectionModel.items.count > state.currentPages[sectionIndex] * sectionModel.kind.itemsPerPage {

                let footerSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: String(describing: FooterCollectionResusableView.self),
                    alignment: .bottom
                )
                boundarySupplementaryItems.append(footer)
            }
            layoutSection.boundarySupplementaryItems = boundarySupplementaryItems

            return layoutSection
        }
    }

    func getBannerLayout() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        ))
        let mainGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        return section
    }

    func getGridLayout() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        ))
        let mainGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.53)
            ),
            subitems: [item, item, item]
        )
        let section: NSCollectionLayoutSection = .init(group: mainGroup)
        section.orthogonalScrollingBehavior = .none

        return section
    }

    func getScrollLayout() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1)
        ))

        let mainGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .estimated(UIScreen.main.bounds.width),
                heightDimension: .fractionalWidth(1/3)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    func getStyleLayout() -> NSCollectionLayoutSection {
        let itemA: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2)
        ))
        itemA.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        let vGroup: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitems: [itemA, itemA]
        )

        let itemB: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1)
        ))
        let hGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(2/3)
            ),
            subitems: [itemB, vGroup]
        )

        let itemC: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        ))
        let hGroupB: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)
            ),
            subitems: [itemC, itemC, itemC]
        )
        let mainVGroup: NSCollectionLayoutGroup = .vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(11/8)
            ),
            subitems: [hGroup, hGroupB]
        )
        let section = NSCollectionLayoutSection(group: mainVGroup)
        section.orthogonalScrollingBehavior = .none

        return section
    }

    func setupUI() {
        view.backgroundColor = .systemBackground

        configureCollectionView()
    }

    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: getLayout()
        ).then {
            $0.isScrollEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = true
            $0.contentInset = .zero
            $0.backgroundColor = .clear
            $0.clipsToBounds = true
            $0.delegate = self
        }

        configureCellRegistrationAndDataSource()
        configureSupplementaryViewRegistrationAndDataSource()

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

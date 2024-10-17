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

    // View Properties
    private var collectionView: UICollectionView!
    private var diffableDataSource: DiffableDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionKind, Item>!

    // Typealias
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionKind, Item>
    private typealias BannerCellRegistration = UICollectionView.CellRegistration<BannerCollectionCell, Item>
    private typealias ProductCellRegistration = UICollectionView.CellRegistration<ProductCollectionCell, Item>
    private typealias StyleCellRegistration = UICollectionView.CellRegistration<StyleCollectionCell, Item>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderCollectionResusableView>
    private typealias FooterRegistration = UICollectionView.SupplementaryRegistration<FooterCollectionResusableView>
    private typealias PageFooterRegistration = UICollectionView.SupplementaryRegistration<PageFooterCollectionReusableView>

    // Constants
    private let sectionContentsInset: NSDirectionalEdgeInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
    private let itemContentsInset: NSDirectionalEdgeInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
    private let headerHeightDimension: NSCollectionLayoutDimension = .absolute(80)
    private let footerHeightDimension: NSCollectionLayoutDimension = .absolute(80)
    private let bannerFooterHeightDimension: NSCollectionLayoutDimension = .absolute(0.1)

    // Auto Sliding
    private var timer: Timer?
    public var automaticSlidingInterval: CGFloat = 0.0 {
        didSet {
            self.cancelTimer()
            if self.automaticSlidingInterval > 0 {
                self.startTimer()
            }
        }
    }

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
                owner.automaticSlidingInterval = 3
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

    // MARK: Auto Sliding

    private func startTimer() {
        guard self.automaticSlidingInterval > 0 && self.timer == nil else {
            return
        }
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.automaticSlidingInterval),
                                          target: self,
                                          selector: #selector(self.flipNext(sender:)),
                                          userInfo: nil,
                                          repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
    }

    @objc
    private func flipNext(sender: Timer?) {
        guard let state = reactor?.currentState,
        let bannerCount = state.sections.filter({ $0.kind == .banner }).first?.items.count,
            bannerCount > 1 else {
                return
            }
        let currentPage = state.bannerPageIndex
        var nextPage = currentPage + 1
        var animated: Bool = true
        if nextPage >= bannerCount {
            nextPage = nextPage % bannerCount
            animated = false
        }
        collectionView.scrollToItem(at: IndexPath(item: nextPage, section: 0), at: .left, animated: animated)
    }

    private func cancelTimer() {
        guard self.timer != nil else {
            return
        }
        self.timer!.invalidate()
        self.timer = nil
    }
}

extension HomeViewController {

    // MARK: UI setup

    func setupUI() {
        view.backgroundColor = .systemBackground

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

extension HomeViewController {

    // MARK: DiffableDataSource

    func configureCellRegistrationAndDataSource() {
        let bannerCellRegistration = BannerCellRegistration { cell, indexPath, item in
            guard let banner = item.banner else {
                return
            }
            cell.apply(
                imageURL: banner.thumbnailURL,
                title: banner.title,
                subTitle: banner.description
            )
        }
        let productCellRegistration = ProductCellRegistration { cell, _, item in
            guard let goods = item.goods else {
                return
            }
            cell.apply(
                imageURL: goods.thumbnailURL,
                brandName: goods.brandName,
                price: goods.price,
                saleRate: goods.saleRate,
                hasCoupone: goods.hasCoupon
            )
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
            guard let footerType: FooterType = section.footer?.type,
                  let footerViewType = FooterCollectionResusableView.FooterType(rawValue: footerType.rawValue) else {
                return
            }

            supplementaryView.apply(
                footerType: footerViewType,
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
        let pageFooterRegistration = PageFooterRegistration(elementKind: String(describing: PageFooterCollectionReusableView.self)) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self,
                  let reactor = self.reactor else {
                return
            }

            let bannerCnt = reactor.currentState.sections[indexPath.section].items.count
            reactor.state
                .map { $0.bannerPageIndex }
                .asObservable()
                .map { "\($0 + 1)/\(bannerCnt)" }
                .bind(to: supplementaryView.pageNumberLabel.rx.text)
                .disposed(by: supplementaryView.disposeBag)

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
            case String(describing: PageFooterCollectionReusableView.self):
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: pageFooterRegistration,
                    for: indexPath
                )
            default:
                return UICollectionReusableView()
            }
        }
    }
}

extension HomeViewController {

    // MARK: Compositional Layout

    func getLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self,
                  let state = self.reactor?.currentState else {
                return nil
            }

            let sectionModel = state.sections[sectionIndex]

            // Set layout sections
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

            // Set boundary supplementary
            var boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
            if sectionModel.header != nil {
                let headerSize: NSCollectionLayoutSize = .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: headerHeightDimension
                )
                let header: NSCollectionLayoutBoundarySupplementaryItem = .init(
                    layoutSize: headerSize,
                    elementKind: String(describing: HeaderCollectionResusableView.self),
                    alignment: .top
                )
                boundarySupplementaryItems.append(header)
            }
            if sectionModel.footer != nil,
               sectionModel.items.count > state.currentPages[sectionIndex] * sectionModel.kind.itemsPerPage {

                let footerSize: NSCollectionLayoutSize = .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: footerHeightDimension
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: String(describing: FooterCollectionResusableView.self),
                    alignment: .bottom
                )
                boundarySupplementaryItems.append(footer)
            }
            if sectionModel.kind == .banner {
                let pageFooterSize: NSCollectionLayoutSize = .init(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: bannerFooterHeightDimension
                )
                let pageFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: pageFooterSize,
                    elementKind: String(describing: PageFooterCollectionReusableView.self),
                    alignment: .bottom
                )
                boundarySupplementaryItems.append(pageFooter)
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

        section.visibleItemsInvalidationHandler = { [weak reactor] visibleItems, contentOffset, environment in
            guard let reactor = reactor else {
                return
            }
            let bannerIndex = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
            DispatchQueue.main.async {
                reactor.action.onNext(.bannerPageIsChanged(index: bannerIndex))
            }
        }

        return section
    }

    func getGridLayout() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        ))
        item.contentInsets = itemContentsInset
        let mainGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(6/10)
            ),
            subitems: [item, item, item]
        )
        let section: NSCollectionLayoutSection = .init(group: mainGroup)
        section.contentInsets = sectionContentsInset
        section.orthogonalScrollingBehavior = .none

        return section
    }

    func getScrollLayout() -> NSCollectionLayoutSection {
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1)
        ))
        item.contentInsets = itemContentsInset
        let mainGroup: NSCollectionLayoutGroup = .horizontal(
            layoutSize: .init(
                widthDimension: .estimated(UIScreen.main.bounds.width),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: mainGroup)
        section.contentInsets = sectionContentsInset
        section.orthogonalScrollingBehavior = .continuous

        return section
    }

    func getStyleLayout() -> NSCollectionLayoutSection {
        let itemA: NSCollectionLayoutItem = .init(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1/2)
        ))
        itemA.contentInsets = itemContentsInset
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
        itemB.contentInsets = itemContentsInset
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
        itemC.contentInsets = itemContentsInset
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
        section.contentInsets = sectionContentsInset
        return section
    }
}

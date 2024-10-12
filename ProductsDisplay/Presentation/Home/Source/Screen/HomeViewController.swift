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

    func bind(reactor: HomeReactor) {
        setupUI()
        bindAction(reactor)
        bindState(reactor)
    }

    func bindAction(_ reactor: HomeReactor) {
    }

    func bindState(_ reactor: HomeReactor) {
    }
}

extension HomeViewController {

    func setupUI() {
        view.backgroundColor = .yellow

        setupLayouts()
    }

    func setupLayouts() {
    }
}

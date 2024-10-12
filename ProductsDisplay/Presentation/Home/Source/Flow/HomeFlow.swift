//
//  HomeFlow.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import UIKit

import RxFlow
import RxSwift

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController = UINavigationController()

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeFlowSteps else { return .none }

        switch step {
        case .homeIsRequired:
            return navigateToHome()
        }
    }

    private func navigateToHome() -> FlowContributors {
        let homeReactor = HomeReactor()
        let homeViewController = HomeViewController()
        homeViewController.reactor = homeReactor

        rootViewController.setViewControllers(
            [homeViewController],
            animated: false
        )

        return .one(flowContributor: .contribute(
            withNextPresentable: homeViewController,
            withNextStepper: homeReactor
        ))
    }
}

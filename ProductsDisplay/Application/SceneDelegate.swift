//
//  SceneDelegate.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import UIKit

import RxFlow
import RxSwift
import Factory

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let coordinator = FlowCoordinator()
    let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        coordinator.rx.willNavigate.subscribe { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }
        .disposed(by: disposeBag)

        coordinator.rx.didNavigate.subscribe { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }
        .disposed(by: disposeBag)

        let home = Container.shared.home()
        let homeFlow = home.makeFlow()
        coordinator.coordinate(
            flow: homeFlow,
            with: OneStepper(withSingleStep: HomeFlowSteps.homeIsRequired)
        )

        Flows.use(
            homeFlow,
            when: .created
        ) { [weak self] flowRoot in
            self?.window?.rootViewController = flowRoot
            self?.window?.makeKeyAndVisible()
        }
    }
}

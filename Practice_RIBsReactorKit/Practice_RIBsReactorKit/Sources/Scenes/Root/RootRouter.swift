//
//  RootRouter.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

// MARK: - RootInteractable
protocol RootInteractable: Interactable, ListListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

// MARK: - RootViewControllable
protocol RootViewControllable: ViewControllable {
  func present(_ viewController: ViewControllable, animated: Bool)
  func dismiss(_ viewController: ViewControllable, animated: Bool)
}

// MARK: - RootRouter
final class RootRouter:
  LaunchRouter<RootInteractable, RootViewControllable>,
  RootRouting
{
 
  private let listBuilder: ListBuildable
  
  // MARK: - Con(De)structor
  
  init(
    listBuilder: ListBuildable,
    interactor: RootInteractable,
    viewController: RootViewControllable
  ) {
    self.listBuilder = listBuilder
    super.init(
      interactor: interactor,
      viewController: viewController
    )
    interactor.router = self
  }
}

// MARK: - RootRouting
extension RootRouter {
  func attachListRIB() {
    let router = listBuilder.build(withListener: interactor)
    attachChild(router)
    viewController.present(router.viewControllable, animated: true)
  }
}

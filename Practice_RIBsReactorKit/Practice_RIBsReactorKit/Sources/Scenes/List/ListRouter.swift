//
//  ListRouter.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

// MARK: - ListInteractable
protocol ListInteractable: Interactable, DetailListener {
  var router: ListRouting? { get set }
  var listener: ListListener? { get set }
}

// MARK: - ListViewControllable
protocol ListViewControllable: ViewControllable {
  func present(_ viewController: ViewControllable, animated: Bool)
}

// MARK: - ListRouter
final class ListRouter:
  ViewableRouter<ListInteractable, ListViewControllable>,
  ListRouting
{
  
  private let detailBuilder: DetailBuildable
  
  // MARK: - Con(De)structor
  
  init(
    detailBuilder: DetailBuildable,
    interactor: ListInteractable,
    viewController: ListViewControllable
  ) {
    self.detailBuilder = detailBuilder
    super.init(
      interactor: interactor,
      viewController: viewController
    )
    interactor.router = self
  }
}

// MARK: - ListRouting
extension ListRouter {
  func attachDetailRIB() {
    let router = detailBuilder.build(withListener: interactor)
    attachChild(router)
    viewController.present(router.viewControllable, animated: true)
  }
}

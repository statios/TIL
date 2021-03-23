//
//  RootBuilder.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

// MARK: - RootDependency
protocol RootDependency: Dependency {
}

// MARK: - RootComponent
final class RootComponent: Component<RootDependency> {
  fileprivate var initialState: RootPresentableState {
    RootPresentableState()
  }
}

// MARK: - RootBuildable
protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

// MARK: - RootBuilder
final class RootBuilder:
  Builder<RootDependency>,
  RootBuildable
{
  
  // MARK: - Con(De)structor
  
  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
 
  // MARK: - RootBuildable
  
  func build() -> LaunchRouting {
    
    // Create a own RIB
    let component = RootComponent(dependency: dependency)
    let viewController = RootViewController()
    let interactor = RootInteractor(
      initialState: component.initialState,
      presenter: viewController
    )
    
    // Create child RIB builders
    let listBuilder = ListBuilder(dependency: component)
    
    return RootRouter(
      listBuilder: listBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}

// MARK: - RootBuildable
extension RootBuilder {
  
}

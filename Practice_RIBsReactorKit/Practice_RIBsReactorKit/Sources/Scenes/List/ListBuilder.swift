//
//  ListBuilder.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

// MARK: - ListDependency
protocol ListDependency: Dependency {
  var texts: [String] { get }
}

// MARK: - ListComponent
final class ListComponent: Component<ListDependency> {
  fileprivate var initialState: ListPresentableState {
    ListPresentableState(
      texts: dependency.texts
    )
  }
}

// MARK: - ListBuildable
protocol ListBuildable: Buildable {
  func build(withListener listener: ListListener) -> ListRouting
}

// MARK: - ListBuilder
final class ListBuilder:
  Builder<ListDependency>,
  ListBuildable
{
  
  // MARK: - Con(De)structor
  
  override init(dependency: ListDependency) {
    super.init(dependency: dependency)
  }
 
  // MARK: - ListBuildable
  
  func build(withListener listener: ListListener) -> ListRouting {
    let component = ListComponent(dependency: dependency)
    let viewController = ListViewController()
    let interactor = ListInteractor(
      initialState: component.initialState,
      presenter: viewController
    )
    
    let detailBuilder = DetailBuilder(dependency: component)
    
    interactor.listener = listener
    
    return ListRouter(
      detailBuilder: detailBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}

// MARK: - ListBuildable
extension ListBuilder {
  
}

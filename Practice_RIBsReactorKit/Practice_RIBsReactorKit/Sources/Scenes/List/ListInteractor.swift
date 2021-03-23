//
//  ListInteractor.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import Foundation
import RIBs
import Moya
import ReactorKit

// MARK: - ListRouting
protocol ListRouting: ViewableRouting {
  func attachDetailRIB()
}

// MARK: - ListPresentable
protocol ListPresentable: Presentable {
  var listener: ListPresentableListener? { get set }
}

// MARK: - ListListener
protocol ListListener: class {
  func detachListRIB()
}

// MARK: - ListInteractor
final class ListInteractor:
  PresentableInteractor<ListPresentable>,
  ListInteractable,
  ListPresentableListener,
  Reactor
{
  
  // MARK: - Types
  
  typealias Action = ListPresentableAction
  
  typealias State = ListPresentableState
  
  enum Mutation {
    case detach
    case setDetail(String)
  }
  
  // MARK: - Properties
  
  weak var router: ListRouting?
  
  weak var listener: ListListener?
  
  let initialState: State
  
  // MARK: - Con(De)structor
  
  init(
    initialState: State,
    presenter: ListPresentable
  ) {
    self.initialState = initialState
    super.init(presenter: presenter)
    presenter.listener = self
  }
}

// MARK: Reactor
extension ListInteractor {
  
  // MARK: - mutate
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .detachAction:
      return .just(.detach)
    case .selectedText(let text):
      return .just(.setDetail(text))
    }
  }
  
  // MARK: - Transform mutation
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .flatMap { [weak self] mutation -> Observable<Mutation> in
        guard let this = self else { return .never() }
        switch mutation {
        case .detach:
          return this.detachListRIBTransform()
        case .setDetail(let text):
          return this.setDetailTransform()
        }
    }
  }
  
  private func detachListRIBTransform() -> Observable<Mutation> {
    listener?.detachListRIB()
    return .empty()
  }
  
  private func setDetailTransform() -> Observable<Mutation> {
    router?.attachDetailRIB()
    return .empty()
  }
  
  // MARK: - reduce
  
  func reduce(
    state: State,
    mutation: Mutation
  ) -> State {
    let newState = state
    switch mutation {
    case .detach:
      Log.debug("route logic: \(mutation)")
    case .setDetail:
      Log.debug("Do nothing when \(mutation)")
    }
    return newState
  }
}

// MARK: - ListInteractable
extension ListInteractor {
  func detachDetailRIB() {
    
  }
}

// MARK: - ListPresentableListener
extension ListInteractor {
}

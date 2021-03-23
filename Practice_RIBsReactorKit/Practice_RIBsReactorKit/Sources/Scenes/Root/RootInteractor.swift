//
//  RootInteractor.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import Foundation
import RIBs
import Moya
import ReactorKit

// MARK: - RootRouting
protocol RootRouting: ViewableRouting {
  func attachListRIB()
}

// MARK: - RootPresentable
protocol RootPresentable: Presentable {
  var listener: RootPresentableListener? { get set }
}

// MARK: - RootListener
protocol RootListener: class {
  func detachRootRIB()
}

// MARK: - RootInteractor
final class RootInteractor:
  PresentableInteractor<RootPresentable>,
  RootInteractable,
  RootPresentableListener,
  Reactor
{
  
  
  // MARK: - Types
  
  typealias Action = RootPresentableAction
  typealias State = RootPresentableState
  
  enum Mutation {
    case detach
  }
  
  // MARK: - Properties
  
  weak var router: RootRouting?
  
  weak var listener: RootListener?
  
  let initialState: State
  
  // MARK: - Con(De)structor
  
  init(
    initialState: State,
    presenter: RootPresentable
  ) {
    self.initialState = initialState
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    router?.attachListRIB()
  }
  
}

// MARK: Reactor
extension RootInteractor {
  
  // MARK: - mutate
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .detachAction:
      return .just(.detach)
    }
  }
  
  // MARK: - Transform mutation
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .flatMap { [weak self] mutation -> Observable<Mutation> in
        guard let this = self else { return .never() }
        switch mutation {
        case .detach:
          return this.detachRootRIBTransform()
        }
    }
  }
  
  private func detachRootRIBTransform() -> Observable<Mutation> {
    listener?.detachRootRIB()
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
    }
    return newState
  }
}

// MARK: - RootInteractable
extension RootInteractor {
  func detachListRIB() {
    
  }
}

// MARK: - RootPresentableListener
extension RootInteractor {
}

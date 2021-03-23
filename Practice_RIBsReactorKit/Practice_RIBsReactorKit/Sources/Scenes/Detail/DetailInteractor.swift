//
//  DetailInteractor.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import Foundation
import RIBs
import Moya
import ReactorKit

// MARK: - DetailRouting
protocol DetailRouting: ViewableRouting {
}

// MARK: - DetailPresentable
protocol DetailPresentable: Presentable {
  var listener: DetailPresentableListener? { get set }
}

// MARK: - DetailListener
protocol DetailListener: class {
  func detachDetailRIB()
}

// MARK: - DetailInteractor
final class DetailInteractor:
  PresentableInteractor<DetailPresentable>,
  DetailInteractable,
  DetailPresentableListener,
  Reactor
{
  
  // MARK: - Types
  
  typealias Action = DetailPresentableAction
  
  typealias State = DetailPresentableState
  
  enum Mutation {
    case detach
  }
  
  // MARK: - Properties
  
  weak var router: DetailRouting?
  
  weak var listener: DetailListener?
  
  let initialState: State
  
  // MARK: - Con(De)structor
  
  init(
    initialState: State,
    presenter: DetailPresentable
  ) {
    self.initialState = initialState
    super.init(presenter: presenter)
    presenter.listener = self
  }
}

// MARK: Reactor
extension DetailInteractor {
  
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
          return this.detachDetailRIBTransform()
        }
    }
  }
  
  private func detachDetailRIBTransform() -> Observable<Mutation> {
    listener?.detachDetailRIB()
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

// MARK: - DetailInteractable
extension DetailInteractor {
}

// MARK: - DetailPresentableListener
extension DetailInteractor {
}

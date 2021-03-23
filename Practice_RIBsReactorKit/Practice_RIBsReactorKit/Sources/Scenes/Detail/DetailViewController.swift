//
//  DetailViewController.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

// MARK: - DetailPresentableAction
enum DetailPresentableAction {
  case detachAction
}

// MARK: - DetailPresentableListener
protocol DetailPresentableListener: class {
  typealias Action = DetailPresentableAction
  typealias State = DetailPresentableState
  
  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - DetailViewController
final class DetailViewController:
  UIViewController,
  DetailPresentable,
  DetailViewControllable
{
  // MARK: - Constants
  
  // MARK: - Properties
  
  weak var listener: DetailPresentableListener?
  
  private let detachActionRelay = PublishRelay<Void>()
  
  // MARK: - UI Components
  
  // MARK: - Con(De)structor
  
  deinit { Log.info("deinit: \(self)") }
  
  // MARK: - Overridden: UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind(to: listener)
    setupUI()
  }
  
  // MARK: - Internal methods
  
  // MARK: - Private methods
  
  // MARK: - Selectors
}

// MARK: - Binding
private extension DetailViewController {
  func bind(to listener: DetailPresentableListener?) {
    guard let listener = listener else { return }
    bindDetachAction(to: listener)
  }
  
  func bindDetachAction(to listener: DetailPresentableListener) {
    detachActionRelay
      .map { .detachAction }
      .bind(to: listener.action)
      .disposed(by: rx.disposeBag)
  }
}

// MARK: - SetupUI
private extension DetailViewController {
  func setupUI() {
    layout()
    setupProperties()
  }
  
  func layout() {
    
  }
  
  func setupProperties() {
    view.backgroundColor = .white
  }
}

// MARK: - DetailPresentable
extension DetailViewController {
  
}

// MARK: - DetailViewControllable
extension DetailViewController {
}

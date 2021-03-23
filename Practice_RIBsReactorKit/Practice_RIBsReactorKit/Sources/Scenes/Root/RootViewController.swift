//
//  RootViewController.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import UIKit

import RIBs
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit

// MARK: - RootPresentableAction
enum RootPresentableAction {
  case detachAction
}

// MARK: - RootPresentableListener
protocol RootPresentableListener: class {
  typealias Action = RootPresentableAction
  typealias State = RootPresentableState
  
  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - RootViewController
final class RootViewController:
  UIViewController,
  RootPresentable,
  RootViewControllable
{
  
  // MARK: - Constants
  
  // MARK: - Properties
  
  weak var listener: RootPresentableListener?
  
  private let detachActionRelay = PublishRelay<Void>()
  
  // MARK: - UI Components
  
  let titleLabel = UILabel().then {
    $0.text = "RIBsReactorKit"
    $0.textColor = .black
  }
  
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
private extension RootViewController {
  func bind(to listener: RootPresentableListener?) {
    guard let listener = listener else { return }
    bindDetachAction(to: listener)
  }
  
  func bindDetachAction(to listener: RootPresentableListener) {
    detachActionRelay
      .map { .detachAction }
      .bind(to: listener.action)
      .disposed(by: rx.disposeBag)
  }
}

// MARK: - SetupUI
private extension RootViewController {
  func setupUI() {
    
    view.addSubview(titleLabel)
    
    layout()
    setupProperties()
  }
  
  func layout() {
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  func setupProperties() {
    view.backgroundColor = .white
  }
}

// MARK: - RootPresentable
extension RootViewController {
  
}

// MARK: - RootViewControllable
extension RootViewController {
  func present(_ viewController: ViewControllable, animated: Bool) {
    present(viewController.uiviewController, animated: animated)
  }
  func dismiss(_ viewController: ViewControllable, animated: Bool) {
    viewController.uiviewController.dismiss(animated: animated)
  }
}

//
//  ListViewController.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import UIKit

import RIBs
import RxSwift
import RxCocoa
import ReactorKit

// MARK: - ListPresentableAction
enum ListPresentableAction {
  case detachAction
  case selectedText(String)
}

// MARK: - ListPresentableListener
protocol ListPresentableListener: class {
  typealias Action = ListPresentableAction
  typealias State = ListPresentableState
  
  var action: ActionSubject<Action> { get }
  var state: Observable<State> { get }
  var currentState: State { get }
}

// MARK: - ListViewController
final class ListViewController:
  UIViewController,
  ListPresentable,
  ListViewControllable
{
  
  // MARK: - Constants
  
  // MARK: - Properties
  
  weak var listener: ListPresentableListener?
  
  private let detachActionRelay = PublishRelay<Void>()
  
  // MARK: - UI Components
  
  let tableView = UITableView().then {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "ListTableView")
  }
  
  // MARK: - Con(De)structor
  
  init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .fullScreen
    modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
private extension ListViewController {
  func bind(to listener: ListPresentableListener?) {
    guard let listener = listener else { return }
    //Action
    bindDetachAction(to: listener)
    bindSelectedText(to: listener)
    
    //State
    bindTextsState(from: listener)
  }
  
  func bindDetachAction(to listener: ListPresentableListener) {
    detachActionRelay
      .map { .detachAction }
      .bind(to: listener.action)
      .disposed(by: rx.disposeBag)
  }
  
  func bindSelectedText(to listener: ListPresentableListener) {
    tableView.rx.modelSelected(String.self)
      .map { .selectedText($0) }
      .bind(to: listener.action)
      .disposed(by: rx.disposeBag)
  }
  
  func bindTextsState(from listener: ListPresentableListener) {
    listener.state.map { $0.texts }
      .bind(
        to: tableView.rx.items(cellIdentifier: "ListTableView")
      ) { (index, item, cell) in
        cell.textLabel?.text = item
      }.disposed(by: rx.disposeBag)
  }
}

// MARK: - SetupUI
private extension ListViewController {
  func setupUI() {
    view.addSubview(tableView)
    
    layout()
    setupProperties()
  }
  
  func layout() {
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func setupProperties() {
    view.backgroundColor = .white
  }
}

// MARK: - ListPresentable
extension ListViewController {
  func present(_ viewController: ViewControllable, animated: Bool) {
    present(viewController.uiviewController, animated: animated)
  }
}

// MARK: - ListViewControllable
extension ListViewController {
}

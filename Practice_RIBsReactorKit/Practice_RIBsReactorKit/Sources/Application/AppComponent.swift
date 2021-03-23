//
//  AppComponent.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

final class AppComponent:
  Component<EmptyDependency>,
  RootDependency
{ 
  init() {
    super.init(dependency: EmptyComponent())
  }
}

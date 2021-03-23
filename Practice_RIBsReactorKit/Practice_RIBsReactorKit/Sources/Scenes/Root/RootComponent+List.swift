//
//  RootComponent+List.swift
//  Practice_RIBsReactorKit
//
//  Created by Stat on 2021/03/23.
//

import RIBs

protocol RootDependencyList: Dependency { }

extension RootComponent: ListDependency {
  var texts: [String] {
    return [
      "동해물과",
      "백두산이",
      "마르고닳도록",
      "하느님이",
      "보우하사",
      "우리나라만세"
    ]
  }
}

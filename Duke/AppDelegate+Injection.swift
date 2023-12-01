//
//  AppDelegate+Injection.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/25/23.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
      register { AuthenticationService() }.scope(ResolverScope.application)
      ///This code essentially says "create an instance of FirestoreTaskRepositoryand inject it whereever a Taskrepository instance is required".
      register { FirestoreRestaurantRepository() as RestaurantRepository }.scope(.application)
  }
}

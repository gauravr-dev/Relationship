//
//  ListCustomersRouter.swift
//  Relationship
//
//  Created by Raymond Law on 9/16/17.
//  Copyright (c) 2017 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ListCustomersRoutingLogic
{
  func routeToListLicenses(segue: UIStoryboardSegue?)
}

protocol ListCustomersDataPassing
{
  var dataStore: ListCustomersDataStore? { get }
}

class ListCustomersRouter: NSObject, ListCustomersRoutingLogic, ListCustomersDataPassing
{
  weak var viewController: ListCustomersViewController?
  var dataStore: ListCustomersDataStore?
  
  // MARK: Routing
  
  func routeToListLicenses(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let navigationController = segue.destination as! UINavigationController
      let destinationVC = navigationController.topViewController as! ListLicensesViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToListLicenses(source: dataStore!, destination: &destinationDS)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let navigationController = storyboard.instantiateViewController(withIdentifier: "ListLicensesNavigationController") as! UINavigationController
      let destinationVC = navigationController.topViewController as! ListLicensesViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToListLicenses(source: dataStore!, destination: &destinationDS)
      navigateToListLicenses(source: viewController!, destination: navigationController)
    }
  }

  // MARK: Navigation
  
  func navigateToListLicenses(source: ListCustomersViewController, destination: UINavigationController)
  {
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToListLicenses(source: ListCustomersDataStore, destination: inout ListLicensesDataStore)
  {
    if let indexPath = viewController?.tableView.indexPathForSelectedRow {
      let customer = viewController?.interactor?.customers[indexPath.row]
      destination.customer = customer
    }
  }
}
//
//  ListCustomersViewController.swift
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
import CoreData

protocol ListCustomersDisplayLogic: class
{
  func displayFetchedCustomers(viewModel: ListCustomers.FetchCustomers.ViewModel)
  func displayCreatedCustomer(viewModel: ListCustomers.CreateCustomer.ViewModel)
  func displayDeletedCustomer(viewModel: ListCustomers.DeleteCustomer.ViewModel)
}

class ListCustomersViewController: UITableViewController, ListCustomersDisplayLogic
{
  var interactor: ListCustomersBusinessLogic?
  var router: (NSObjectProtocol & ListCustomersRoutingLogic & ListCustomersDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ListCustomersInteractor()
    let presenter = ListCustomersPresenter()
    let router = ListCustomersRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    configureNavigationBarButtons()
    fetchCustomers()
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
  }
  
  // MARK: - Configure navigation bar buttons
  
  func configureNavigationBarButtons()
  {
    navigationItem.leftBarButtonItem = editButtonItem
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
    navigationItem.rightBarButtonItem = addButton
  }
  
  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return displayedCustomers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath)
    let displayedCustomer = displayedCustomers[indexPath.row]
    configureCell(cell, withDisplayedCustomer: displayedCustomer)
    return cell
  }
  
  func configureCell(_ cell: UITableViewCell, withDisplayedCustomer displayedCustomer: ListCustomers.DisplayedCustomer)
  {
    cell.textLabel!.text = displayedCustomer.name
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
  {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
  {
    if editingStyle == .delete {
      deleteCustomer(at: indexPath)
    }
  }
  
  // MARK: Fetch customers
  
  var displayedCustomers: [ListCustomers.DisplayedCustomer] = []
  
  func fetchCustomers()
  {
    let request = ListCustomers.FetchCustomers.Request()
    interactor?.fetchCustomers(request: request)
  }
  
  func displayFetchedCustomers(viewModel: ListCustomers.FetchCustomers.ViewModel)
  {
    displayedCustomers = viewModel.displayedCustomers
    tableView.reloadData()
  }
  
  // MARK: Create customer
  
  func addButtonTapped(_ sender: Any)
  {
    showCreateCustomerAlert()
  }
  
  private func showCreateCustomerAlert()
  {
    let alertController = UIAlertController(title: "title", message: "message", preferredStyle: .alert)
    
    let createAlertAction = UIAlertAction(title: "Create", style: .default) { (alertAction) in
      let id = alertController.textFields?[0].text
      let name = alertController.textFields?[1].text
      if let id = id, let name = name {
        self.createCustomer(id: id, name: name)
      }
    }
    createAlertAction.isEnabled = false
    alertController.addAction(createAlertAction)
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Enter the customer ID"
      NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) in
        createAlertAction.isEnabled = (alertController.textFields?[0].text != "" && alertController.textFields?[1].text != "")
      })
    }
    
    alertController.addTextField { (textField) in
      textField.placeholder = "Enter the customer name"
      NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using: { (notification) in
        createAlertAction.isEnabled = (alertController.textFields?[0].text != "" && alertController.textFields?[1].text != "")
      })
    }
    
    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAlertAction)
    
    present(alertController, animated: true)
  }
  
  private func createCustomer(id: String, name: String)
  {
    let request = ListCustomers.CreateCustomer.Request(id: id, name: name)
    interactor?.createCustomer(request: request)
  }
  
  func displayCreatedCustomer(viewModel: ListCustomers.CreateCustomer.ViewModel)
  {
    displayedCustomers = viewModel.displayedCustomers
    tableView.reloadData()
  }
  
  // MARK: Delete customer
  
  func deleteCustomer(at indexPath: IndexPath)
  {
    let request = ListCustomers.DeleteCustomer.Request(indexPath: indexPath)
    interactor?.deleteCustomer(request: request)
  }
  
  func displayDeletedCustomer(viewModel: ListCustomers.DeleteCustomer.ViewModel)
  {
    displayedCustomers = viewModel.displayedCustomers
    tableView.reloadData()
  }
}

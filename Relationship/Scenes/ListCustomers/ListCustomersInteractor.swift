//
//  ListCustomersInteractor.swift
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

protocol ListCustomersBusinessLogic
{
  var customers: [Customer] { get set }
  func fetchCustomers(request: ListCustomers.FetchCustomers.Request)
  func createCustomer(request: ListCustomers.CreateCustomer.Request)
  func deleteCustomer(request: ListCustomers.DeleteCustomer.Request)
}

protocol ListCustomersDataStore
{
  var selectedCustomer: Customer! { get set }
}

class ListCustomersInteractor: ListCustomersBusinessLogic, ListCustomersDataStore
{
  var presenter: ListCustomersPresentationLogic?
  var listCustomersWorker = ListCustomersWorker()
  var customers: [Customer] = []
  var selectedCustomer: Customer!
  
  // MARK: Fetch customers
  
  func fetchCustomers(request: ListCustomers.FetchCustomers.Request)
  {
    listCustomersWorker.fetchCustomers { (customers: () throws -> [Customer]) in
      do {
        self.customers = try customers()
        let response = ListCustomers.FetchCustomers.Response(customers: self.customers)
        self.presenter?.presentFetchedCustomers(response: response)
      } catch {}
    }
  }
  
  // MARK: Create customer
  
  func createCustomer(request: ListCustomers.CreateCustomer.Request)
  {
    let customer = Customer(id: request.id, name: request.name, licenses: [])
    listCustomersWorker.createCustomer(customerToCreate: customer) { (customer: () throws -> Customer?) in
      let customer = try! customer()!
      self.customers.append(customer)
      let response = ListCustomers.CreateCustomer.Response(customers: self.customers)
      self.presenter?.presentCreatedCustomer(response: response)
    }
  }
  
  // MARK: Delete customer
  
  func deleteCustomer(request: ListCustomers.DeleteCustomer.Request)
  {
    let index = request.indexPath.row
    let customer = customers[index]
    listCustomersWorker.deleteCustomer(id: customer.id) { (_: () throws -> Void) in
      self.customers.remove(at: index)
      let response = ListCustomers.DeleteCustomer.Response(customers: self.customers)
      self.presenter?.presentDeletedCustomer(response: response)
    }
  }
}

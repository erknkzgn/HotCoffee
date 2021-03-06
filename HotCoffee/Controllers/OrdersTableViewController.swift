//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by Erkan Kızgın on 2.03.2022.
//

import Foundation
import UIKit


class OrdersTableViewController : UITableViewController,AddCoffeeOrderDelegate {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    //delegate functions of  AddCoffeeOrderDelegate
    
    func addCoffeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addCoffeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        //self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count-1, section: 0)], with: .automatic)
        self.tableView.reloadData()
        
    }
    
    private func populateOrders(){
        
        Websevice().load(resource: Order.all){[weak self] result in
            
            switch result{
            case .success(let orders):
                print(orders)
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension OrdersTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let addCoffeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
                  fatalError("Error performing segue!")
              }
        
        addCoffeOrderVC.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let order = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = order.type
        cell.detailTextLabel?.text = order.size
        
        return cell
    }
}



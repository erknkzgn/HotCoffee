//
//  Order.swift
//  HotCoffee
//
//  Created by Erkan Kızgın on 5.03.2022.
//

import Foundation


enum CoffeeType: String,Codable,CaseIterable {
    case cappucino
    case lattee
    case espressino
    case cortado
}

enum CoffeSize: String,Codable,CaseIterable {
    case small
    case medium
    case large
}

struct Order: Codable {
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeSize
}

extension Order {
    
    static var all: Resource<[Order]> = {
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(vm: AddCoffeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(vm)
        
        
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("URL is incorrect")
        }
        
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Encoding error..")
        }
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = HttpMethod.post
        resource.body = data
        
        print(String(data: resource.body!, encoding: .utf8)!)
        print("1")
        return resource
        
    }
}


extension Order {
    
    init?(_ vm : AddCoffeOrderViewModel){
        
        guard let name = vm.name,
              let email = vm.email,
              let selectedSize = CoffeSize(rawValue: vm.selectedSize!.lowercased()),
              let selectedType = CoffeeType(rawValue: vm.selectedType!.lowercased()) else {
                  return nil
              }
    
    self.name = name
    self.email = email
    self.size = selectedSize
    self.type = selectedType
        print(name + "-" + email + "-" + selectedType.rawValue + "-" + selectedSize.rawValue)
    
    }
}

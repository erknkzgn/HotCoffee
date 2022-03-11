//
//  AddCoffeeOrderViewModel.swift
//  HotCoffee
//
//  Created by Erkan Kızgın on 6.03.2022.
//

import Foundation


struct AddCoffeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType : String?
    var selectedSize : String?
    
    var types: [String]{
        return CoffeeType.allCases.map {$0.rawValue.capitalized}
    }
    
    var sizes: [String]{
        return CoffeSize.allCases.map {$0.rawValue.capitalized}
    }
}

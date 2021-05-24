//
//  Restaurant.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import Foundation

struct Restraurant: Decodable {
    let restaurant_name: String
    let restaurant_phone: String
    let cuisines: Array<String>
    let menus: Array<Menu>
    
    static let example = Restraurant(restaurant_name: "Cipriani's Italian Restaurant",restaurant_phone: "(845) 353-5353", cuisines: ["Italian"], menus: [Menu(menu_name: "a", menu_sections: [MenuSection(section_name: "a", menu_items: [MenuItem(name: "a", description: "a", pricing: [Price(price: 1.1)])])])])

}

struct RestraurantID: Identifiable {
    var id = UUID()
    let restaurant_name: String
    let restaurant_phone: String
    let cuisines: Array<String>
    let menus: Array<MenuID>
    
    static let example = RestraurantID(restaurant_name: "Cipriani's Italian Restaurant",restaurant_phone: "(845) 353-5353", cuisines: ["Italian"], menus: [MenuID(menu_name: "a", menu_sections: [MenuSectionID(section_name: "a", menu_items: [MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)]),MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)]),MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)]),MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)])])])])
}

struct Menu: Decodable{
    let menu_name: String
    let menu_sections: Array<MenuSection>
}

struct MenuSection: Decodable{
    let section_name: String
    let menu_items: Array<MenuItem>
}

struct MenuItem: Decodable{
    let name: String
    let description: String
    let pricing: Array<Price>
}

struct Price: Decodable{
    let price: Float
}

struct MenuID{
    let menu_name: String
    let menu_sections: Array<MenuSectionID>
}

struct MenuSectionID{
    let section_name: String
    let menu_items: Array<MenuItemID>
}

struct MenuItemID: Identifiable{
    var id = UUID()
    let name: String
    let description: String
    let pricing: Array<Price>
}


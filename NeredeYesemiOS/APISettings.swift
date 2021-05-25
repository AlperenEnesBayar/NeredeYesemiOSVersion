//
//  APISettings.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 25.05.2021.
//

import Foundation
import Combine

struct ServerMessage: Decodable{
    let data: Array<Restraurant>
}

class HttpAuth: ObservableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    var rl: [RestraurantID] = []
    var authenticated = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func getValues(cuisine: String, state_code: String){
        let page = "1"
        
        guard let url = URL(string: "https://weather.iamboredandgeek.com/php_rest/api/get_rest.php") else {return}
        
        let body: [String: String] = ["state_code": state_code, "cuisine": cuisine, "page": page]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request){(data, response, error) in
            guard let data = data else {return}
            
            let finalData = try! JSONDecoder().decode(ServerMessage.self, from: data)
            
            var tempRestArr: [RestraurantID] = []
            
            
            for i in finalData.data{
                var tempMenuIDArr: [MenuID] = []
                for j in i.menus{
                    var tempMenuSectionArray: [MenuSectionID] = []
                    for l in j.menu_sections{
                        var tempMenuItemsArray: [MenuItemID] = []
                        for k in l.menu_items {
                            var item = MenuItemID(name: k.name, description: k.description, pricing: k.pricing)
                            tempMenuItemsArray.append(item)
                        }
                        tempMenuSectionArray.append(MenuSectionID(section_name: l.section_name, menu_items: tempMenuItemsArray))
                    }
                    tempMenuIDArr.append(MenuID(menu_name: j.menu_name, menu_sections: tempMenuSectionArray))
                }
                
                tempRestArr.append(RestraurantID(restaurant_name: i.restaurant_name, restaurant_phone: i.restaurant_phone, cuisines: i.cuisines, menus: tempMenuIDArr))
                //print(i.restaurant_name)
            }
            
            
            DispatchQueue.main.async{
                print("Dispatched")
                self.authenticated = true
                self.rl = tempRestArr
            }
            
        }.resume()

    }
}

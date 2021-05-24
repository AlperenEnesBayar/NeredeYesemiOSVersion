//
//  Data.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI

struct Post: Codable, Identifiable{
    var id = UUID()
    var restaurant_name: String
    var restaurant_phone: String
}

class Api {
    func getPosts(){
        let url = URL(string: "https://weather.iamboredandgeek.com/php_rest/api/get_rest.php")
        URLSession.shared.dataTask(with: url!) { (data, _, _) in
            let posts = try! JSONDecoder().decode([Post].self, from: data!)
            print(posts)
        }
        .resume()
    }
}

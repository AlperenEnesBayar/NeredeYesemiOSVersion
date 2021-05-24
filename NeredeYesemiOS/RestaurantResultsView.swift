//
//  RestaurantResultsView.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 23.05.2021.
//

import SwiftUI

struct RestaurantResultsView: View {
    var title: String = ""
    var restToAll: [RestraurantID]
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(
                    destination: SearchRestaurantView()
                        .navigationTitle("")
                        .navigationBarHidden(true),
                    label: {
                        Text("Go Back")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            
                    })
                    .padding()
                List(restToAll){
                    rest in NavigationLink(destination: RestaurantView(temp: rest)){
                        ListRow(each: rest)
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarHidden(true)
       
            
        }
        .navigationBarTitle(title)
        .navigationBarHidden(true)
      

    }
}

struct ListRow: View{
    var each: RestraurantID
    var body: some View{
        VStack{
            HStack{
                Text(each.restaurant_name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 5)
                Spacer()
            }
            HStack{
                Text(each.restaurant_phone)
                    .foregroundColor(.gray)
                Spacer()
                Text(each.cuisines[0])
                    .font(.title2)
                    .bold()
            }
        }.frame(alignment: .leading)
    }
}

var myRests = [
    RestraurantID(restaurant_name: "Cipriani's Italian Restaurant",restaurant_phone: "(845) 353-5353", cuisines: ["Italian"], menus: [MenuID(menu_name: "a", menu_sections: [MenuSectionID(section_name: "a", menu_items: [MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)])])])]),
    RestraurantID(restaurant_name: "Cipriani's Italian Restaurant",restaurant_phone: "(845) 353-5353", cuisines: ["Italian"], menus: [MenuID(menu_name: "a", menu_sections: [MenuSectionID(section_name: "a", menu_items: [MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)])])])]),
    RestraurantID(restaurant_name: "Cipriani's Italian Restaurant",restaurant_phone: "(845) 353-5353", cuisines: ["Italian"], menus: [MenuID(menu_name: "a", menu_sections: [MenuSectionID(section_name: "a", menu_items: [MenuItemID(name: "a", description: "a", pricing: [Price(price: 1.1)])])])])
]

struct RestaurantResultsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantResultsView(restToAll: myRests)
    }
}

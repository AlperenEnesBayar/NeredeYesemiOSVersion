//
//  ContentView.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI

struct RestaurantView: View {
    var temp: RestraurantID
    var menu_items: Array<MenuItemID> = []
    let db = DBHelper()
    @State var isLiked = false
    
    init(temp: RestraurantID) {
        for k in temp.menus
        {
            for l in k.menu_sections
            {
                for m in l.menu_items
                {
                    menu_items.append(MenuItemID(name: m.name, description: m.description, pricing: m.pricing))
                }
            }
        }
        self.temp = temp
    }
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(temp.restaurant_name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
                if isLiked{
                    Button(action: {
                        isLiked = false
                    }){
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.red)
                    }
                }
                else{
                    Button(action: {
                        isLiked = true
                        db.insert(rest: temp)
                    }){
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.black)
                    }
                }
               
                Spacer()
            }
          
            HStack{
                Spacer()
                Text(temp.restaurant_phone)
                Spacer()
                Text(temp.cuisines[0])
                Spacer()
            }.frame(width: 400, alignment: .leading)

            List(menu_items){
                item in MenuRow(current: item)
            }
        }
        .navigationTitle(temp.restaurant_name)
        .frame(alignment: .top)
        
    }
}

struct MenuRow: View{
    var current: MenuItemID
    var body: some View{
        VStack{
            HStack{
                Text(current.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 5)
                Spacer()
            }
            HStack{
                Text(current.description)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(current.pricing[0].price, specifier: "%.2f")$")
                    .foregroundColor(.green)
                    .bold()
                    .font(.title3)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(temp: RestraurantID.example)
    }
}

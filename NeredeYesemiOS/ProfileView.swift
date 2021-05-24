//
//  ProfileView.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 23.05.2021.
//

import SwiftUI

struct ProfileView: View {
    @State var restToAll: [RestraurantID] = []
    
    
    let db = DBHelper()
    init(){
       // db.insert(rest: RestraurantID.example)
        restToAll = db.readRests()
        print("Readed Rows: \(restToAll.count)")
    }
    
    
    var body: some View {
            VStack{
                Text("Your Favorite Restautants")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Button("Refresh"){
                    restToAll = db.readRests()
                    print("Readed Rows: \(restToAll.count)")
                }
                List(restToAll){
                    rest in NavigationLink(destination: RestaurantView(temp: rest)){
                        ListRow(each: rest)
                    }
                }
            }
    }
}
struct ListRowProfile: View{
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


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

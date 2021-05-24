//
//  SearchRestaurantView.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI
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


struct SearchRestaurantView: View {
    var body: some View {
        VStack{
            SearchView()
        }
    }
}

struct SearchView: View{
    @State var selectedState = "NY"
    @State var cusine = ""
    @State var allRests: [RestraurantID] = []
    @State var isGo: Int? = 0
    @State var isLoading = false
    @State var manager = HttpAuth()
  
    
    let states = [ "AK",
                   "AL",
                   "AR",
                   "AS",
                   "AZ",
                   "CA",
                   "CO",
                   "CT",
                   "DC",
                   "DE",
                   "FL",
                   "GA",
                   "GU",
                   "HI",
                   "IA",
                   "ID",
                   "IL",
                   "IN",
                   "KS",
                   "KY",
                   "LA",
                   "MA",
                   "MD",
                   "ME",
                   "MI",
                   "MN",
                   "MO",
                   "MS",
                   "MT",
                   "NC",
                   "ND",
                   "NE",
                   "NH",
                   "NJ",
                   "NM",
                   "NV",
                   "NY",
                   "OH",
                   "OK",
                   "OR",
                   "PA",
                   "PR",
                   "RI",
                   "SC",
                   "SD",
                   "TN",
                   "TX",
                   "UT",
                   "VA",
                   "VI",
                   "VT",
                   "WA",
                   "WI",
                   "WV",
                   "WY"]
    var body: some View{
        ZStack{
            VStack{
                Text("Please choose a state:")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Picker("Please choose a state", selection: $selectedState)
                {
                    ForEach(states, id: \.self)
                    {
                        Text($0)
                            .font(.title2)
                    }
                }
                Text("Please choose a cuisine:")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                TextField("Cuisine (Turkish, Mexican, Indian...)", text: $cusine)
                    .padding(.horizontal, 64.0)
                    .padding(.vertical)
                    .font(.title2)
                    .frame(alignment: .center)
                NavigationLink(
                    destination: RestaurantResultsView(title: "\(cusine) restaurants\nat \(selectedState)", restToAll: allRests),
                    tag: 1, selection: $isGo){
                    Text("")
                }
                Button("Search") {
                    print("Button Pressed-1")
                    isLoading = true
                    manager.getValues(cuisine: cusine, state_code: selectedState)
                    print("Button Pressed-2")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if manager.authenticated{
                            print("Entered if Statetment")
                            allRests = manager.rl
                            isGo = 1
                            isLoading = false
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.accentColor)
                .cornerRadius(5)
            }
            
            if isLoading{
                ZStack{
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    VStack{
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(3)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SearchRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRestaurantView()
    }
}

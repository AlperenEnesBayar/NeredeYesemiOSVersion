//
//  SearchRestaurantView.swift
//  NeredeYesemiOS
//
//  Created by Alperen Enes Bayar on 22.05.2021.
//

import SwiftUI



struct SearchRestaurantView: View {
    
    var body: some View {
        VStack{
            SearchView()
        }
    }
}

struct SearchView: View{
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
    
    @State var selectedState = "NY"
    @State var cusine = ""
    @State var allRests: [RestraurantID] = []
    @State var isGo: Int? = 0
    @State var isLoading = false
    @State var manager = HttpAuth()
  
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

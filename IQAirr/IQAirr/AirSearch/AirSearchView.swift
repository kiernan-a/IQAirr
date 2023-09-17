//
//  AirSearchView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.

import SwiftUI
import Firebase

struct AirSearchView: View {
    @StateObject private var vm: AirSearchViewModel = AirSearchViewModel()
    @StateObject private var locationManager: LocationManager = LocationManager()
    @StateObject var favoritesvm: FavoritesViewModel = FavoritesViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack(alignment: .top){
                switch vm.state{
                case .success(let search):
                    Text("Successfully loaded data for nearest station: \(search.data.city)")
                case .loading:
                    Text("Loading data...")
                case .error(let error):
                    Text("Encountered an error!")
                    Text(error.localizedDescription)
                case .idle:
                    Text("Search for air quality data")
                }
                    
                
                Button{
                    Task{
                        await vm.searchAir()
                    }
                } label: {
                    Text("Search")
                }
            }
            .font(.headline)
        }
        .onAppear{
            locationManager.locationManager.requestWhenInUseAuthorization()
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            NavigationLink(destination: FavoritesView()) {
                Image(systemName: "heart.fill")
            }

        }
        
    }
    
}

struct AirSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AirSearchView()
    }
}

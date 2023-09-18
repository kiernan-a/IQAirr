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
    @State var showingCityView = false
    
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
                var favorited = favoritesvm.isFavorited(city: vm.search.data.city)//isFavorited(city: vm.search.data.city)
                Button("Search") {
                    Task{
                        await vm.searchAir()
                    }
                    showingCityView.toggle()
                }
                       .sheet(isPresented: $showingCityView) {
                           CityView(city: vm.search.data.city,
                                    aqius: vm.search.data.current.pollution.aqius,
                                    latitude: vm.search.data.location.coordinates[1],
                                    longitude: vm.search.data.location.coordinates[0],
                                    favoritesvm: favoritesvm,
                                    favorited: favorited)
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
    
    func isFavorited(city: String) -> Bool {
        favoritesvm.getData()
        print("Is \(city) favorited?")
        for favorite in favoritesvm.favorites {
            print("Is \(city) the same as \(favorite.city)")
            if(favorite.city == city){
                print("returned")
                return true
            }
        }
        return false
    }
    
}

struct AirSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AirSearchView()
    }
}

//
//  AirSearchView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.

import SwiftUI

struct AirSearchView: View {
    @StateObject private var vm: AirSearchViewModel = AirSearchViewModel()
    @StateObject private var locationManager: LocationManager = LocationManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack{
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
                    Text("Push")
                }
            }
            .font(.headline)
            
            Text(vm.search.data.city)
                .font(.largeTitle)
                .bold()
            
            switch vm.search.data.current.pollution.aqius {
            case 0...50:
                Text("Good")
            case 51...100:
                Text("Moderate")
            case 101...150:
                Text("Unhealthy for Sensitive Groups")
            case 151...200:
                Text("Unhealthy")
            case 201...300:
                Text("Very Unhealthy")
            default:
                Text("No data for air quality")
            }
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

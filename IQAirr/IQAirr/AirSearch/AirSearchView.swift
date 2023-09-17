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
        VStack {
            Text(vm.stateString)
            Button{
                Task{
                    await vm.searchAir()
                }
            } label: {
                Text("Push")
            }
            Text(vm.search.data.city)
                .font(.largeTitle)
                .bold()
        }
        .onAppear{
            locationManager.locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct AirSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AirSearchView()
    }
}

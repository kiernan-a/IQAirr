//
//  AirSearchView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.

import SwiftUI

struct AirSearchView: View {
    @StateObject private var vm: AirSearchViewModel = AirSearchViewModel()
    
    var body: some View {
        VStack {
            Text(vm.stateString)
            Button{
                print("pushed")
                Task{
                    print("task")
                    await vm.searchAir()
                }
            } label: {
                Text("Push")
            }
            Text(vm.search.data.city)
        }
    }
}

struct AirSearchView_Previews: PreviewProvider {
    static var previews: some View {
        AirSearchView()
    }
}

//
//  FavoritesView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/17/23.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var vm = FavoritesViewModel()
    
    var body: some View {
        VStack{
            List(vm.favorites){ location in
//                if location.favorited == true {
                    HStack{
                        Text(location.city)
                        Spacer()
                        Button {
                            if(location.favorited){
                                vm.unfavorite(city: location.city)
                            }else{
                                vm.favorite(city: location.city)
                            }
                        } label: {
                            if location.favorited {
                                Image(systemName: "heart.fill")
                            } else {
                                Image(systemName: "heart")
                            }
                        }

                    }
//                } else {
//                    Text("meow")
//                }
            }
        }
        .onAppear(perform: vm.getData)
    }
}


struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}

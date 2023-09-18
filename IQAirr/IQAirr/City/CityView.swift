//
//  CityView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/17/23.
//

import SwiftUI
import Firebase

struct CityView: View {
    @Environment(\.dismiss) var dismiss
    var city: String
    var aqius: Int
    var latitude: Double
    var longitude: Double
    var favoritesvm: FavoritesViewModel
    @State var favorited: Bool
    @State var color = Color.gray
    
    var body: some View {
        ZStack{
            switch aqius {
            case 0...50:
                Color.green.edgesIgnoringSafeArea(.all)
            case 51...100:
                Color.yellow.edgesIgnoringSafeArea(.all)
            case 101...150:
                Color.orange.edgesIgnoringSafeArea(.all)
            case 151...200:
                Color.red.edgesIgnoringSafeArea(.all)
            case 201...300:
                Color.purple.edgesIgnoringSafeArea(.all)
            default:
                Color.gray.edgesIgnoringSafeArea(.all)
            }
            VStack(spacing: 20.0){
                HStack(alignment: .center, spacing: 10.0){
                    Spacer()
                    Button("Press to dismiss") {
                        dismiss()
                    }
                    .font(.caption)
                    .padding(10)
                }
                HStack(alignment: .top){
                    Text(city)
                        .font(.largeTitle)
                        .bold()
                    
                    Button {
                        favorited.toggle()
                        if favorited{
                            favorite(city: city, latitude: latitude, longitude: longitude)
                        }else{
                            unfavorite(city: city)
                        }
                    } label: {
                        if favorited {
                            Image(systemName: "heart.fill")
                        } else {
                            Image(systemName: "heart")
                        }
                    }
                }
                
                switch aqius {
                case 0...50:
                    Text("Air Quality: Good")
                case 51...100:
                    Text("Air Quality: Moderate")
                case 101...150:
                    Text("Air Quality: Unhealthy for Sensitive Groups")
                case 151...200:
                    Text("Air Quality: Unhealthy")
                case 201...300:
                    Text("Air Quality: Very Unhealthy")
                default:
                    Text("No data for air quality")
                }
            }
        }
//        .background{
//            switch aqius {
//            case 0...50:
//                Color.green.edgesIgnoringSafeArea(.all)
//            case 51...100:
//                Color.yellow.edgesIgnoringSafeArea(.all)
//            case 101...150:
//                Color.orange.edgesIgnoringSafeArea(.all)
//            case 151...200:
//                Color.red.edgesIgnoringSafeArea(.all)
//            case 201...300:
//                Color.purple.edgesIgnoringSafeArea(.all)
//            default:
//                Color.gray.edgesIgnoringSafeArea(.all)
//            }
//        }
    }
    
    func unfavorite(city: String){
        let db = Firestore.firestore()

        db.collection("favorites")
            .whereField("city", isEqualTo: city)
            .getDocuments() { docs, error in
                if let error = error {
                    fatalError("unfavorite: error finding docs")
                } else {
                    DispatchQueue.main.async {
                        guard let document = docs?.documents.first else {
                           fatalError("no documents")
                        }
                        document.reference.updateData([
                            "favorited": false
                        ])
                    }
                    
                }
            }
    }
    
    func favorite(city: String, latitude: Double, longitude: Double){
        let db = Firestore.firestore()
        
        db.collection("favorites")
            .whereField("city", isEqualTo: city)
            .getDocuments() { docs, error in
                if let error = error {
                    fatalError("favorite: error finding docs")
                } else {
                    DispatchQueue.main.async {
                        guard let document = docs?.documents.first else {
                            favoritesvm.addFavorite(city: city, latitude: latitude, longitude: longitude)
                            return
                        }
                        document.reference.updateData([
                            "favorited": true
                        ])
                    }
                    
                }
            }
        }
    }


struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(city: "", aqius: 400, latitude: 0.0, longitude: 0.0, favoritesvm: FavoritesViewModel(), favorited: false)
    }
}

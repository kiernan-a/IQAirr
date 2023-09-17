//
//  CityView.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/17/23.
//

import SwiftUI
import Firebase

struct CityView: View {
    var city: String
    var aqius: Int
    @State var favorited: Bool
    
    var body: some View {
        HStack(alignment: .top){
            Text(city)
                .font(.largeTitle)
                .bold()
            Button {
                if favorited{
                    unfavorite(city: city)
                }else{
                    favorite(city: city)
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
    
    func favorite(city: String){
        let db = Firestore.firestore()

        db.collection("favorites")
            .whereField("city", isEqualTo: city)
            .getDocuments() { docs, error in
                if let error = error {
                    fatalError("favorite: error finding docs")
                } else {
                    DispatchQueue.main.async {
                        guard let document = docs?.documents.first else {
                           fatalError("no documents")
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
        CityView(city: "", aqius: 400, favorited: false)
    }
}

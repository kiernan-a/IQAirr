//
//  FavoritesViewModel.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/17/23.
//

import Foundation
import Firebase

class FavoritesViewModel: ObservableObject {
    
    @Published var favorites = [FavoritedLocation]()
    
    
    func getData() {
        //reference to database
        let db = Firestore.firestore()
        
        //reading the documents
        db.collection("favorites").getDocuments { docs, error in
            
            if error == nil{
                //putting this in the main thread bc causes UI changes
                print("no errors with accessing firebase")
                DispatchQueue.main.async {
                    if let docs = docs {
                        self.favorites = docs.documents.map { d in
                            print(d.documentID)
                            return FavoritedLocation(id: d.documentID,
                                                     city: d["city"] as? String ?? "",
                                                     favorited: d["favorited"] as? Bool ?? true,
                                                     latitude: d["latitude"] as? Double ?? 0.0,
                                                     longitude: d["longitude"] as? Double ?? 0.0)
                        }
                    }
                }
                
            } else {
                print(error?.localizedDescription)
                fatalError("Errors when getting documents")
            }
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

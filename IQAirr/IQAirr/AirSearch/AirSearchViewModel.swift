//
//  AirSearchViewModel.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.
//

import Foundation

class AirSearchViewModel: ObservableObject {
    let service: AirSearchService = AirSearchService()
    let locationManager = LocationManager().locationManager
    
    @Published var state: loadingState = loadingState.loading
    @Published var stateString: String = "Loading"
    @Published var search: LocationSearch = LocationSearch(status: "", data: DataClass(city: "", state: "", country: "", location: Location(type: "", coordinates: []), current: Current(pollution: Pollution(ts: "", aqius: 0, mainus: Main(rawValue: "p1")!, aqicn: 0, maincn: Main(rawValue: "p1")!), weather: Weather(ts: "", tp: 0, pr: 0, hu: 0, ws: 0, wd: 0, ic: ""))))
//    @Published var location: UserLocation =
    
    @MainActor
    func searchAir() async {
        print("searchAir()")
        Task {
//            let airqual = try await service.airSearch(lat: 30, long: 80, completion: searchStateHandler)
            let airqual = await service.airSearch(lat: locationManager.location?.coordinate.latitude ?? 0.0,
                                                  long: locationManager.location?.coordinate.longitude ?? 0.0)
            self.search = airqual
            
        }
    }
    
}

extension AirSearchViewModel {
    func searchStateHandler(state: loadingState) -> Void{
        switch state {
        case .success:
            self.state = loadingState.success
            self.stateString = "Successfully loaded air quality"
        case .error:
            self.state = loadingState.error
            self.stateString = "Encountered error"
        case .loading:
            self.state = loadingState.loading
            self.stateString = "Loading data"
        }
    }
    
}

enum loadingState {
    //    case loading(message: String)
    //    case success(data: LocationSearch)
    //    case error(message: String)
    case loading
    case success
    case error
}

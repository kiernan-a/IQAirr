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
    
    @Published var state: loadingState = loadingState.idle
    @Published var stateString: String = "Loading"
    @Published var search: LocationSearch = LocationSearch(status: "", data: DataClass(city: "", state: "", country: "", location: Location(type: "", coordinates: [0.0, 0.0]), current: Current(pollution: Pollution(ts: "", aqius: 400, mainus: Main(rawValue: "p1")!, aqicn: 0, maincn: Main(rawValue: "p1")!), weather: Weather(ts: "", tp: 0, pr: 0, hu: 0, ws: 0, wd: 0, ic: ""))))
    
    @MainActor
    func searchAir() async {
        print("searchAir()")
        Task {
//            let airqual = try await service.airSearch(lat: 30, long: 80, completion: searchStateHandler)
            self.state = loadingState.loading
            do {
                let airqual = try await service.airSearch(lat: locationManager.location?.coordinate.latitude ?? 0.0,
                                                          long: locationManager.location?.coordinate.longitude ?? 0.0,
                                                          completion: searchStateHandler)
                self.search = airqual
            } catch {
                return
            }
            
        }
    }
    
}

extension AirSearchViewModel {
    func searchStateHandler(state: loadingState) -> Void{
        DispatchQueue.main.async{
            switch state {
            case .success(let search):
                self.state = loadingState.success(search)
                self.stateString = "Successfully loaded air quality"
            case .error(let error):
                self.state = loadingState.error(error)
                self.stateString = "Encountered error"
            case .loading:
                self.state = loadingState.loading
                self.stateString = "Loading data"
            case .idle:
                self.state = loadingState.idle
            }
        }
    }
    
}

enum loadingState {
    //    case loading(message: String)
    //    case success(data: LocationSearch)
    //    case error(message: String)
    case idle
    case loading
    case success(LocationSearch)
    case error(Error)
}

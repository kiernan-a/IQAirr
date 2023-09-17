//
//  AirSearchService.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.
//

import Foundation

// key: 25b6a0f1-09ee-4ec5-95df-b743f1d222d0

// ch-lat: 35.9132
// ch-long: 79.0558

// test url:  http://api.airvisual.com/v2/nearest_city?lat=35.932522&lon=-79.035728&key=25b6a0f1-09ee-4ec5-95df-b743f1d222d0
// test url: http://api.airvisual.com/v2/cities?state=North%20Carolina&country=USA&key=25b6a0f1-09ee-4ec5-95df-b743f1d222d0

struct AirSearchService {
    private let session: URLSession = URLSession.shared
    private let key = "25b6a0f1-09ee-4ec5-95df-b743f1d222d0"
    
    public func airSearch(lat: Double, long: Double, completion: @escaping (loadingState) -> Void) async throws -> LocationSearch{
//    public func airSearch(lat: Double, long: Double) async -> LocationSearch{
        print("airSearch()")
        
        //URL that we are making request to, confirming that it is valid, otherwise throwing an error to indicate something wrong during GET request
        guard let url = URL(string: "http://api.airvisual.com/v2/nearest_city?lat=\(lat)&lon=\(long)&key=\(key)") else {
            completion(loadingState.error(SearchError.invalidURL))
            throw SearchError.invalidURL
        }
            
        do {
            print(url)
            let (data, _) = try await session.data(from: url)
            print("made it past (data, _)")
            let citySearch =  try JSONDecoder().decode(LocationSearch.self, from: data)
            print("made it past decoder")
            completion(loadingState.success(citySearch))
            return citySearch
        } catch {
            completion(loadingState.error(error))
            throw SearchError.invalidData(error: error)
//            fatalError("Invalid data")
        }
        }
    
}

extension AirSearchService {
    enum SearchError: Error {
        case invalidURL
        case invalidData(error: Error)
        
    }
}

//
//  LocationSearch.swift
//  IQAirr
//
//  Created by Kiernan Almand on 9/16/23.
//

// Shoutout this website with decodeded the JSON objects for me: https://app.quicktype.io

import Foundation


//https://stackoverflow.com/questions/68213705/swift-initialise-model-object-with-initfrom-decoder
struct LocationSearch{
    
    let status: String
    let data: DataClass
    
}

extension LocationSearch: Codable {
    enum CodingKeys: String, CodingKey {
        case status, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.data = try container.decode(DataClass.self, forKey: .data)
      }
}

// MARK: - DataClass
struct DataClass: Codable {
    let city, state, country: String
    let location: Location
    let current: Current
}

// MARK: - Location
struct Location: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - Current
struct Current: Codable {
    let pollution: Pollution
    let weather: Weather
}

// MARK: - Pollution
struct Pollution: Codable {
    let ts: String
    let aqius: Int
    let mainus: Main
    let aqicn: Int
    let maincn: Main
//    let p2: Co
//    let p1: Co?
//    let n2, s2, co: Co
}

// MARK: - Co
struct Co: Codable {
    let conc: Double
    let aqius, aqicn: Int
}

enum Main: String, Codable {
    case p1 = "p1"
    case p2 = "p2"
}

// MARK: - Weather
struct Weather: Codable {
    let ts: String
    let tp, pr, hu, ws: Double
    let wd: Double
    let ic: String
}

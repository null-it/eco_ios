//
//  CitiesResponse.swift
//  carWash
//
//  Created by Juliett Kuroyan on 09.12.2019.
//  Copyright © 2019 VooDooLab. All rights reserved.
//


struct CitiesResponse: Codable {
    var cities: [CityResponse]
}


struct CityResponse: Codable {
    var city: String
    var coordinates: [Double]
    var isCurrent: Bool?
}

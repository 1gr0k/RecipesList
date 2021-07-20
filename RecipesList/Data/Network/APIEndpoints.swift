//
//  APIEndpoints.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct APIEndpoints {
    static func getRecepies(with recepiesRequestDTO: RecepiesRequestDTO) -> Endpoint<RecepiesResponseDTO> {
        
        return Endpoint(path: "recipes/complexSearch",
                        method: .get,
                        queryParametersEncodable: recepiesRequestDTO)
    }
}

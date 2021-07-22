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
    
    static func getDishImage(path: String) -> Endpoint<Data> {
        
        return Endpoint(path: "recipeImages/\(path)-312x231.jpg",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
            
    }
}

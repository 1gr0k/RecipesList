//
//  APIEndpoints.swift
//  RecipesList
//
//  Created by Андрей Калямин on 15.07.2021.
//

import Foundation

struct APIEndpoints {
    static func getRecepies(with recepiesRequestDTO: RecipesRequestDTO) -> Endpoint<RecipesResponseDTO> {
        
        return Endpoint(path: "recipes/complexSearch",
                        method: .get,
                        queryParametersEncodable: recepiesRequestDTO)
    }
    
    static func getRecipePreviewImage(path: String) -> Endpoint<Data> {
        
        return Endpoint(path: "recipeImages/\(path)-312x231.jpg",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
            
    }
    
    static func getDetailRecipeImage(path: String) -> Endpoint<Data> {
        return Endpoint(path: "recipeImages/\(path)-556x370.jpg",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
    
    static func getRecipeDetails(with recipeDetailsRequestDTO: RecipeDetailsRequestDTO) -> Endpoint<RecipeDetailsResponseDTO> {
        
        return Endpoint(path: "recipes/\(recipeDetailsRequestDTO.query)/information",
                        method: .get,
                        queryParametersEncodable: recipeDetailsRequestDTO)
//                        responseDecoder: RawDataResponseDecoder())
    }
    
   
    static func  getIngredientImage(path: String) -> Endpoint<Data> {
        return Endpoint(path: "cdn/ingredients_250x250/\(path).jpg",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
            
    }
}

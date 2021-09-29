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
    
//    static func getRecipeImage(path: String, imageSize: RecipeImageSizes) -> Endpoint<Data> {
//        
//        return Endpoint(path: "recipeImages/\(path)-\(imageSize.rawValue).jpg",
//                        method: .get,
//                        responseDecoder: RawDataResponseDecoder())
//            
//    }
    
    
    static func getRecipeDetails(with recipeDetailsRequestDTO: RecipeDetailsRequestDTO) -> Endpoint<RecipeDetailsResponseDTO> {
        
        return Endpoint(path: "recipes/\(recipeDetailsRequestDTO.recipeId)/information",
                        method: .get,
                        queryParametersEncodable: recipeDetailsRequestDTO)

    }
    
   
//    static func  getIngredientImage(path: String) -> Endpoint<Data> {
//        return Endpoint(path: "cdn/ingredients_250x250/\(path).jpg",
//                        method: .get,
//                        responseDecoder: RawDataResponseDecoder())
//
//    }
    
    static func getRecipesListByIds(with favouriteRecipesRequestDTO: FavouriteRecipesRequestDTO) -> Endpoint<[FavouriteRecipesResponseDTO.FavouriteReceptDTO]>{
        return Endpoint(path: "recipes/informationBulk",
                        method: .get,
                        queryParametersEncodable: favouriteRecipesRequestDTO)
    }
    
    static func getRandomRecipe(api: String) -> Endpoint<()>{
        return Endpoint(path: "recipes/random?apiKey=\(api)",
                        isFullPath: false,
                        method: .get,
                        queryParameters: ["apiKey":api])
    }
}

//
//  Recipes.swift
//  Recipes To-do
//
//  Created by Yash on 2021-11-04.
//

import Foundation

//custom class for Recipes
struct Recipes: Codable, Hashable {
    //properties
    var instuctions: String
    var name: String
    var ingredients: String
    var image: String
    var vegan = true
    var completed = false
    var id = UUID().uuidString
    
    //initializer
    init(instuctions: String, name: String, ingredients: String, image: String){
        self.instuctions = instuctions
        self.name = name
        self.ingredients = ingredients
        self.image = image

    }
    
}

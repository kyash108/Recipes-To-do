//
//  RecipesStore.swift
//  Recipes To-do
//
//  Created by Yash on 2021-11-01.
//

import Foundation

class RecipesStore{

    //MARK: Properties
    var alreadyCompleted = [Recipes]()
    var favouriteSites = [Recipes]()
    var recipeName: Recipes!

    var documentDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }

//MARK: - Methods for handling the cells of each sectios
    //Loading sample data for the app.
//    func loadStore(){
//        let recipes = Recipes(name: "Recipe Name", ingredients: "Recipe Ingredients", instuctions: "Recipe Ingredients", image: "AppIcon")
//        addNewVegRecipe(recipes: recipes)
//        addNewNonVegRecipe(recipes: recipes)
//        saveData()
//
//    }
    
    //Function to delete recipe from the section
    func deleteRecipe(at index: Int){
        favouriteSites.remove(at: index)
        saveData()
    }
    
    /// Load the contents of the sites.json file from the device document directory and decode the JSON
    func loadData() {
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("recipesInfo.json")
        print(fileName)
        //file decode JSON
        decodeJSON(from: fileName)
    }
    
    
    
    /// Save the contents of the sites.json file to the device document directory
    func saveData(){
        guard let documentDirectory = documentDirectory else { return }
        let fileName = documentDirectory.appendingPathComponent("recipesInfo.json")
        //encode the details to JSON
        saveJSON(to: fileName)
    }
    
    
    
    /// Decode the returned results from a passed url
    /// - Parameter url: url representing the location of the JSON file
    func decodeJSON(from url: URL){
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let resultsArray = try decoder.decode([Recipes].self, from: jsonData)
            
            for trail in resultsArray {
                favouriteSites.append(trail)
            }
        } catch {
            print("Could not decode - \(error.localizedDescription)")
        }
    }
    
    
    
    /// Save the favourites site array as JSON
    /// - Parameter url: Location to save the file to
    func saveJSON(to url: URL) {
        do{
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(favouriteSites)

            try jsonData.write(to: url)
        } catch {
            print("Problem saving the JSON file - \(error.localizedDescription)")
        }
    }
}

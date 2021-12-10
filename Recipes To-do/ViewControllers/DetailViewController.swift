//
//  DetailViewController.swift
//  Recipes To-do
//
//  Created by Yash on 2021-11-01.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var recipesImage: UIImageView!
    @IBOutlet weak var recipesName: UILabel!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipesInstructions: UITextView!
    //MARK: Properties
    var recipe: Recipes!
    var informationStore = RecipesStore()

    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesImage.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer()
        self.recipesImage.addGestureRecognizer(longTap)
        longTap.addTarget(self, action: #selector(handleLongTap))
    }
    
    //MARK: View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recipe = recipe {
            recipesName.text = recipe.name
            recipeIngredients.text = recipe.ingredients
            recipesInstructions.text = recipe.instuctions
            navigationItem.title = recipe.name
            recipesImage.image = UIImage(named: "AppIcon")
            

        }
    
            recipesImage.image = UIImage(named: "AppIcon")
        
    }

    @objc func handleLongTap(){
        if recipesImage.contentMode == .scaleAspectFit{
            recipesImage.contentMode = .scaleAspectFill
        }else{
            recipesImage.contentMode = .scaleAspectFit
        }
    }
}

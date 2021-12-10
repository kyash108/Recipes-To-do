//
//  ViewController.swift
//  Recipes To-do
//
//  Created by Yash on 2021-10-14.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    var informationStore = RecipesStore() 
    var recipeName: Recipes!
    var favouriteSites = [Recipes]()
    


    var veganRecipes: [Recipes]{
        return informationStore.favouriteSites.filter({
            $0.vegan == true
        })
    }
    var nonVeganRecipes: [Recipes]{
        return informationStore.favouriteSites.filter({
            $0.vegan == false
        })
    }
    var completedRecipes: [Recipes]{
        return informationStore.favouriteSites.filter({
            $0.completed == false
        })
    }


    
    //MARK: Outlets
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        
        informationStore.loadData()
        
        //Sorting the array
        informationStore.favouriteSites = Array(informationStore.favouriteSites).sorted(by: {$0.name < $1.name})
        
        tableview.reloadData()
        
        navigationController?.navigationBar.isTranslucent = true

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.red]
    }
    //MARK: Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Sorting the array
        informationStore.favouriteSites = Array(informationStore.favouriteSites).sorted(by: {$0.name < $1.name})
        tableview.reloadData()
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destinationVC = segue.destination as? AddTableViewController else {return}
        
        //Segue for edit dish
        destinationVC.recipeStore = informationStore
        if segue.identifier == "editDish" {
            let itemToPass: Recipes
            
            guard let selectedIndex = tableview.indexPathForSelectedRow else {return}
                itemToPass = informationStore.favouriteSites[selectedIndex.row]

            
            destinationVC.recipe = itemToPass
            destinationVC.title = "Edit recipe"
        
        }
        // Segue for add recipe
            else if segue.identifier == "addRecipes"{
           let destinationVC = segue.destination as! AddTableViewController
              destinationVC.recipeStore = informationStore
                destinationVC.title = "Add a recipe"
        }
    }
    
    
    
}
extension ViewController: UITableViewDelegate{
    
}

extension ViewController: UITableViewDataSource{
    //MARK: Table View
    
    //Animation for the cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotation = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotation
        UIView.animate(withDuration: 1.0){
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    //MARK: Swipe gesture
    //Deleting the cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //remove the entry/cell from the recipes JSON file
            informationStore.deleteRecipe(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
           
        }
    }

    //Adjusting the height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    //MARK: Cell for row
    //Adding data to the row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RecipesCellTableViewCell", for: indexPath) as! RecipesCellTableViewCell

        let site = informationStore.favouriteSites[indexPath.row]
        cell.recipeTitle?.text = site.name
        cell.ingredients?.text = site.ingredients
        cell.setImage(from: "\(site.image)")

        return cell
    }
    //MARK: Rows in section
    //Total number of rows in all the sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        informationStore.favouriteSites.count
    }
    //MARK: Number of section
    //Total number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Name of the sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Recipes"

    }
    
}

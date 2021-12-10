//
//  AddTableViewController.swift
//  Recipes To-do
//
//  Created by Yash on 2021-11-01.
//

import UIKit

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UNUserNotificationCenterDelegate{
    
    //MARK: Properties
//    var recipeName: Recipes!
    var recipeStore: RecipesStore!
    var recipe: Recipes!
    var access: ViewController!

    //MARK: Outlets
    @IBOutlet weak var insertPhoto: UIImageView!
    @IBOutlet weak var imageUrl: UITextField!
    @IBOutlet weak var insertName: UITextField!
    @IBOutlet weak var insertIngre: UITextView!
    @IBOutlet weak var insertInstruc: UITextView!
    @IBOutlet weak var category: UISegmentedControl!
    // MARK: Actions
    //Add image button
//    @IBAction func addImage(_ sender: Any) {
//        let picker = UIImagePickerController()
//        //It will select camera if availble otherwise it will open the photo library directly
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            picker.sourceType = .camera
//        }else{
//            picker.sourceType = .photoLibrary
//        }
//        picker.allowsEditing = true
//        picker.delegate = self
//        present(picker, animated: true)
//    }
    
    //Save info button
    @IBAction func saveInfo(_ sender: Any) {
        guard let recipesName = insertName.text,!recipesName.isEmpty else {return}
        guard let recipesIngre = insertIngre.text,!recipesIngre.isEmpty else {return}
        guard let recipesInstruc = insertInstruc.text,!recipesInstruc.isEmpty else {return}
        guard let recipesUrl = imageUrl.text,!recipesUrl.isEmpty else {return}
        

        // Editing the data
        if var editITem = recipe {
            editITem.instuctions = recipesInstruc
            editITem.name = recipesName
            editITem.ingredients = recipesIngre
            editITem.image = recipesUrl
            if category.selectedSegmentIndex == 0{
                editITem.vegan = true
            }else{
                editITem.vegan = false
            }
            

            for (index,recipe) in recipeStore.favouriteSites.enumerated(){
                if recipe.id == editITem.id{
                    recipeStore.favouriteSites[index] = editITem
                }
            }
            recipeStore.saveData()
            notify()
        }
        
        
        else {
            
        //Adding data to table view sections accordingly to the segmented index selected
        var newName = Recipes(instuctions: recipesInstruc, name: recipesName, ingredients: recipesIngre, image: recipesUrl)
            
        if category.selectedSegmentIndex == 0{
            newName.vegan = true
        }else{
            newName.vegan = false
        }
        recipeStore.favouriteSites.append(newName)
        recipeStore.saveData()
        notify()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: View did laod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertPhoto.image = UIImage(named: "burgers")
        tableView.tableFooterView = UIView()
        
        //MARK: Hide keyboard Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge,.sound], completionHandler: {
            granted, error in
            if granted {
                print("Access has been granted")
            } else {
                print("Access has not been granted")
                
            }
        })

        
        // Populating info for the edit
        if let editItem = recipe {
            insertName.text = editItem.name
            insertIngre.text = editItem.ingredients
            insertInstruc.text = editItem.instuctions
            imageUrl.text = editItem.image
            self.setImage(from: "\(editItem.image)")

            if editItem.vegan == true{
                category.selectedSegmentIndex = 0
            }else{
                category.selectedSegmentIndex = 1

            }
        }
       
    }

    // MARK: - Table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    //MARK: Dismiss keyboard gesture
    @objc func dismissKeyboard(_ gesture: UITapGestureRecognizer){
        insertName.resignFirstResponder()
        insertIngre.resignFirstResponder()
        insertInstruc.resignFirstResponder()
        imageUrl.resignFirstResponder()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Notification
    func notify(){
        let content = UNMutableNotificationContent()
            content.categoryIdentifier = "reminder"
            content.title = "Recipe To-do"
            content.body = "Hi! You recently added a recipe, if you would like to cook it, click on the notification or you may also select a random recipe."
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
            let request = UNNotificationRequest(identifier: "notification.timer.\(UUID().uuidString)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            if error != nil {
                print("Error adding a timer notification - \(String(describing:error?.localizedDescription))")
                
            }
            
        })
    }
    
    //MARK: Setting image
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.insertPhoto.image = image
            }
            
            
        }
    }
}

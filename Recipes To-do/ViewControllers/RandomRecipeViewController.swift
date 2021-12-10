//
//  RandomRecipeViewController.swift
//  Recipes To-do
//
//  Created by Yash on 2021-11-16.
//

import UIKit
import SafariServices

class RandomRecipeViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeButton: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    //MARK: Properties
    var link: String = ""
    let url = "https://www.themealdb.com/api/json/v1/1/random.php"
    var name = ""
    
    //MARK: Actions
    @IBAction func reload(_ sender: Any) {
        DispatchQueue.main.async {
            self.viewDidLoad()
            self.recipeName.text = "Guess the dish?"

            }        
    }
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()

        getData(from: url)
        recipeButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        
        //Setting long tap gesture to the image
        recipeImageView.isUserInteractionEnabled = true
        let longTap = UILongPressGestureRecognizer()
        self.recipeImageView.addGestureRecognizer(longTap)
        longTap.addTarget(self, action: #selector(handleLongTap))
        
        self.setupLabelTap()

    }
    
    //MARK: Gettting data
    private func getData(from url: String){
        // Do any additional setup after loading the view.
        let url = URL(string: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!){
            (data, response, error) in
            
            if error == nil && data != nil{
                let decoder = JSONDecoder()
                do{
                    let feed = try decoder.decode(Response.self, from: data!)
                    self.setImage(from: feed.meals[0].strMealThumb)
                    self.name = feed.meals[0].strMeal
                    
                    if feed.meals[0].strSource == ""{
                        self.link = "https://ykumar.scweb.ca/6338750.jpg"
                    }else{
                        self.link = feed.meals[0].strSource
                    }

                }
                catch{
                    print("error")
                    self.setImage(from: "https://ykumar.scweb.ca/burgers.png")
                    self.link = "https://ykumar.scweb.ca/6338750.jpg"
                    self.name = "Could not load the name."

                    
                    DispatchQueue.main.async {
                    //alert:
                        let alert = UIAlertController(title: "Error!", message: "Could not load the recipe. Please reload the page.", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: Setting image
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.recipeImageView.image = image
            }
            
            
        }
    }
    
    //MARK: Opening link
    @objc func openLink() {
        // Open the URL in the safari browser but creating a new veiw controller for it instead of opening safari
        let vc = SFSafariViewController(url: URL(string: "\(link)")!)
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
       }
    
    //Handing long tap for the image
    @objc func handleLongTap(){
        if recipeImageView.contentMode == .scaleAspectFit{
            recipeImageView.contentMode = .scaleAspectFill
        }else{
            recipeImageView.contentMode = .scaleAspectFit
        }
    }
    
    //MARK: Tap Label
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
            recipeName.text = name
        }
        
        func setupLabelTap() {
            
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
            self.recipeName.isUserInteractionEnabled = true
            self.recipeName.addGestureRecognizer(labelTap)
            
        }
    
    
}

//Struct for the API data
struct Response: Codable{
    var meals: [MyResults]
}

struct MyResults: Codable, Hashable{
    var strMealThumb: String
    var strSource: String
    var strMeal: String
    
    enum CodingKeys: String, CodingKey, Hashable{
        case strMealThumb
        case strSource
        case strMeal

    }
    
}

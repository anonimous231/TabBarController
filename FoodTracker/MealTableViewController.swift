//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Anonymous on 13/02/2018.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    // MARK: Properties
//    var meals = [Meal]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedMeals = loadMeals() {
           ClassStaticSave.meals += savedMeals
        }
        else {
            // Load the sample data.
            loadSampleMeals()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Tenemos sólo una sección, así que devolvemos 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClassStaticSave.meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Identificador que hemos elegido antes. Como iOS reutiliza las celdas para mejorar el rendimiento, es necesario indicar un identificador
        let cellIdentifier = "MealTableViewCell"

        // Hay que probar con el guard porque estamos haciendo un casting de un optional
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("La celda no es del tipo MealTableViewCell.")
        }
        
        // Hay que obtener la comida correcta del array
        let meal = ClassStaticSave.meals[indexPath.row]
        
        // Establecer los datos a mostrar en la vista
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            ClassStaticSave.meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let tabBarController = segue.destination as? UITabBarController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
//            guard let mealDetailViewController = tabBarController.viewControllers?.first as? NameMealViewController else {
//                fatalError("Couldn't instantiate NameMealViewController from tabbar")
//            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = ClassStaticSave.meals[indexPath.row]
            for i in (tabBarController.viewControllers)!{
                let nombre = i as? NameMealViewController
                
                nombre?.meal = selectedMeal
            }
            
//            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
 
    
    // MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                ClassStaticSave.meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                
                
                
                // Add a new meal.
                let newIndexPath = IndexPath(row: ClassStaticSave.meals.count, section: 0)
                
                ClassStaticSave.meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            // Save the meals.
            saveMeals()
        }
    }
    
    // MARK: Private methods
    private func loadSampleMeals() {
        // Cargar las imágenes de prueba
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
    
        guard let meal1 = Meal(name: "Ensalada Caprese", photo: photo1, rating: 4, index: 0) else {
            fatalError("No se puede instanciar meal1")
        }
        
        guard let meal2 = Meal(name: "Pollo con patatas", photo: photo2, rating: 5, index: 0) else {
            fatalError("No se puede instanciar meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta con albóndigas", photo: photo3, rating: 3, index: 0) else {
            fatalError("No se puede instanciar meal3")
        }
        
        // Una vez creadas correctamente, se insertan en el array
        ClassStaticSave.meals += [meal1, meal2, meal3]
    
    }
    
    
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(ClassStaticSave.meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    

    private func loadMeals() -> [Meal]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
    }
    


}

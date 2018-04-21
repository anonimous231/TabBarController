//
//  NameMealViewController.swift
//  FoodTracker
//
//  Created by José Ángel on 17/4/18.
//  Copyright © 2018 José Negrillo. All rights reserved.
//

import UIKit
import os.log

class NameMealViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    var photoImageView: UIImageView!
    var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
        }
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("Joder, que no vale")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("El botón de guardar no se ha pulsado, cancelando", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name!, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Deshabilitar el botón de guardado mientras se edita
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    private func updateSaveButtonState() {
        // Deshabilitar el botón de guardado mientras el TextField esté deshabilitado
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

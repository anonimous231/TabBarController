//
//  NameMealViewController.swift
//  FoodTracker
//
//  Created by Anonymous on 17/4/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import os.log

class NameMealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?

    override func viewDidLoad() {
        super.viewDidLoad()
        if(nameTextField != nil){
        nameTextField.delegate = self
        }
        if let meal = meal {
            navigationItem.title = meal.name
            if(nameTextField != nil){
            nameTextField.text = meal.name
            updateSaveButtonState()
            }
            if(photoImageView != nil){
            photoImageView.image = meal.photo
            }
            if(ratingControl != nil){
            ratingControl.rating = meal.rating
            }
        }
        
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
            fatalError("Error Fatal durante la ejecución")
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
        let index = 0
        
        meal = Meal(name: name!, photo: photo, rating: rating, index: index)
        
        
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Antes de nada ocultar el teclado
        nameTextField.resignFirstResponder()
        
        // Instanciamos un image picker, que permite al usuario coger una foto de su galería
        let imagePickerController = UIImagePickerController()
        
        // Sólo permitimos las imágenes de la galería, no que se abra la cámara
        // Nota: .photoLibrary es equivalente a UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.sourceType = .photoLibrary
        
        // Establecemos el delegate, ya que el manejo de eventos lo haremos en nuestro propio ViewController
        imagePickerController.delegate = self
        
        // Por último, mostramos el picker
        present(imagePickerController, animated: true, completion: nil)
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // El diccionario seleccionado contiene múltiples representaciones de la imagen. Nosotros la que queremos es la original. Como el acceso a un Dictionary devuelve un optional, hay que manejar correctamente la situación.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Se esperaba un diccionario que tuviera una imagen, pero se encontró: \(info)")
        }
        
        // Si hemos llegado aquí es que cuando el usuario ha seleccionado una imagen, todo ha ido bien.
        // Establecemos la imagen en el ImageView
        photoImageView.image = selectedImage
        
        // Por último cerrar el picker
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        // Deshabilitar el botón de guardado mientras el TextField esté deshabilitado
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

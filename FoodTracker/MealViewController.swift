//
//  ViewController.swift
//  FoodTracker
//
//  Created by José Negrillo on 15/01/2018.
//  Copyright © 2018 José Negrillo. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Este valor se pasará desde el MealTableViewController o se creará aquí, dependiendo de cómo se cree esta vista
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hay que asignar el delegado para manejar los eventos de texto, en este caso es el propio ViewController
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        // Actualizar el botón de guardado
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // Permite configurar el view controller antes de presentarlo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Comprueba si el botón pulsado es exactamente el botón de guardar
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("El botón de guardar no se ha pulsado, cancelando", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? "" // Si no hay nada en el text field, asigno una cadena vacía
        let photo = photoImageView.image
        let rating = ratingControl.rating
    
        meal = Meal(name: name, photo: photo, rating: rating)
        
    }
    
    // MARK: Actions
    
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
    
    // MARK: UITextFieldDelegate
    // Aquí se deben implementar todos los métodos para el manejo de entradas de texto
    
    /**
     * Método para manejar la pulsación en Enter en el teclado
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Ocultar el teclado
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Método que se ejecuta cuando se empieza a editar el texto
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Deshabilitar el botón de guardado mientras se edita
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    /**
     * Método para controlar cuando el usuario pulse cancelar en el picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Cerramos el picker
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Método que se lanza cuando el usuario elige una imagen
     */
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
    
    // MARK: Private methods
    private func updateSaveButtonState() {
        // Deshabilitar el botón de guardado mientras el TextField esté deshabilitado
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}


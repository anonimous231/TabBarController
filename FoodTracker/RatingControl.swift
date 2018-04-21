//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Anonymous on 29/01/2018.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    // MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet { updateButtonSelectionStates() }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet { setupButtons() }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet { setupButtons() }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button action
    @objc func ratingButtonTapped(button: UIButton) {
        // Buscar el índice del botón pulsado
        guard let index = ratingButtons.index(of: button) else {
            fatalError("El botón \(button) no está en el array ratingButtons: \(ratingButtons)")
        }
        
        // Calcular la valoración (pasar de escala 0-4, a 0-5)
        let selectedRating = index + 1
        
        // Si la puntuación seleccionada es la misma que había la ponemos a 0
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
       
    }
    
    // MARK: Private methods
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Carga de las imágenes
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            // Creación del botón
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        
            // Añadir las restricciones
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Dar funcionalidad al botón
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Añadir el botón al Stack
            addArrangedSubview(button)
        
            // ... y al array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // Si el índice del botón es menor que su puntación, el botón tiene que marcarse
            if (index < rating) {
                button.isSelected = true
            }
            else {
                button.isSelected = false
            }
            // lo anterior es lo mismo que button.isSelected = index < rating
        }
    }
}

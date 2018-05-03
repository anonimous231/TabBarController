//
//  Meal.swift
//  FoodTracker
//
//  Created by Anonymous on 30/01/2018.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import os.log
class Meal: NSObject, NSCoding  {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, index: 0)
    }
    
    
    // MARK: Properties
    var name: String
    var photo: UIImage? // Es un optional porque lo mismo la comida no tiene foto asignada
    var rating: Int
    var index: Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    

    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    // MARK: Initializers
    init?(name: String, photo: UIImage?, rating: Int, index: Int) {
        
        // Si el nombre o la valoración no son válidos, devuelvo nulo
        if (name.isEmpty || rating < 0 || rating > 5) {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.index = 0
    }
    
}

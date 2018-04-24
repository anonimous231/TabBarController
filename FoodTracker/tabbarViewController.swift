//
//  tabbarViewController.swift
//  FoodTracker
//
//  Created by José Ángel on 23/4/18.
//  Copyright © 2018 José Negrillo. All rights reserved.
//

import UIKit

class tabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Methods
    
    @IBAction func SaveTap(_ sender: Any) {
        
        ClassStaticSave.meals.remove(at: (ClassStaticSave.newMeal?.index)!)
        ClassStaticSave.meals.insert(ClassStaticSave.newMeal!, at: (ClassStaticSave.newMeal?.index)!)
    }
    

}

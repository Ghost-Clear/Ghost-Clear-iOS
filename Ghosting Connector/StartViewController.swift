//
//  StartViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Darwin
import CoreData
import CoreBluetooth
class StartViewController: UIViewController {

    var bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if(someEntityExists(id: true)){
           let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
            
            
            
        }
        else{
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                // Put your code which should be executed with a delay here
                self.performSegue(withIdentifier: "goToHomePage", sender: nil)
            }
             
            
                    }
        // Do any additional setup after loading the view.
    }
    func someEntityExists(id: Bool) -> Bool {
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IsFirstLaunch")
             fetchRequest.includesSubentities = false
             
             var entitiesCount = 0

             do {
                 entitiesCount = try context.count(for: fetchRequest)
             }
             catch {
                 print("error executing fetch request: \(error)")
             }

             return entitiesCount == 0
             
         }
        return false
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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
class LaunchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // if it is the first launch, allow the user to sign up
		// else go to the home page
		if(someEntityExists(id: true)){
           let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.performSegue(withIdentifier: "InitialPageViewControllerSegue", sender: nil)
            }
        }
        else{
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                self.performSegue(withIdentifier: "HomePageViewControllerSegue", sender: nil)
            }
		}
    }
	// check if there are entities of the IsFirstLaunch type
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
}

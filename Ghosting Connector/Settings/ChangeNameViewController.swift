//
//  changeNameViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class ChangeNameViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        nameField.attributedPlaceholder = NSAttributedString(string: "Your First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }
    @IBOutlet var nameField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    @IBAction func applyChange(_ sender: Any) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Name")

    // Configure Fetch Request
    fetchRequest.includesPropertyValues = false
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            do {
                let items = try context.fetch(fetchRequest) as! [NSManagedObject]

                for item in items {
                    context.delete(item)
                }

                
                try context.save()

            } catch {
                
            }
        }
         if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let name = Name(context: context)
            name.name = nameField.text!
            
        }
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        self.dismiss(animated: true, completion: nil)
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

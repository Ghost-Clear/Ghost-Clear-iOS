//
//  InitialLoginViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class InitialLoginViewController: UIViewController, UITextFieldDelegate {
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
    }
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
		nextButton.imageView?.contentMode = .scaleAspectFit
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Your First Name",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        nameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func continueFromLoginbutton(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let name = Name(context: context)
            name.name = nameTextField.text
    
        }
        //let finalData = joke()
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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

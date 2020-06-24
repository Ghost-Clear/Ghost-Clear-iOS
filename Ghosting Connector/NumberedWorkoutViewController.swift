//
//  NumberedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/10/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class NumberedWorkoutViewController: UIViewController {
    var isRandomized = false
    var isFR = true
    var isFL = true
    var isCR = true
    var isCL = true
    var isLR = true
    var isLL = true
    
	@IBOutlet weak var setsField: UITextField!
	@IBOutlet weak var ghostsField: UITextField!
	
	@IBOutlet var blankRandomize: UIButton!
    @IBAction func unRandomize(_ sender: Any) {
        isRandomized = true
        blankRandomize.isHidden = true
        randomizeButton.isHidden = false
        print(isRandomized)
    }
    
    @IBOutlet var randomizeButton: UIButton!
    @IBAction func randomize(_ sender: Any) {
        isRandomized = false
        blankRandomize.isHidden = false
        randomizeButton.isHidden = true
        print(isRandomized)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        blankRandomize.isHidden = true
        
        frontRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBOutlet var frontLeft: UIButton!
    @IBAction func FL(_ sender: Any) {
        if isFL{
               frontLeft.setImage(nil, for: .normal)
               isFL = false
               }
               else{
                   isFL = true
                   frontLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
               }
    }
    @IBOutlet var frontRight: UIButton!
    
    @IBAction func FR(_ sender: Any) {
        if isFR{
        frontRight.setImage(nil, for: .normal)
        isFR = false
        }
        else{
            isFR = true
            frontRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
        }
    }
    
    @IBAction func CL(_ sender: Any) {
        if isCL{
        centerLeft.setImage(nil, for: .normal)
        isCL = false
        }
        else{
            isCL = true
            centerLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
        }
    }
    
    @IBOutlet var lowerLeft: UIButton!
    @IBOutlet var centerLeft: UIButton!
    @IBAction func LL(_ sender: Any) {
        if isLL{
               lowerLeft.setImage(nil, for: .normal)
               isLL = false
               }
               else{
                   isLL = true
                   lowerLeft.setImage(UIImage(named: "Ellipse 15"), for: .normal)
               }
    }
    
    
    @IBOutlet var centerRight: UIButton!
    @IBAction func CR(_ sender: Any) {
        if isCR{
                     centerRight.setImage(nil, for: .normal)
                     isCR = false
                     }
                     else{
                         isCR = true
                         centerRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
                     }
    }
    
   
    
    
    @IBOutlet var lowerRight: UIButton!
    @IBAction func LR(_ sender: Any) {
        if isLR{
                     lowerRight.setImage(nil, for: .normal)
                     isLR = false
                     }
                     else{
                         isLR = true
                         lowerRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
                     }
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

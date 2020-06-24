//
//  TimedWorkoutViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/10/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreBluetooth
class TimedWorkoutViewController: UIViewController, UITextFieldDelegate {
    var isRandomized = false
       var isFR = true
       var isFL = true
       var isCR = true
       var isCL = true
       var isLR = true
       var isLL = true
     @IBOutlet var blankRandomize: UIButton!
     @IBAction func unRandomize(_ sender: Any) {
         isRandomized = true
         blankRandomize.isHidden = true
         randomizeButton.isHidden = false
         print(isRandomized)
     }
	@IBAction func setFieldSelected(_ sender: Any) {
		if minutesField.text == ""{
			minutesField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if secondsField.text == ""{
			secondsField.text = "0"
		}
		setsField.text = ""
	}
	
	@IBAction func minutesFieldSelected(_ sender: Any) {
		if minutesField.text == ""{
			minutesField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if secondsField.text == ""{
			secondsField.text = "0"
		}
		minutesField.text = ""
	}
	
	@IBAction func secondFieldSelected(_ sender: Any) {
		if minutesField.text == ""{
			minutesField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if secondsField.text == ""{
			secondsField.text = "0"
		}
		secondsField.text = ""
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if minutesField.text == ""{
			minutesField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if secondsField.text == ""{
			secondsField.text = "0"
		}
	}
   
	@IBAction func startWorkout(_ sender: Any) {
		if(((secondsField.text! as NSString).integerValue) < 60 && ((secondsField.text! as NSString).integerValue) >= 0 && ((minutesField.text! as NSString).integerValue) < 60 && ((minutesField.text! as NSString).integerValue) >= 0 && secondsField.text! != "" && minutesField.text! != "" && setsField.text != "" && setsField.text != "0"){
        performSegue(withIdentifier: "doTimedWorkoutSegue", sender: nil)
        }
        else{
            let alertVC = UIAlertController(title: "Times not in range", message: "Make sure that your minutes and seconds are between 0 and 59 and your sets are greater than 0.", preferredStyle: UIAlertController.Style.alert)
              let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) -> Void in
                  alertVC.dismiss(animated: true, completion: nil)
                  //add segue
              })
              alertVC.addAction(action)
              self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet var randomizeButton: UIButton!
     @IBAction func randomize(_ sender: Any) {
         isRandomized = false
         blankRandomize.isHidden = false
         randomizeButton.isHidden = true
         print(isRandomized)
     }
    @IBOutlet var secondsField: UITextField!
    @IBOutlet var minutesField: UITextField!
	@IBOutlet weak var setsField: UITextField!
	
         override func viewDidLoad() {
         super.viewDidLoad()
         blankRandomize.isHidden = true
        frontRight.setImage(UIImage(named: "Ellipse 15"), for: .normal)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         // Do any additional setup after loading the view.
     }
	@objc func keyboardWillHide(notification: NSNotification) {
		if minutesField.text == ""{
			minutesField.text = "0"
		}
		if setsField.text == ""{
			setsField.text = "0"
		}
		if secondsField.text == ""{
			secondsField.text = "0"
		}
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
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
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
     

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "doTimedWorkoutSegue" {
          if let childVC = segue.destination as? DoTimedWorkoutViewController {
            //Some property on ChildVC that needs to be set
            childVC.FR = isFR
            childVC.FL = isFL
            childVC.CR = isCR
            childVC.CL = isCL
            childVC.LL = isLL
            childVC.LR = isLR
			childVC.numSets = (setsField.text! as NSString).integerValue
			childVC.numMinutes = (minutesField.text! as NSString).integerValue
			childVC.numSeconds = (secondsField.text! as NSString).integerValue
            childVC.isRandom = isRandomized
          }
        }
        
    }
    

}

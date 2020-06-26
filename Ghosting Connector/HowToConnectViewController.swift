//
//  HowToConnectViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/16/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import CoreData
class HowToConnectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	//TODO: implement this
    @IBAction func refresh(_ sender: Any) {
		resetAllRecords(in: "BLEkey");
    }
	func resetAllRecords(in entity : String) // entity = Your_Entity_Name
	{
		
		let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
		let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
		do
		{
			try context.execute(deleteRequest)
			try context.save()
		}
		catch
		{
			print ("There was an error")
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

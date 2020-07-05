//
//  WorkoutButtonsPageViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/5/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit

class WorkoutButtonsPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	var pages = [UIViewController]()
	var parentView : HomePageViewController!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
		self.dataSource = self
		
		let page1: FirstButtonSetViewController! = ((storyboard?.instantiateViewController(withIdentifier: "page1") as! FirstButtonSetViewController))
		page1.parentView = self
		let page2: UIViewController! = ((storyboard?.instantiateViewController(withIdentifier: "page2")))
		
		pages.append(page1 as UIViewController)
		pages.append(page2 as UIViewController)
		
		setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
	}
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let currentIndex = pages.firstIndex(of: viewController)!
		let previousIndex = abs((currentIndex - 1) % pages.count)
		return pages[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let currentIndex = pages.firstIndex(of: viewController)!
		let nextIndex = abs((currentIndex + 1) % pages.count)
		return pages[nextIndex]
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return pages.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
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

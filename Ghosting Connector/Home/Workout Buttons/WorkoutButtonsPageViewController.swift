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
	
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let pageContentViewController = pageViewController.viewControllers![0]
		self.parentView.pageControl.currentPage = pages.firstIndex(of: pageContentViewController)!
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
		self.dataSource = self
		
		let page1: FirstButtonSetViewController! = ((storyboard?.instantiateViewController(withIdentifier: "page1") as! FirstButtonSetViewController))
		page1.parentView = self
		let page2: SecondButtonSetViewController! = ((storyboard?.instantiateViewController(withIdentifier: "page2") as! SecondButtonSetViewController))
		page2.parentView = self
		
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
}

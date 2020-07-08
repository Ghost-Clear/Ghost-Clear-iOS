//
//  HomeChartPageViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/6/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
class HomeChartPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let currentIndex = pages.firstIndex(of: viewController)!
		if currentIndex == 0{
			return pages[2]
		}
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
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		let pageContentViewController = pageViewController.viewControllers![0]
		self.parentView.chartPageControl.currentPage = pages.firstIndex(of: pageContentViewController)!
	}
	var pages = [UIViewController]()
	var parentView : HomePageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.delegate = self
		self.dataSource = self
		
		let page1: HomeWorkoutsThisWeekViewController! = ((storyboard?.instantiateViewController(withIdentifier: "chartPage1") as! HomeWorkoutsThisWeekViewController))
		page1.parentView = self
		let page2: BeepTestProgressChartViewController! = ((storyboard?.instantiateViewController(withIdentifier: "chartPage2") as! BeepTestProgressChartViewController))
		page2.parentView = self
		let page3: WorkoutCompositionGraphViewController! = ((storyboard?.instantiateViewController(withIdentifier: "chartPage3") as! WorkoutCompositionGraphViewController))
		page3.parentView = self
		pages.append(page1 as UIViewController)
		pages.append(page2 as UIViewController)
		pages.append(page3 as UIViewController)
		setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
}

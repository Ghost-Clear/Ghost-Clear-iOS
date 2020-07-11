//
//  WorkoutCompositionGraphViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/7/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Charts
import CoreData
class WorkoutCompositionGraphViewController: UIViewController {
	var parentView : HomeChartPageViewController!
	@IBOutlet weak var thePieChart: PieChartView!
	var workoutsFromCoreData = [Workout]()
	override func viewDidLoad() {
        super.viewDidLoad()
		customizeGraph()
		thePieChart.highlightPerTapEnabled = false
		thePieChart.legend.enabled = true
		thePieChart.extraTopOffset = 0
		thePieChart.extraBottomOffset = -10
		thePieChart.extraRightOffset = 0
		thePieChart.extraLeftOffset = 0
		thePieChart.holeColor = UIColor(red: 20/256, green: 30/256, blue: 36/256, alpha: 1)
		thePieChart.transparentCircleRadiusPercent = 0.0
		thePieChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeOutExpo)
		thePieChart.legend.font = .systemFont(ofSize: 14)
		thePieChart.legend.textColor = .white
		thePieChart.drawEntryLabelsEnabled = false
		thePieChart.legend.xEntrySpace = 10
		thePieChart.noDataFont = .systemFont(ofSize: 14)
		thePieChart.noDataTextColor = .white
		thePieChart.noDataText = "No workouts have been completed"
    }
	override func viewWillAppear(_ animated: Bool) {
		customizeGraph()
		thePieChart.highlightPerTapEnabled = false
		thePieChart.legend.enabled = true
		thePieChart.extraTopOffset = -25
		thePieChart.extraBottomOffset = 0
		thePieChart.extraRightOffset = 0
		thePieChart.extraLeftOffset = 0
		thePieChart.holeColor = UIColor(red: 20/256, green: 30/256, blue: 36/256, alpha: 1)
		thePieChart.transparentCircleRadiusPercent = 0.0
		thePieChart.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeOutExpo)
		thePieChart.legend.font = .systemFont(ofSize: 14)
		thePieChart.legend.textColor = .white
		thePieChart.drawEntryLabelsEnabled = false
		thePieChart.legend.xEntrySpace = 10
		thePieChart.noDataFont = .systemFont(ofSize: 14)
		thePieChart.noDataTextColor = .white
		thePieChart.noDataText = "No workouts have been completed"
	}
	func customizeGraph(){
		thePieChart.legend.xEntrySpace = 20
		let dataPoints = ["Timed", "Number", "Beep Test", "Play Pro"]
		var timedCount = 0
		var numberCount = 0
		var beepCount = 0
		var proCount = 0
		var values : [Double]! = []
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workoutsFromCore = try? context.fetch(Workout.fetchRequest()){
				let wFromCore = workoutsFromCore as! [Workout]
				workoutsFromCoreData = wFromCore
			}
		}
		for w in workoutsFromCoreData{
			if w.type == "Timed"{
				timedCount += 1
			}
			else if w.type == "Number"{
				numberCount += 1
			}
			else if w.type == "Beep Test"{
				beepCount += 1
			}
			else if w.type == "Pro"{
				proCount += 1
			}
		}
		values.append(Double(timedCount))
		values.append(Double(numberCount))
		values.append(Double(beepCount))
		values.append(Double(proCount))
		if timedCount != 0 || numberCount != 0 || beepCount != 0{
		var dataEntries : [ChartDataEntry]! = []
		for i in 0..<dataPoints.count{
			let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
			dataEntries.append(dataEntry)
		}
		let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
		pieChartDataSet.drawValuesEnabled = false
		pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
		let pieChartData = PieChartData(dataSet: pieChartDataSet)
		let format = NumberFormatter()
		format.numberStyle = .none
		let formatter = DefaultValueFormatter(formatter: format)
		pieChartData.setValueFormatter(formatter)
		
			thePieChart.data = pieChartData
		}
		else{
			thePieChart.data = nil
		}

	}
	private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
		let colors: [UIColor] = [UIColor(red: 0/256, green: 233/256, blue: 143/256, alpha: 1), UIColor(red: 255/256, green: 61/256, blue: 83/256, alpha: 1),UIColor(red: 295/256, green: 197/256, blue: 66/256, alpha: 1),UIColor(red: 0/256, green: 141/256, blue: 240/256, alpha: 1)]
		
		return colors
	}
}

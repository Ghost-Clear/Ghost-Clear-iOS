//
//  BeepTestProgressChartViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/6/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Charts
import CoreData
class BeepTestProgressChartViewController: UIViewController {
	var parentView : HomeChartPageViewController!
	@IBOutlet weak var theLineChart: LineChartView!
	var beepTestScores : [Workout]! = []
	var beepTestDates : [String]! = []
	var workoutsFromCore : [Workout]!
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		updateGraph()
		theLineChart.fitScreen()
		theLineChart.extraRightOffset = 30
		theLineChart.extraLeftOffset = 30
	}
	func updateGraph(){
		beepTestScores = []
		beepTestDates = []
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let workouts = try? context.fetch(Workout.fetchRequest()){
				workoutsFromCore = (workouts as! [Workout])
			}
		}
		workoutsFromCore = workoutsFromCore.sorted(by: {
			$0.date!.compare($1.date!) == .orderedDescending
		})
		for w in workoutsFromCore{
			if w.type == "Beep Test"{
				beepTestScores.append(w)
				let dateFormatterPrint = DateFormatter()
				dateFormatterPrint.dateFormat = "MM/dd"
				beepTestDates.append(dateFormatterPrint.string(from: w.date!))
			}
			if beepTestScores.count == 7{
				break
			}
		}
		if beepTestScores.count != 0{
			var lineChartEntry = [ChartDataEntry]()
			theLineChart.animate(xAxisDuration: 0.5, yAxisDuration: 0, easingOption: .linear)
			for i in 0..<beepTestScores.count{
				let value = ChartDataEntry(x: Double(i), y: (beepTestScores[i].score! as NSString).doubleValue)
				lineChartEntry.append(value)
			}
			let line1 = LineChartDataSet(entries: lineChartEntry, label: "Scores")
			
			line1.colors = [UIColor(red: 0, green: 1.0, blue: 0.6, alpha: 1.00)]
			let data = LineChartData()
			line1.drawCircleHoleEnabled = false
			line1.drawVerticalHighlightIndicatorEnabled = false
			line1.drawHorizontalHighlightIndicatorEnabled = false
			line1.circleRadius = 5
			line1.circleColors = [UIColor(red: 0, green: 1.0, blue: 0.6, alpha: 1.00)]
			line1.valueFormatter = DefaultValueFormatter(decimals: 1)
			data.addDataSet(line1)
			theLineChart.data = data
		}
		else{
			theLineChart.data = nil
		}
		theLineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: beepTestDates)
		theLineChart.xAxis.granularity = 1
		theLineChart.xAxis.labelFont = .systemFont(ofSize: 13)
		theLineChart.xAxis.labelTextColor = .white
		theLineChart.xAxis.axisLineColor = .white
		theLineChart.gridBackgroundColor = .clear
		theLineChart.drawBordersEnabled = false
		theLineChart.dragYEnabled = false
		theLineChart.scaleXEnabled = false
		theLineChart.scaleYEnabled = false
		theLineChart.doubleTapToZoomEnabled = false
		theLineChart.drawGridBackgroundEnabled = false
		theLineChart.noDataTextColor = UIColor.white
		theLineChart.noDataFont = .systemFont(ofSize: 14)
		theLineChart.noDataText = "No beep tests have been completed"
		theLineChart.xAxis.drawLabelsEnabled = true
		theLineChart.xAxis.drawGridLinesEnabled = false
		theLineChart.leftAxis.drawGridLinesEnabled = false
		theLineChart.leftAxis.drawLabelsEnabled = false
		theLineChart.leftAxis.drawZeroLineEnabled = false
		theLineChart.leftAxis.drawAxisLineEnabled = false
		theLineChart.rightAxis.drawGridLinesEnabled = false
		theLineChart.rightAxis.drawLabelsEnabled = false
		theLineChart.rightAxis.drawZeroLineEnabled = false
		theLineChart.rightAxis.drawAxisLineEnabled = false
		theLineChart.drawMarkers = false
		theLineChart.legend.enabled = false
		theLineChart.xAxis.labelPosition = .bottom
		theLineChart.lineData?.setValueFont(.systemFont(ofSize: 13))
		theLineChart.lineData?.setValueTextColor(.white)
		theLineChart.highlightPerTapEnabled = false
		
	}
}

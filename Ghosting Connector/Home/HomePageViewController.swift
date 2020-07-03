//
//  HomePageViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 6/8/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Charts
import CoreBluetooth
protocol GetChartData {
    func getChartData(with dataPoints: [String], values : [Int])
    var weeks : [String]{get set}
    var numWorkouts : [String]{get set}
}
class DigitValueFormatter : NSObject, IValueFormatter {
	func stringForValue(_ value: Double,
						entry: ChartDataEntry,
						dataSetIndex: Int,
						viewPortHandler: ViewPortHandler?) -> String {
		let valueWithoutDecimalPart = String(format: "%.0f", value)
		return "\(valueWithoutDecimalPart)"
	}
}
class HomePageViewController: UIViewController {
	@IBOutlet weak var numberWorkoutButton: UIButton!
	@IBOutlet weak var timedWorkoutButton: UIButton!
	@IBOutlet weak var viewGoalsButton: UIButton!
	@IBOutlet weak var viewWorkoutButton: UIButton!
	var namesFromCore = [Name]()
    var name = ""
    var days: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    @IBOutlet weak var welcomeLabel: UILabel!
    var numWorkouts = [0,0,0,0,0,0,0]
    @IBOutlet weak var theBarChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
		numberWorkoutButton.imageView?.contentMode = .scaleAspectFit
		timedWorkoutButton.imageView?.contentMode = .scaleAspectFit
		viewGoalsButton.imageView?.contentMode = .scaleAspectFit
		viewWorkoutButton.imageView?.contentMode = .scaleAspectFit
    }
    override func viewWillAppear(_ animated: Bool) {
		 numWorkouts = [0,0,0,0,0,0,0]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let nameFromCore = try? context.fetch(Name.fetchRequest()){
                let allNamesFromCore = nameFromCore as! [Name]
                namesFromCore = allNamesFromCore
                if namesFromCore.count != 0{
                    welcomeLabel.text = "Welcome " + namesFromCore[0].name! + "!"
                }
            }
        }
		var workoutsFromCore : [Workout] = []
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let wFromCore = try? context.fetch(Workout.fetchRequest()){
				let allwFromCore = wFromCore as! [Workout]
				workoutsFromCore = allwFromCore
			}
		}
		for workout in workoutsFromCore{
			let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
			let date1 = NSDate()
			let date2 = workout.date!
			let weekOfYear1 = calendar!.component(NSCalendar.Unit.year, from: date1 as Date)
			let weekOfYear2 = calendar!.component(NSCalendar.Unit.year, from: date2 as Date)
			
			let year1 = calendar!.component(NSCalendar.Unit.year, from: date1 as Date)
			let year2 = calendar!.component(NSCalendar.Unit.year, from: date2 as Date)
			
			if (weekOfYear1 == weekOfYear2
				&& year1 == year2
				) {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "EEEE"
				let dayOfTheWeekString = dateFormatter.string(from: workout.date!)
				if dayOfTheWeekString == "Sunday"{
					numWorkouts[0] += 1
				}
				if dayOfTheWeekString == "Monday"{
					numWorkouts[1] += 1
				}
				if dayOfTheWeekString == "Tuesday"{
					numWorkouts[2] += 1
				}
				if dayOfTheWeekString == "Wednesday"{
					numWorkouts[3] += 1
				}
				if dayOfTheWeekString == "Thursday"{
					numWorkouts[4] += 1
				}
				if dayOfTheWeekString == "Friday"{
					numWorkouts[5] += 1
				}
				if dayOfTheWeekString == "Saturday"{
					numWorkouts[6] += 1
				}
			}
		}
		customizeChart(dataPoints: days, values: numWorkouts)
    }
    func customizeChart(dataPoints: [String], values: [Int]) {        
        theBarChart.animate(xAxisDuration: 1, yAxisDuration: 2, easingOption: ChartEasingOption.easeOutExpo)
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Workouts")
		chartDataSet.valueFormatter = DigitValueFormatter()
        chartDataSet.colors = [UIColor(red: 0, green: 1.0, blue: 0.6, alpha: 1.00)]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = Double(0.25)
        theBarChart.data = chartData
		theBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
		theBarChart.xAxis.granularity = 1
		theBarChart.xAxis.drawLabelsEnabled = true
		theBarChart.xAxis.labelPosition = .bottom
		theBarChart.xAxis.labelFont = .systemFont(ofSize: 14)
        theBarChart.xAxis.drawGridLinesEnabled = false
        theBarChart.xAxis.drawLimitLinesBehindDataEnabled = false
        theBarChart.fitBars = true
        theBarChart.gestureRecognizers = nil
        theBarChart.sizeToFit()
        theBarChart.dragEnabled = false
        theBarChart.drawMarkers = false
        theBarChart.legend.enabled = false
        theBarChart.leftAxis.drawAxisLineEnabled = false
        theBarChart.leftAxis.drawGridLinesEnabled = false
        theBarChart.leftAxis.drawZeroLineEnabled = false
        theBarChart.leftAxis.drawLabelsEnabled = false
        theBarChart.leftAxis.drawTopYLabelEntryEnabled = false
        theBarChart.rightAxis.drawGridLinesEnabled = false
        theBarChart.rightAxis.drawAxisLineEnabled = false
        theBarChart.rightAxis.drawLabelsEnabled = false
        theBarChart.drawValueAboveBarEnabled = true
        theBarChart.data?.setDrawValues(false)
        theBarChart.barData?.setDrawValues(true)
		theBarChart.barData?.setValueFont(.systemFont(ofSize: 14))
        theBarChart.barData?.setValueTextColor(.white)
		theBarChart.xAxis.labelTextColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsViewControllerSegue"{
           if let childVC = segue.destination as? SettingsViewController {
            childVC.homeController = self
            }
        }
    }
}


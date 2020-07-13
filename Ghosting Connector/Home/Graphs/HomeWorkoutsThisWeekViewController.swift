//
//  HomeWorkoutsThisWeekViewController.swift
//  Ghosting Connector
//
//  Created by Varun Chitturi on 7/6/20.
//  Copyright © 2020 Squash Dev. All rights reserved.
//

import UIKit
import Charts
import CoreData
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
class HomeWorkoutsThisWeekViewController: UIViewController {
	@IBOutlet weak var theBarChart: BarChartView!
	var days: [String] = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
	var numWorkouts = [0,0,0,0,0,0,0]
	var parentView : HomeChartPageViewController!
    override func viewDidLoad() {
		numWorkouts = [0,0,0,0,0,0,0]
        super.viewDidLoad()
    }
	override func viewWillAppear(_ animated: Bool) {
		numWorkouts = [0,0,0,0,0,0,0]
		var workoutsFromCore : [Workout] = []
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
			if let wFromCore = try? context.fetch(Workout.fetchRequest()){
				let allwFromCore = wFromCore as! [Workout]
				workoutsFromCore = allwFromCore
			}
		}
		print(Date.today().startOfDay.previous(.monday, considerToday: true))
		for workout in workoutsFromCore{
			let currentDate = workout.date
			if (Date.today().startOfDay.previous(.monday, considerToday: true) <= currentDate!.startOfDay) {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "EEEE"
				let dayOfTheWeekString = dateFormatter.string(from: workout.date!)
				if dayOfTheWeekString == "Sunday"{
					numWorkouts[6] += 1
				}
				if dayOfTheWeekString == "Monday"{
					numWorkouts[0] += 1
				}
				if dayOfTheWeekString == "Tuesday"{
					numWorkouts[2] += 1
				}
				if dayOfTheWeekString == "Wednesday"{
					numWorkouts[2] += 1
				}
				if dayOfTheWeekString == "Thursday"{
					numWorkouts[3] += 1
				}
				if dayOfTheWeekString == "Friday"{
					numWorkouts[4] += 1
				}
				if dayOfTheWeekString == "Saturday"{
					numWorkouts[5] += 1
				}
			}
		}
		customizeChart(dataPoints: days, values: numWorkouts)
		theBarChart.noDataText = "No workouts this week"
		theBarChart.noDataTextColor = .white
		theBarChart.noDataFont = .systemFont(ofSize: 15)
	}
	func customizeChart(dataPoints: [String], values: [Int]) {
		theBarChart.animate(xAxisDuration: 1, yAxisDuration: 2, easingOption: ChartEasingOption.easeOutExpo)
		var dataEntries: [BarChartDataEntry] = []
		var valuesPresent = false
		for i in 0..<dataPoints.count {
			let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
			dataEntries.append(dataEntry)
			if values[i] != 0{
				valuesPresent = true
			}
		}
		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Workouts")
		chartDataSet.valueFormatter = DigitValueFormatter()
		chartDataSet.colors = [UIColor(red: 0, green: 1.0, blue: 0.6, alpha: 1.00)]
		let chartData = BarChartData(dataSet: chartDataSet)
		chartData.barWidth = Double(0.25)
		if valuesPresent{
			theBarChart.data = chartData
		}
		else{
			theBarChart.data = nil
		}
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
		theBarChart.barData?.setValueFont(.systemFont(ofSize: 13))
		theBarChart.barData?.setValueTextColor(.white)
		theBarChart.xAxis.labelTextColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
	}
}
extension Date {
	
	static func today() -> Date {
		return Date()
	}
	
	func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
		return get(.next,
				   weekday,
				   considerToday: considerToday)
	}
	
	func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
		return get(.previous,
				   weekday,
				   considerToday: considerToday)
	}
	
	func get(_ direction: SearchDirection,
			 _ weekDay: Weekday,
			 considerToday consider: Bool = false) -> Date {
		
		let dayName = weekDay.rawValue
		
		let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
		
		assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
		
		let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
		
		let calendar = Calendar(identifier: .gregorian)
		
		if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
			return self
		}
		
		var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
		nextDateComponent.weekday = searchWeekdayIndex
		
		let date = calendar.nextDate(after: self,
									 matching: nextDateComponent,
									 matchingPolicy: .nextTime,
									 direction: direction.calendarSearchDirection)
		
		return date!
	}
	
}
extension Date {
	func getWeekDaysInEnglish() -> [String] {
		var calendar = Calendar(identifier: .gregorian)
		calendar.locale =  .current
		return calendar.weekdaySymbols
	}
	
	enum Weekday: String {
		case monday, tuesday, wednesday, thursday, friday, saturday, sunday
	}
	
	enum SearchDirection {
		case next
		case previous
		
		var calendarSearchDirection: Calendar.SearchDirection {
			switch self {
			case .next:
				return .forward
			case .previous:
				return .backward
			}
		}
	}
}
extension Date {
	var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}
	
	var endOfDay: Date {
		var components = DateComponents()
		components.day = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfDay)!
	}
	
	var startOfMonth: Date {
		let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
		return Calendar.current.date(from: components)!
	}
	
	var endOfMonth: Date {
		var components = DateComponents()
		components.month = 1
		components.second = -1
		return Calendar.current.date(byAdding: components, to: startOfMonth)!
	}
}

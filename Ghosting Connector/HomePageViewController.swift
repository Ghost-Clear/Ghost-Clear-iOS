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
class HomePageViewController: UIViewController {
    var namesFromCore = [Name]()
    var name = ""
    var days: [String] = ["Mon","Tues","Wed","Thur","Fri","Sat","Sun"]
    @IBOutlet weak var welcomeLabel: UILabel!
   
    
    //TODO: put real infromation here
    var numWorkouts = [5.0,1.0,1.0,1.0,1.0,1.0,10.0]
   
        @IBAction func goToSettings(_ sender: Any) {
            
    }
    @IBOutlet weak var theBarChart: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let nameFromCore = try? context.fetch(Name.fetchRequest()){
                let allNamesFromCore = nameFromCore as! [Name]
                namesFromCore = allNamesFromCore
                if namesFromCore.count != 0{
                    welcomeLabel.text = "Welcome " + namesFromCore[0].name! + "!"
                }
            }
            
        }
        customizeChart(dataPoints: days, values: numWorkouts)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            if let nameFromCore = try? context.fetch(Name.fetchRequest()){
                let allNamesFromCore = nameFromCore as! [Name]
                namesFromCore = allNamesFromCore
                if namesFromCore.count != 0{
                    welcomeLabel.text = "Welcome " + namesFromCore[0].name! + "!"
                }
            }
            
        }
    }
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        theBarChart.animate(xAxisDuration: 1, yAxisDuration: 2, easingOption: ChartEasingOption.easeOutExpo)
      // TO-DO: customize the chart here
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
          dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        chartDataSet.colors = [UIColor(red: 0, green: 1.0, blue: 0.6, alpha: 1.00)]
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.barWidth = Double(0.25)
        chartData.groupBars(fromX: 0, groupSpace: 0.5, barSpace: 0.50)
        theBarChart.data = chartData
        theBarChart.xAxis.drawLabelsEnabled = false
        theBarChart.xAxis.drawAxisLineEnabled = false
        theBarChart.xAxis.drawGridLinesEnabled = false
        theBarChart.xAxis.drawLimitLinesBehindDataEnabled = false
        theBarChart.drawValueAboveBarEnabled = false
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
        theBarChart.leftAxis.drawBottomYLabelEntryEnabled = false
        theBarChart.leftAxis.drawLimitLinesBehindDataEnabled = false
        theBarChart.leftAxis.gridColor = .clear
        theBarChart.rightAxis.drawGridLinesEnabled = false
        theBarChart.rightAxis.gridColor = .clear
        theBarChart.xAxis.gridColor = .clear
        theBarChart.rightAxis.drawAxisLineEnabled = false
        theBarChart.rightAxis.drawLabelsEnabled = false
        theBarChart.drawValueAboveBarEnabled = false
        theBarChart.data?.setDrawValues(false)
        theBarChart.tintColor = .clear
        theBarChart.barData?.setDrawValues(false)
        theBarChart.barData?.setValueTextColor(.clear)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToSettings"{
           if let childVC = segue.destination as? SettingsViewController {
              //Some property on ChildVC that needs to be set
            childVC.homeController = self
            }
        }
    }
    

}


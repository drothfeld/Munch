//
//  HomeViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/8/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Charts

class HomeViewController: UIViewController {
    // Controller Elements
    var truncatedUserEmail: String!
    var foodItems: [FoodItem] = []
    let percentageThreshold: Double = 1.00
    
    // UI Elements
    @IBOutlet weak var FoodPieChart: PieChartView!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        // Setting background color
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        
        // Getting info of the currently logged in user
        let user = Auth.auth().currentUser
        if let user = user {
            truncatedUserEmail = stripDotCom(username: user.email!)
            
            // Getting user-food-stock JSON object
            let userFoodStockRef = Database.database().reference(withPath: "user-food-stock/" + truncatedUserEmail)
            userFoodStockRef.observe(.value, with: { snapshot in
                // Parsing JSON data
                for item in snapshot.children {
                    let foodItem = FoodItem(snapshot: item as! DataSnapshot)
                    self.foodItems.append(foodItem)
                }
                // Setting up pieChart
                let foodCategories = ["Meat", "Seafood", "Dairy", "Fruit", "Vegetable", "Starch", "Grain", "Spice", "Fat"]
                var foodCategoriesCount = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                // Getting count of each food type
                for i in 0..<self.foodItems.count {
                    switch (self.foodItems[i].type) {
                        case ("Meat"): foodCategoriesCount[0] += 1.0
                        case ("Seafood"): foodCategoriesCount[1] += 1.0
                        case ("Dairy"): foodCategoriesCount[2] += 1.0
                        case ("Fruit"): foodCategoriesCount[3] += 1.0
                        case ("Vegetable"): foodCategoriesCount[4] += 1.0
                        case ("Starch"): foodCategoriesCount[5] += 1.0
                        case ("Grain"): foodCategoriesCount[6] += 1.0
                        case ("Spice"): foodCategoriesCount[7] += 1.0
                        case ("Fat"): foodCategoriesCount[8] += 1.0
                        default: print(self.foodItems[i])
                    }
                }
                // Creating pieChart
                self.setChart(dataPoints: foodCategories, values: foodCategoriesCount)
            })
        }
    }
    
    // Setting pie chart values
    func setChart(dataPoints: [String], values: [Double]) {
        
        // Getting percentages of food available for each category
        var totalFoodCount: Double = 0.00
        var foodCountPercentages: [Double] = []
        for i in 0..<dataPoints.count { totalFoodCount = totalFoodCount + values[i] }
        for i in 0..<dataPoints.count { foodCountPercentages.append( (100 * (values[i] / totalFoodCount)).rounded() ) }

        // Creating pie chart dataset
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            // Only graphing food categories with at least 2% of the total storage
            if (foodCountPercentages[i] > percentageThreshold) {
                let dataEntry = ChartDataEntry(x: Double(i), y: foodCountPercentages[i])
                dataEntries.append(dataEntry)
            }
        }
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Food Categories")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        FoodPieChart.data = pieChartData
        
        // Setting text values
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 100
        formatter.multiplier = 1.0
        FoodPieChart.data?.setValueFont(UIFont(name: "Lato-Regular", size: 20.0)!)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        // Setting pie chart colors
        FoodPieChart.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        var colors: [UIColor] = []
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
        
        // Changing key attributes and animation
        FoodPieChart.drawEntryLabelsEnabled = false
        FoodPieChart.chartDescription?.enabled = false
        FoodPieChart.holeColor = UIColor.clear
        FoodPieChart.legend.enabled = false
        FoodPieChart.isUserInteractionEnabled = true
        FoodPieChart.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: ChartEasingOption.easeInOutQuart)

    }
    
    // Strip the ".com" from a string
    func stripDotCom(username: String) -> String {
        var truncated = username
        for _ in 1...4 {
           truncated.remove(at: truncated.index(before: truncated.endIndex))
        }
        return truncated
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}


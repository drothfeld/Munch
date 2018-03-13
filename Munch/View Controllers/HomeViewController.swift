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
    var currentUser: UserProfile!
    var hasFood: Bool = true
    
    // UI Elements
    @IBOutlet weak var FoodPieChart: PieChartView!
    @IBOutlet weak var KitchenButton: UIButton!
    @IBOutlet weak var PantryButton: UIButton!
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var KitchenButtonLabel: UILabel!
    @IBOutlet weak var PantryButtonLabel: UILabel!
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var NoFoodLabel: UILabel!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playButtonAnimations()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        // Setting UI element properties
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        
        // Getting info of the currently logged in user
        let user = Auth.auth().currentUser
        if let user = user {
            truncatedUserEmail = stripDotCom(username: user.email!)
            
            // Getting user-profile JSON object
            let userProfileRef = Database.database().reference(withPath: "user-profile/" + truncatedUserEmail)
            userProfileRef.observe(.value, with: { snapshot in
                // Parsing JSON data
                for item in snapshot.children {
                    let userProfile = UserProfile(snapshot: item as! DataSnapshot)
                    self.currentUser = userProfile
                }
                self.WelcomeLabel.text = (self.currentUser.firstname + " " + self.currentUser.lastname)
                
            })
            
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
                let totalFoodCount = self.foodItems.count
                if (totalFoodCount == 0) { self.hasFood = false}
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
                self.setChart(dataPoints: foodCategories, values: foodCategoriesCount, total: totalFoodCount)
            })
        }
    }
    
    // Animation for buttons on load
    func playButtonAnimations() {
        UIView.animate(withDuration: 1.75, animations: { () -> Void in
            self.KitchenButton.center = CGPoint(x: 78.5, y: 142.0)
            self.PantryButton.center = CGPoint(x: 284.0, y: 146.0)
            self.LogOutButton.center = CGPoint(x: 187.0, y: 261.0)
            self.KitchenButtonLabel.center = CGPoint(x: 78.0, y: 210.5)
            self.PantryButtonLabel.center = CGPoint(x: 284.0, y: 210.5)
            self.WelcomeLabel.alpha = 1.0
            // TODO: Fix bug where the FIRST account with no
            // food you log in to doesn't display NoFoodLabel.
            if (!self.hasFood) {
                self.NoFoodLabel.isHidden = false
                self.NoFoodLabel.alpha = 1.0
                self.NoFoodLabel.startBlink()
            }
        })
    }
    
    // Setting pie chart values
    func setChart(dataPoints: [String], values: [Double], total: Int) {
        
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
                let dataEntry = PieChartDataEntry()
                dataEntry.y = foodCountPercentages[i]
                dataEntry.label = dataPoints[i]
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
        //FoodPieChart.centerText = "Food Stock"
        FoodPieChart.data?.setValueFont(UIFont(name: "Lato-Regular", size: 20.0)!)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        
        // Setting pie chart colors
        FoodPieChart.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        var colors: [UIColor] = []
        var color: UIColor
        for i in 0..<total {
            if (foodCountPercentages[i] > percentageThreshold) {
                switch (i) {
                    // Meat
                    case (0): color = UIColor(red: 0.5882, green: 0, blue: 0.0078, alpha: 1.0)
                    // Seafood
                    case (1): color = UIColor(red: 0, green: 0.3176, blue: 0.8667, alpha: 1.0)
                    // Dairy
                    case (2): color = UIColor(red: 0.6588, green: 0.6157, blue: 0, alpha: 1.0)
                    // Fruit
                    case (3): color = UIColor(red: 0.6588, green: 0.4667, blue: 0.8078, alpha: 1.0)
                    // Vegetable
                    case (4): color = UIColor(red: 0, green: 0.6667, blue: 0.3216, alpha: 1.0)
                    // Starch
                    case (5): color = UIColor(red: 0.8275, green: 0.5255, blue: 0, alpha: 1.0)
                    // Grain
                    case (6): color = UIColor(red: 0.5686, green: 0.3765, blue: 0.1451, alpha: 1.0)
                    // Spice
                    case (7): color = UIColor(red: 0.9098, green: 0.4, blue: 0.1059, alpha: 1.0)
                    // Fat
                    case (8): color = UIColor(red: 0.2431, green: 0.8196, blue: 0.7882, alpha: 1.0)
                    // None of the above (shouldn't ever happen)
                    default: color = UIColor.black
                }
                // Set colors
                colors.append(color)
            }
        }
        pieChartDataSet.colors = colors
        
        // Changing key attributes and animation
        FoodPieChart.drawEntryLabelsEnabled = true
        FoodPieChart.chartDescription?.enabled = false
        FoodPieChart.holeColor = UIColor.clear
        FoodPieChart.legend.enabled = false
        FoodPieChart.isUserInteractionEnabled = true
        FoodPieChart.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: ChartEasingOption.easeInOutQuart)
    }
    
    // Log user out
    @IBAction func logOutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "logOut", sender: self)
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

// UILabel extension to enable blinking animation
extension UILabel {
    // Start blinking
    func startBlink() {
        UIView.animate(withDuration: 1.0,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0.10 },
                       completion: nil)
    }
}


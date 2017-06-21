//
//  WearherDetailsViewController.swift
//  WeatherApp
//
//  Created by Sierra on 06/06/2017.
//  Copyright © 2017 Sierra. All rights reserved.
//

import UIKit

class WeatherDetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        print(id)
        WeatherRequestManager.shared.makeWeatherRequest(by: self.id!, completion: {[weak self]
            (weather) in
            DispatchQueue.main.async {
                print ("should be worked")
                self?.temperatureLabel.text = "\(String(weather.temperature))℃"
                self?.summaryLabel.text = "\(weather.description)"
                self?.dateLabel.text = "Ветер \((weather.windDirection == nil) ? "" : "\(weather.windDirection!)") \(weather.windSpeed) м/c"
                self?.tableView.reloadData()
            }
        })
    }
}

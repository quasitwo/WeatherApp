//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Sierra on 06/06/2017.
//  Copyright © 2017 Sierra. All rights reserved.
//

import UIKit

class AddCityTableViewController: UITableViewController {
    
    let cellIdentifier = "AddCityTableViewCell"
    var cityList: [CityData] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AddCityTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let city = cityList[indexPath.row]
        cell.textLabel?.text = "\(city.name) (\(city.country))"
        cell.detailTextLabel?.text = "Широта \(city.latitude), Долгота \(city.longitude)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userCities: [City]? = []
        if let decoded = UserDefaults.standard.object(forKey: "userCities") {
            if let decodedCities = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! [City]? {
                userCities = decodedCities
            }
        }
        let selectedCity = cityList[indexPath.row]
        let newCity = City(name: selectedCity.name, id: selectedCity.id)
        userCities!.append(newCity)
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userCities as Any)
        UserDefaults.standard.set(encodedData, forKey: "userCities")
        navigationController?.popViewController(animated: true)
    }
    
}

extension AddCityTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        WeatherRequestManager.shared.findCity(by: searchBar.text!, completion: {
            (cities) in
            guard cities?.count != 0 else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Поиск города", message:
                        "Город не найден", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default,handler: nil))
                
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }

            DispatchQueue.main.async {
                self.cityList = cities!
                self.tableView.reloadData()
            }
        })
    }
}

//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sierra on 06/06/2017.
//  Copyright © 2017 Sierra. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    let cellIdentifier = "WeatherTableViewCell"
    let baseCities = [City(name: "Новосибирск",     id: 1496747),
                      City(name: "Санкт-Петербург", id: 519690),
                      City(name: "Екатеринбург",    id: 1494346),
                      City(name: "Москва",          id: 524901),
                      City(name: "Омск",            id: 1496153),
                      City(name: "Челябинск",       id: 1508291),
                      City(name: "Нижний Новгород", id: 470012),
                      City(name: "Самара",          id: 499099),
                      City(name: "Ростов-на-Дону",  id: 501175)
    ]
    
    var allCities: [City] = []
    var sortedCities: [City] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allCities = baseCities
        loadUserCities()
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        configureView()
    }
    
    func loadUserCities() {
        let decoded  = UserDefaults.standard.object(forKey: "userCities") as! Data?
        guard decoded != nil else { return }
        let decodedCities = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [City]?
        allCities = []
        baseCities.forEach({
            allCities.append($0)
        })
        decodedCities?.forEach({
            allCities.append($0)
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.loadUserCities()
            self.sortedCities = self.allCities.sorted(by: {$0.name < $1.name})
            self.tableView.reloadData()
        }
        
    }
    
    func configureView() {
        self.title = "Список городов"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
        tableView.tableFooterView = UIView()
    }
    
    func addCity() {
        self.performSegue(withIdentifier: "addCity", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedCities.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = sortedCities[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "weatherDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier! {
        case "weatherDetails":
            let vc = segue.destination as! WeatherDetailsTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            vc.title = self.sortedCities[(indexPath?.row)!].name
            vc.id = self.sortedCities[(indexPath?.row)!].id
        case "addCity":
            let vc = segue.destination as! AddCityTableViewController
            vc.title = "Добавление города"
        default:
            break
        }
    }
    
}


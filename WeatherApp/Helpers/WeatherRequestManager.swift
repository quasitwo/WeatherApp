//
//  WeatherRequestManager.swift
//  WeatherApp
//
//  Created by Sierra on 06/06/2017.
//  Copyright © 2017 Sierra. All rights reserved.
//

import Foundation

class WeatherRequestManager {
    
    static var shared = WeatherRequestManager()
        
    func findCity(by cityName: String, completion: (([CityData]?) -> ())?) {
        var result: [CityData]? = []
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
        let url = URL(string: "http://api.openweathermap.org/data/2.5/find?q=\(encodedCityName)&lang=ru&units=metric&appid=d96a7f9cb0267643080df80051f81c08")
        print(url)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let urlContent = data {
                do {
                    result = []
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if jsonResult["cod"] as! String == "200" {
                        let list = jsonResult["list"] as! [Any]
                        list.forEach({
                            result?.append(CityData(by: $0 as! NSDictionary, name: cityName))
                        })
                    }

                } catch {
                    print("JSON Processing Failed")
                }
            }

            guard completion != nil else { return }
            completion!(result)
        }
        
        task.resume()
    }
    
    func makeWeatherRequest(by id: Int, completion: ((WeatherData) -> ())?) {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(id)&lang=ru&units=metric&appid=d96a7f9cb0267643080df80051f81c08")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in

            if let urlContent = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if jsonResult["cod"] as! Int == 200 {
                        let weather = WeatherData(by: jsonResult)
                        guard completion != nil else { return }
                        completion!(weather)
                    }
                } catch {
                    print("JSON Processing Failed")
                }
            }
        }
        
        task.resume()
    }
}

class WeatherData {
    
    private let directionDescription = ["северный",
                                "северо-восточный",
                                "восточный",
                                "юго-восточный",
                                "южный",
                                "югозападный",
                                "западный",
                                "севаро-западный"]
    
    var temperature: Double
    var description: String
    var windDirection: String?
    var windSpeed: Double
    
    
    init(by result: NSDictionary) {
        print(result)
        let main = result["main"] as! [String: Any]
        self.temperature = main["temp"] as! Double
        
        let weatherList = result["weather"] as! [Any]
        let weather = weatherList[0] as! [String: Any]
        self.description = weather["description"] as! String
        
        let wind = result["wind"] as! [String: Any]
        self.windSpeed = wind["speed"] as! Double
        
        if let degree = wind["deg"] as! Double? {
            let directionIndex = Int(round(degree / (360 / 8))) % 8
            windDirection = directionDescription[directionIndex]
        }
    }
    
    init() {
        self.description = ""
        self.temperature = 0
        self.windDirection = ""
        self.windSpeed = 0
    }
}

class CityData {
    var latitude: Double   //широта
    var longitude: Double   //долгота
    var country: String
    var name: String        //то имя которое использовали в запросе
    var id: Int             //id города
    
    //result is list[i]
    init(by result: NSDictionary, name: String) {
        let coord = result["coord"] as! [String: Any]
        self.latitude = coord["lat"] as! Double
        self.longitude = coord["lon"] as! Double
        
        self.id = result["id"] as! Int
        print("City(name: \"\(name)\", id: \(id)),")
        
        let sys = result["sys"] as! [String: Any]
        self.country = sys["country"] as! String
        self.name = name
    }
}

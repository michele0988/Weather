//
//  WeatherManager.swift
//  Weather
//
//  Created by Mihai Gorgan on 10.08.2022.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager{
            
    func fetchWeather(_ cityName: String){
        let urlSting = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=87bb39e6defcbb6fe766fe6ad0f231fc&units=metric"
        performRequest(urlString: urlSting)
    }
    
    func fechWeather(_ lat: Double, _ lon: Double){
        let urlSting = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=87bb39e6defcbb6fe766fe6ad0f231fc&units=metric"
        performRequest(urlString: urlSting)
        
    }
    
    var delegate: WeatherManagerDelegate?
    
    func performRequest(urlString: String){
        //1. Create a URL
        print("--------- Perform Request Start -------------")
        //Verific daca instanta a fost creata corespunzator
        if let url = URL(string: urlString){
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url, completionHandler:
            {(data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print("--------ERROR---------")
                    print(error!)
                    return // iesire din functie datorita faptului ca a fost o eroare
                }
                
                if let safeData = data{
                    
                    if let weather = parseJson(weatherData: safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                   
                    
                }})
            
            //4. Start the task
            task.resume()
           print("====== End Request =====")
        }else{
            print("---- URL Instance Error")
        }
    }
    
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let dcData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let cityName = dcData.name
            let temp = dcData.main.temp
            let idWeatherIcon = dcData.weather[0].id
                        
            let weather = WeatherModel(condition: idWeatherIcon, cityName: cityName, temperature: temp)
            
            return weather
            
                        
        }catch{
            print(error)
            return nil
        }
        
        
    }
    
    
    
    
}
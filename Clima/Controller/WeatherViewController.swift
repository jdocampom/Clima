//
//  ViewController.swift
//  Clima
//
//  Created by Juan Diego Ocampo on 07/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
// MARK: IB-Outlets
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
// MARK: Variables
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
// MARK: Methods
    
    /// Tag: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Location Manager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        /// Weather Manager
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
}

// MARK: UITextFieldDelegate -- WeatherViewController Extension

extension WeatherViewController: UITextFieldDelegate {
    
// MARK: IB-Actions
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
// MARK: Methods
    
    /// Tag: textFieldShouldReturn()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    /// Tag: textFieldShouldEndEditing()
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    /// Tag: textFieldDidEndEditing()
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

// MARK: WeatherManagerDelegate -- WeatherViewController Extension

extension WeatherViewController: WeatherManagerDelegate {
    
// MARK: Methods
    
    /// Tag: didUpdateWeather()
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    /// Tag: didFailWithError()
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: CLLocationManagerDelegate -- WeatherViewController Extension

extension WeatherViewController: CLLocationManagerDelegate {
    
// MARK: IB-Actions
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
// MARK: Methods
    
    /// Tag: locationManager() -- didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    /// Tag: locationManager() -- didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

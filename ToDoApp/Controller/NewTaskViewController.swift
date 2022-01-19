//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Mac on 18.01.2022.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var locationTextField: UITextField!
    
    @IBOutlet var adressTextField: UITextField!
    
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var dateTextField: UITextField!
    
    
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var cancelButton: UIButton!
    
    var taskManager: TaskManager!
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    var geocoder = CLGeocoder()
    
    @IBAction func save() {
        let titleString = titleTextField.text
        let locationString = locationTextField.text
        let date = dateFormatter.date(from: dateTextField.text!)
        let descriptionString = descriptionTextField.text
        let adressString = adressTextField.text
        geocoder.geocodeAddressString(adressString!) { [unowned self] placemarks, error in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(name: locationString!, coordinate: coordinate)
            let task = Task(title: titleString!, description: descriptionString, date: date, location: location)
            
            self.taskManager.add(task: task)
            print(task)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        
    }
    
}

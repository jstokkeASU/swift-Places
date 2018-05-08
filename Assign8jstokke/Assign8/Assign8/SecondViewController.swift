//
//  SecondViewController.swift
//  Assign8
//
// Copyright 2018 James Stokke
// Licensed under the Apache License, Version 2.0 (the "License");
// You may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// @author James Stokke mailto:James.Stokke@asu.edu
// @version April 201 2018
//
// This is the Main View Controller.  Shows all details of a place
// and allows user to update or delete a place.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptField: UITextView!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var addressTitleField: UITextField!
    @IBOutlet weak var addressStreetField: UITextView!
    @IBOutlet weak var elevationField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    
    
    public var placeName:String = ""
    
    // On Delete Button get nameField string and call deletePlace function
    @IBAction func removePlace(_ sender: Any) {
        var nameStr = ""
        if (nameField.text?.isEmpty)!{
            return
        }
        nameStr = nameField.text!
        let db = PlaceDB()
        let answer:Bool = db.deletePlace(name: nameStr)
        print(answer)
        performSegue(withIdentifier: "home", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up textfields
        self.nameField.delegate = self
        self.descriptField.delegate = self
        self.categoryField.delegate = self
        self.addressTitleField.delegate = self
        self.addressTitleField.delegate = self
        self.addressStreetField.delegate = self
        self.elevationField.delegate = self
        self.latitudeField.delegate = self
        self.longitudeField.delegate = self
        self.elevationField.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.latitudeField.keyboardType = UIKeyboardType.numbersAndPunctuation
        self.longitudeField.keyboardType = UIKeyboardType.numbersAndPunctuation
        //print("SEGUE PASSED: \(placeName)")
        
        // Setup to close keyboard on click off of field
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        // If segue not from "Add" button fill in Textfield data
        if (placeName != ""){
            self.populateFields(placeName)
        }
    }
    
    // Closes keyboard upon tapping outside view
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Closes Keyboard upon Return Key in TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder	()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // saves data from text fields then deletes place and adds it again
    @IBAction func saveUpdate(_ sender: Any) {
        var name = "unknown"
        if (nameField.text != ""){
            name = nameField.text!
        }
        let description = descriptField?.text
        let category = categoryField?.text
        let addressTitle = addressTitleField?.text
        let addressStreet = addressStreetField?.text
        // Setup to convert strings to double
        var elevation = Double(0)
        var latitude = Double(0)
        var longitude = Double(0)
        // Since need access to "-" char, can't use decimal keyboard.
        // regex includes all chars not 0-9, "." and "-" (used to exclude those chars)
        let excludeString = "[^\\--9]|\\/"
        if let elString: String = elevationField.text{
            var elMod = elString
            elMod.removingRegexMatches(pattern: excludeString)
            elevation = Double(elMod)!
            //print("Loop elevation: \(elevation)")
        }
        if let latString: String = latitudeField.text{
            var latMod = latString
            latMod.removingRegexMatches(pattern: excludeString)
            latitude = Double(latMod)!
            //print("Loop elevation: \(elevation)")
        }
        if let lonString: String = longitudeField.text{
            var lonMod = lonString
            lonMod.removingRegexMatches(pattern: excludeString)
            longitude = Double(lonMod)!
            //print("Loop elevation: \(elevation)")
        }
        
        let db = PlaceDB()
        
        let ansOne:Bool = db.deletePlace(name: name)
        let ansTwo:Bool = db.saveContext()
        let ansFour:Bool = db.addPlace(name, descript:(description)!, category:(category)!, address_title:(addressTitle)!, address_street:(addressStreet)!, elevation:elevation, latitude:latitude, longitude:longitude)
        let ansThree:Bool = db.saveContext()
        print("\(ansOne), \(ansTwo), \(ansThree), \(ansFour)")
    }
    
    // Query gets all fields for name and adds them to text Fields
    func populateFields(_ name:String){
        let db = PlaceDB()
        let currPlace = db.getPlace(name)
        nameField.text = currPlace.name
        descriptField.text = currPlace.descript
        categoryField.text = currPlace.category
        addressTitleField.text = currPlace.address_title
        addressStreetField.text = currPlace.address_street
        elevationField.text = String(format:"%f", currPlace.elevation)
        latitudeField.text = String(format:"%f", currPlace.latitude)
        longitudeField.text = String(format:"%f", currPlace.longitude)
    }
    
    

}

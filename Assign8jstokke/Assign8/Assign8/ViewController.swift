//
//  ViewController.swift
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
// @version April 20, 2018
//
// This is the Main View Controller.  It has a picker that allows the user to
// see place details.  It also has two other pickers to allow the user to
// calculate distance and heading.
//

import UIKit
import Foundation
import CoreData

	class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,
    UITableViewDelegate, UINavigationControllerDelegate {
        
        
        @IBOutlet weak var addButtdon: UIBarButtonItem!
        @IBOutlet weak var detailPicker: UIPickerView!
        @IBOutlet weak var navBar: UINavigationBar!
        @IBOutlet weak var secondPicker: UIPickerView!
        @IBOutlet weak var distanceField: UILabel!
        @IBOutlet weak var headingField: UILabel!
        
        var places:[String] = [String]()
        var second:[String] = [String]()
        public var selectPlace:String = "unknown"
        public var nameString = String()
        public var secondPlace = String()
        public var count = Int()
        public var countTwo = Int()
        
        // Get Details button opens second view controller
        @IBAction func getDetails(_ sender: Any) {
            performSegue(withIdentifier: "segue", sender: self)
        }
        
        // Get Distance between Places and initial heading
        @IBAction func getDistance(_ sender: Any) {
            var distance:Double = Double()
            if (count < 0 && nameString == ""){
                nameString = places[0]
            }
            if (countTwo <= 0 && secondPlace == ""){
                secondPlace = second[0]
            }
            let db = PlaceDB()
            let coordinates:[Double] = db.getCoords(name:nameString, name2:secondPlace)
            let latOne:Double = toRadians(coordinates[0])
            let lonOne:Double = toRadians(coordinates[1])
            let latTwo:Double = toRadians(coordinates[2])
            let lonTwo:Double = toRadians(coordinates[3])
            let latDif:Double = Double(latTwo - latOne)
            let lonDif:Double = Double(lonTwo - lonOne)
            // get distance
            let radius:Double = Double(6371)
            let a:Double = ((sin(latDif/2))*(sin(latDif/2))+cos(latOne)*cos(latTwo)*(sin(lonDif/2))*(sin(lonDif/2)))
            let c:Double = 2*Double(atan2(sqrt(a),sqrt(1-a)))
            distance = radius*c
            
            //Get Header
            var angle:Double = Double()
            let y:Double = sin(lonTwo-lonOne) * cos(latTwo)
            let x:Double = cos(latOne) * sin(latTwo) - sin(latOne) * cos(latTwo) * cos(lonTwo-lonOne)
            angle = atan2(y,x)
            let heading:String = toDegrees(angle)
            print("Coordinate2: (\(latTwo),\(lonTwo)): ArrayValues:(\(coordinates[2]),\(coordinates[3]))")
            print("Coordinate1: (\(latOne),\(lonOne)): ArrayValues:(\(coordinates[0]),\(coordinates[1]))")
            
            distanceField.text = String(format:"%f", distance)
            headingField.text = heading
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // initialize Count of spinner changes and set string for segue to blank
            count = -1
            count = -1
            nameString = ""
            secondPlace = ""
            headingField.text = ""
            distanceField.text = ""
            
            
            // Set up first picker
            self.detailPicker.delegate = self
            self.detailPicker.dataSource = self
            
            
            // Set up secon picker
            self.secondPicker.delegate = self
            self.detailPicker.dataSource = self
            self.updatePlacesPicker()
            
            // If places array is empty then db is empty, so call function to add places to db
            if (places.count < 1){
                print("Initializing...")
                self.initialize()
            }
            
            
            
            
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        // Adds places to database and updates picker with names
        func initialize(){
            let locDB:PlaceDB = PlaceDB()
            _ = locDB.addPlace("ASU-West",descript:"Home of ASU's Applied Computing Program",category:"School",address_title:"ASU West Campus", address_street:"13591 N 47th Ave\nPhoenix AZ 85051", elevation:1100.0, latitude:33.608979,longitude:-112.159469)
            _ = locDB.addPlace("UAK-Anchorage",descript:"University of Alaska's largest campus",category:"School",address_title:"University of Alaska at Anchorage",address_street:"290 Spirit Dr\nAnchorage AK 99508",elevation:0.0,latitude:61.189748,longitude:-149.826721)
            _ = locDB.addPlace("Toreros",descript:"The University of San Diego, a private Catholic undergraduate university.",category:"School",address_title:"University of San Diego",address_street:"5998 Alcala Parkway\nSan Diego CA 92110",elevation:0.0,latitude:32.771923,longitude:-117.188204)
            _ = locDB.addPlace("Barrow-Alaska",descript:"The only real way in and out of Barrow Alaska.",category:"Travel",address_title:"Will Rogers Airport",address_street:"1725 Ahkovak St\nBarrow AK 99723",elevation:5.0,latitude:71.287881,longitude:-156.779417)
            _ = locDB.addPlace("Calgary-Alberta",descript:"The home of the Calgary Stampede Celebration",category:"Travel",address_title:"Calgary International Airport",address_street:"2000 Airport Rd NE\nCalgary AB T2E 6Z8 Canada",elevation:3556.0,latitude:51.131377,longitude:-114.011246)
            _ = locDB.addPlace("London-England",descript:"Renaissance Hotel at the Heathrow Airport",category:"Travel",address_title:"Renaissance London Heathrow Airport",address_street:"5 Mondial Way\nHarlington Hayes UB3 UK",elevation:82.0,latitude:51.481959,longitude:-0.445286)
            _ = locDB.addPlace("Moscow-Russia",descript:"The Marriott Courtyard in downtown Moscow",category:"Travel",address_title:"Courtyard Moscow City Center",address_street:"Voznesenskiy per 7\nMoskva Russia 125009",elevation:512.0,latitude:55.758666,longitude:37.604058)
            _ = locDB.addPlace("New-York-NY",descript:"New York City Hall at West end of Brooklyn Bridge",category:"Travel",address_title:"New York City Hall",address_street:"1 Elk St\nNew York NY 10007",elevation:2.0,latitude:40.712991,longitude:-74.005948)
            _ = locDB.addPlace("Notre-Dame-Paris",descript:"The 13th century cathedral with gargoyles, one of the first flying buttress, and home of the purported crown of thorns.",category:"Travel",address_title:"Cathedral Notre Dame de Paris",address_street:"6 Paris Notre-Dame Pl Jean-Paul-II\n75004 Paris France",elevation:115.0,latitude:48.852972,longitude:2.349910)
            _ = locDB.addPlace("Circlestone",descript:"Indian Ruins located on the second highest peak in the Superstition Wilderness of the Tonto National Forest. Leave Fireline at Turney Spring (33.487610,-111.132400)",category:"Hike",address_title:"",address_street:"",elevation:6000.0,latitude:33.477524,longitude:-111.134345)
            _ = locDB.addPlace("Reavis-Ranch",descript:"Historic Ranch in Superstition Mountains famous for Apple orchards",category:"Hike",address_title:"",address_street:"",elevation:5000.0,latitude:33.491154,longitude:-111.155385)
            _ = locDB.saveContext()
            _ = updatePlacesPicker()
            
            
            
        }
        
        // Updates array used for picker values
        func updatePlacesPicker(){
            places = [String]()
            let locDB:PlaceDB = PlaceDB()
            places = locDB.getPlaceNames().sorted()
            self.detailPicker.reloadAllComponents()
            second = places;
            self.secondPicker.reloadAllComponents()
        }
        
        // More Picker setup
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // Gets number of items in picker
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            var ret:Int = 0
            if pickerView == self.detailPicker {
                ret = places.count
            }
            else {
                ret = second.count
            }
            return ret
        }
        
        // Values of picker
        func pickerView (_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            var ret:String?
            if pickerView == self.detailPicker {
                ret = places[row]
            }
            else {
                ret = second[row]
            }
            return ret
        }
        
        // Selected value and add to count upon picker change
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            if pickerView == self.detailPicker {
                count += 1
                nameString = places[row] as String
            }
            else {
                countTwo += 1
                secondPlace = second[row] as String
            }
        }
        
        // If segue is called by Get Details button, send name (value of picker)
        // Else send blank for name
        override func prepare(for segue:UIStoryboardSegue, sender: Any?){
            let secondController = segue.destination as! SecondViewController
            if (segue.identifier == "segue"){
                // If picker value hasn't changed set value to first item in picker
                if (nameString == "" && count < 0){
                    nameString = places[0]
                }
                secondController.placeName = nameString
            }
            else {
                secondController.placeName = ""
            }
        }
        
        // Takes degrees and returns radians
        func toRadians(_ degrees: Double) -> Double {
            var output:Double = Double()
            output = (degrees * Double.pi)/180
            return output
        }
        
        // Takes radians and returns degrees minutes seconds string
        func toDegrees(_ radians: Double) -> String {
            var heading:(String) = String()
            var degrees:Double = (radians*180)/Double.pi
            if (degrees < 0){
                degrees += 360
            }
            let intNum:(Int) = Int(degrees)
            let dNum:(Double) = Double(intNum)
            let fraction:(Double) = Double(degrees - dNum)
            let dMinutes:(Double) = (fraction*60)
            let minutes:(Int) = Int(dMinutes)
            let dubMinutes:(Double) = Double(minutes)
            let test:(Double) = Double(dubMinutes/60)
            let dSeconds:(Double) = Double(fraction-test)*3600
            let seconds:(Int) = Int(dSeconds)
            let stringMinutes:(String) = String(format:"%02d", minutes)
            let stringSeconds:(String) = String(format:"%02d", seconds)
            heading = String(intNum)+"\u{00B0}"+stringMinutes+"' "+stringSeconds+"\""
            // heading = String.valueOf(fraction);
            return heading;
        }


}



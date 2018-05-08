//
// Copyright 2018 James Stokke
// Licensed under the Apache License, Version 2.0 (the "License");
// "School","Toreros",ou may not use this file except in compliance with the License.
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
// @version April 19, 2018
//
// This is the database file used to perform functions on dbß
//


import UIKit
import Foundation
import CoreData


public class PlaceDB {
    
    var appDel:AppDelegate?
    var mContext:NSManagedObjectContext?
    
    init(){
        appDel = (UIApplication.shared.delegate as! AppDelegate)
        mContext = appDel!.persistentContainer.viewContext
    }
    
    // If name exists return true
    func placeExists(withName:String)->Bool {
        var ret:Bool = false
        let selectRequest:NSFetchRequest<Place> = Place.fetchRequest()
        selectRequest.predicate = NSPredicate(format:"name == %@",withName)
        do{
            let results = try mContext!.fetch(selectRequest)
            if results.count > 0 {
                ret = true
            }
        } catch let error as NSError{
            NSLog("Error selecting place \(withName). Error: \(error)")
        }
        return ret
    }
    
    
    // Returns place names as String Array
    func getPlaceNames() -> [String] {
        var ret:[String] = [String]()
        let fetchLocations:NSFetchRequest<Place> = Place.fetchRequest()
        do{
            let results = try mContext!.fetch(fetchLocations)
            for currentPlace in results {
                ret.append((currentPlace as AnyObject).value(forKey:"name") as! String)
            }
        } catch let error as NSError {
            print("error selecting all places: \(error)")
        }
        //print("Array: \(ret)")
        return ret
    }
    
    // Adds location with given attributes (if not already there)
    func addPlace(_ name:String, descript:String, category:String, address_title:String, address_street:String, elevation:Double, latitude:Double, longitude:Double) -> Bool {
        var ret:Bool = false
        if !placeExists(withName: name) {
            let entity = NSEntityDescription.entity(forEntityName: "Place", in: mContext!)
            let currentPlace = NSManagedObject(entity: entity!, insertInto: mContext)
            currentPlace.setValue(name, forKey:"name")
            currentPlace.setValue(descript, forKey:"descript")
            currentPlace.setValue(category, forKey:"category")
            currentPlace.setValue(address_title, forKey:"address_title")
            currentPlace.setValue(address_street, forKey:"address_street")
            currentPlace.setValue(elevation, forKey:"elevation")
            currentPlace.setValue(latitude, forKey:"latitude")
            currentPlace.setValue(longitude, forKey:"longitude")
            ret = true
        }
        return ret
    }
    
    // Returns place with all of its attributes
    func getPlace(_ name:String) -> (name:String, descript:String, category:String, address_title:String, address_street:String, elevation:Double, latitude:Double, longitude:Double) {
        var currentPlace:(name:String, descript:String, category:String, address_title:String, address_street:String, elevation:Double, latitude:Double, longitude:Double) = ("name","","","","",0,0,0)
        let fetchCurrentPlace:NSFetchRequest<Place> = Place.fetchRequest()
        fetchCurrentPlace.predicate = NSPredicate(format:"name == %@",name)
        do{
            let results = try mContext!.fetch(fetchCurrentPlace)
            if results.count > 0 {
                let descript = (results[0] as AnyObject).value(forKey: "descript") as? String
                let category = (results[0] as AnyObject).value(forKey: "category") as? String
                let address_title = (results[0] as AnyObject).value(forKey: "address_title") as? String
                let address_street = (results[0] as AnyObject).value(forKey: "address_street") as? String
                let elevation = (results[0] as AnyObject).value(forKey: "elevation") as? Double
                let latitude = (results[0] as AnyObject).value(forKey: "latitude") as? Double
                let longitude = (results[0] as AnyObject).value(forKey: "longitude") as? Double
                currentPlace = (name,descript!,category!,address_title!,address_street!,elevation!,latitude!,longitude!)
            }
        }catch let error as NSError{
            print("error getting place \(name), error \(error)")
        }
        return currentPlace
    }
    
    // Delete Place by name returns boolean
    func deletePlace(name:String) -> Bool {
        var ret:Bool = false
        let selectRequest:NSFetchRequest<Place> = Place.fetchRequest()
        selectRequest.predicate = NSPredicate(format:"name == %@",name)
        do{
            let results = try mContext!.fetch(selectRequest)
            if results.count > 0 {
                mContext!.delete(results[0] as NSManagedObject)
                //try mContext?.save()
                ret = true
            }
            let info:Bool = saveContext()
            print("SaveContext \(info)")
        } catch let error as NSError{
            NSLog("error deleting place \(name). Error \(error)")
        }
        return ret
    }
    
    func getCoords(name:String, name2:String) -> Array<Double> {
        var coordinates:[Double] = [Double]()
        let selectRequest:NSFetchRequest<Place> = Place.fetchRequest()
        selectRequest.predicate = NSPredicate(format:"name == %@",name)
        do{
            let results = try mContext!.fetch(selectRequest)
            if results.count > 0 {
                coordinates.append(results[0].latitude)
                coordinates.append(results[0].longitude)
            }
        } catch let error as NSError{
            NSLog("Error selecting place \(name). Error: \(error)")
        }
        let selectRequestTwo:NSFetchRequest<Place> = Place.fetchRequest()
        selectRequestTwo.predicate = NSPredicate(format:"name == %@",name2)
        do{
            let results = try mContext!.fetch(selectRequestTwo)
            if results.count > 0 {
                coordinates.append(results[0].latitude)
                coordinates.append(results[0].longitude)
            }
        } catch let error as NSError{
            NSLog("Error selecting place \(name2). Error: \(error)")
        }
        return coordinates
    }

    // Save Context returns boolean
    func saveContext() -> Bool {
        var ret:Bool = false
        do{
            try mContext!.save()
            ret = true
        }catch let error as NSError{
            print("error saving context \(error)")
        }
        return ret
    }

}

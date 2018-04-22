//
//  MeteoritesCoreDataStore.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/21/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import Foundation
import CoreData

public class MeteoritesCoreDataStore {
    
    class func importNASAMeteoritesCSV(csvFileName: String) {
        
        var contents: String?
        guard let filepath = Bundle.main.path(forResource: csvFileName, ofType: "csv") else { return }
        do {
            contents = try String(contentsOfFile: filepath, encoding: .utf8)
        } catch {
            print("File Read Error for file \(filepath)")
        }
        guard let csvContentsString = contents else { return }
        
        var result: [[String]] = []
        let rows = csvContentsString.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ",")
            result.append(columns)
        }
        
        result.forEach { (meteoriteRowStrings) in
            
            if result.index(of: meteoriteRowStrings) == 0 { return }
            
            let name = meteoriteRowStrings.count > 0 ? meteoriteRowStrings[0] : nil
            let nasaID = meteoriteRowStrings.count > 1 ? Int32(meteoriteRowStrings[1]) : nil
            let nameType = meteoriteRowStrings.count > 2 ? meteoriteRowStrings[2] : nil
            let recClass = meteoriteRowStrings.count > 3 ? meteoriteRowStrings[3] : nil
            let massInGrams = meteoriteRowStrings.count > 4 ? Double(meteoriteRowStrings[4]) : nil
            let fall = meteoriteRowStrings.count > 5 ? meteoriteRowStrings[5] : nil
            let year = meteoriteRowStrings.count > 6 ? csvDateFormatter.date(from: meteoriteRowStrings[6]) : nil
            let recLat = meteoriteRowStrings.count > 7 ? Double(meteoriteRowStrings[7]) : nil
            let recLong = meteoriteRowStrings.count > 8 ? Double(meteoriteRowStrings[8]) : nil
            let geoLocation = meteoriteRowStrings.count > 10 ? meteoriteRowStrings[9] + "," + meteoriteRowStrings[10] : nil
            
            createNewMeteorite(name: name,
                               nasaID: nasaID,
                               nameType: nameType,
                               recClass: recClass,
                               massInGrams: massInGrams,
                               fall: fall,
                               year: year,
                               recLat: recLat,
                               recLong: recLong,
                               geoLocation: geoLocation)
        }
        
        saveContext()
    }
    
    static let csvDateFormatter: DateFormatter = {
        
        let csvDateFormatter = DateFormatter()
        csvDateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss a"
        return csvDateFormatter
    }()
    
    class func deleteAllMeteorites() {
        
        
    }
    
    class func createNewMeteorite(name: String?,
                                  nasaID: Int32?,
                                  nameType: String?,
                                  recClass: String?,
                                  massInGrams: Double?,
                                  fall: String?,
                                  year: Date?,
                                  recLat: Double?,
                                  recLong: Double?,
                                  geoLocation: String?) {
        
        let context = persistentContainer.viewContext
        let meteoriteEntity = NSEntityDescription.entity(forEntityName: "Meteorite", in: context)
        let newMeteorite = NSManagedObject(entity: meteoriteEntity!, insertInto: context) as? Meteorite
        newMeteorite?.name = name
        newMeteorite?.nasaID = nasaID ?? 0
        newMeteorite?.nameType = nameType
        newMeteorite?.recClass = recClass
        newMeteorite?.massInGrams = massInGrams ?? 0
        newMeteorite?.fall = fall
        newMeteorite?.year = year
        newMeteorite?.recLat = recLat ?? 0
        newMeteorite?.recLong = recLong ?? 0
        newMeteorite?.geoLocation = geoLocation
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Meteorite_Mania")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

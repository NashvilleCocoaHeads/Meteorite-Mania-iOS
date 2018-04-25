//
//  MeteoriteListViewController.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/18/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit
import MapKit

class MeteoriteListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var meteorites: [Meteorite]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DispatchQueue(label: "ImportQueue").async {
            MeteoritesCoreDataStore.deleteAllMeteorites()
            MeteoritesCoreDataStore.importNASAMeteoritesCSV(csvFileName: "Meteorite_Landings")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .DataUpdated, object: nil)
    }
    
    @objc func updateData() {
        
        DispatchQueue.main.async {
            
            self.meteorites = MeteoritesCoreDataStore.fetchAllMeteoritesByYearDescending()
            self.tableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meteorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MeteoriteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MeteoriteTableViewCell else {
            fatalError("The dequeued cell is not an instance of MeteoriteTableViewCell.")
        }
        
        if let meteorite = meteorites?[indexPath.row] {
            
            cell.nameLabel.text = meteorite.name
            
            if let fall = meteorite.fall, let year = meteorite.year {
                let yearDateFormatter = DateFormatter()
                yearDateFormatter.dateFormat = "yyyy"
                cell.discoveryLabel.text = fall + " in " + yearDateFormatter.string(from: year)
            }
            
            cell.massLabel.text = "\(meteorite.massInGrams)g"
            
            let annotation = MKPointAnnotation()
            let centerCoordinate = CLLocationCoordinate2D(latitude: meteorite.recLat, longitude:meteorite.recLong)
            annotation.coordinate = centerCoordinate
            cell.mapView.addAnnotation(annotation)
            cell.mapView.centerCoordinate = centerCoordinate
        }
        
        return cell
    }
}

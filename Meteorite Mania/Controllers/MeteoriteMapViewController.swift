//
//  MeteoriteMapViewController.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/22/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit
import MapKit

class MeteoriteMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld)
        mapView.setRegion(worldRegion, animated: false)

        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .DataUpdated, object: nil)
        updateData()
    }
    
    @objc func updateData() {
        
        DispatchQueue.main.async {
        
            let meteorites = MeteoritesCoreDataStore.fetchAllMeteoritesByYearDescending()
            meteorites?.forEach({ (meteorite) in
                let annotation = MKPointAnnotation()
                let centerCoordinate = CLLocationCoordinate2D(latitude: meteorite.recLat, longitude:meteorite.recLong)
                annotation.coordinate = centerCoordinate
                self.mapView.addAnnotation(annotation)
            })
        }
    }
}

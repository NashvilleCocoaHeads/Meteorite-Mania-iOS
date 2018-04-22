//
//  MeteoriteTableViewCell.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/22/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit
import MapKit

class MeteoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var discoveryLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld)
        mapView.setRegion(worldRegion, animated: false)
    }
    
    override func prepareForReuse() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

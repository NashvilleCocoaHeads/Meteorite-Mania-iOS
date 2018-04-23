//
//  MeteoriteMapViewController.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/22/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit
import MapKit

class MeteoriteMapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0

        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .DataUpdated, object: nil)
        updateData()
    }
    
    @objc func updateData() {
        
        DispatchQueue.main.async {
        
            let meteorites = MeteoritesCoreDataStore.fetchAllMeteoritesByYearDescending()
            
            var mapImage = UIImage(named: "land_shallow_topo_8192")!
            
            meteorites?.forEach({ (meteorite) in
                mapImage = self.addAnnotationToImage(image: mapImage,
                                                     coordinate: CLLocationCoordinate2D(latitude: meteorite.recLat,
                                                                                        longitude: meteorite.recLong))
            })
            
            self.mapImageView.image = mapImage
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    func addAnnotationToImage(image: UIImage, coordinate: CLLocationCoordinate2D) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        
        let coordinatePoint = CGPoint(x: (CGFloat(coordinate.longitude) + 180.0) / 360.0 * image.size.width,
                                      y: (-CGFloat(coordinate.latitude) + 90.0) / 180.0 * image.size.height)
        
        let path = UIBezierPath(arcCenter: coordinatePoint, radius: 10.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
        path.fill()
        
        let imageWithAnnotationAdded = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithAnnotationAdded!
    }
}

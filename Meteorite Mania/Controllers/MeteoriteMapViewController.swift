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
        scrollView.maximumZoomScale = 20.0

        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .DataUpdated, object: nil)
        updateData()
    }
    
    @objc func updateData() {
        
        DispatchQueue.main.async {
        
            if let meteorites = MeteoritesCoreDataStore.fetchAllMeteoritesByYearDescending() {
                
                var mapImage = UIImage(named: "land_shallow_topo_8192")!
                
                mapImage = self.addAnnotationToImage(image: mapImage, meteorites: meteorites)
                
                self.mapImageView.image = mapImage
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    func addAnnotationToImage(image: UIImage, meteorites: [Meteorite]) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(UIColor.red.cgColor)
        
        for meteorite in meteorites {
            
            let coordinatePoint = CGPoint(x: (CGFloat(meteorite.recLong) + 180.0) / 360.0 * image.size.width,
                                          y: (-CGFloat(meteorite.recLat) + 90.0) / 180.0 * image.size.height)
            
            let path = UIBezierPath(arcCenter: coordinatePoint, radius: 10.0, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
            path.fill()
        }
        
        let imageWithAnnotationAdded = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithAnnotationAdded!
    }
}

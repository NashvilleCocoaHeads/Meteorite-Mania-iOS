//
//  MeteoriteGraphsViewController.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/24/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit

class MeteoriteGraphsViewController: UIViewController {
    
    var foundByYearGraphDataModel: GraphDataModel?
    var fellByYearGraphDataModel: GraphDataModel?
    
    @IBOutlet weak var graphsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: .DataUpdated, object: nil)
        updateData()
    }
    
    @objc func updateData() {
        
        //compute data set for number found and number fell per year from 1900 to 2000
        DispatchQueue(label: "MeteoriteGraphsViewController.ComputeDataModel").async {
            
            var totalFoundByYearGraphPoints = [GraphPoint]()
            var totalFellByYearGraphPoints = [GraphPoint]()
            let minYear = 1900
            let maxYear = 2000
            for year in 1900...2000 {
                totalFoundByYearGraphPoints.append(GraphPoint(xValue: Double(year), yValue: 0))
                totalFellByYearGraphPoints.append(GraphPoint(xValue: Double(year), yValue: 0))
            }
            
            if let meteorites = MeteoritesCoreDataStore.fetchAllMeteoritesByYearDescending() {
                
                for meteorite in meteorites {
                    
                    let yearDateFormatter = DateFormatter()
                    yearDateFormatter.dateFormat = "yyyy"
                    
                    guard let meteoriteDate = meteorite.year else { continue }
                    
                    let meteoriteYearString = yearDateFormatter.string(from: meteoriteDate)
                    guard let meteoriteYear = Int(meteoriteYearString) else { continue }
                    
                    guard (meteoriteYear >= minYear && meteoriteYear <= maxYear) else { continue }
                    
                    if (meteorite.fall == "Found") {
                        let currentFoundPointForYear = totalFoundByYearGraphPoints[meteoriteYear-minYear]
                        let newFoundPointForYear = GraphPoint(xValue: currentFoundPointForYear.xValue, yValue: currentFoundPointForYear.yValue + 1)
                        totalFoundByYearGraphPoints[meteoriteYear-minYear] = newFoundPointForYear
                    } else if (meteorite.fall == "Fell") {
                        let currentFellPointForYear = totalFellByYearGraphPoints[meteoriteYear-minYear]
                        let newFellPointForYear = GraphPoint(xValue: currentFellPointForYear.xValue, yValue: currentFellPointForYear.yValue + 1)
                        totalFellByYearGraphPoints[meteoriteYear-minYear] = newFellPointForYear
                    }
                }
                
                self.foundByYearGraphDataModel = GraphDataModel(yAxisTitle: "Found", graphPoints: totalFoundByYearGraphPoints)
                self.fellByYearGraphDataModel = GraphDataModel(yAxisTitle: "Fell", graphPoints: totalFellByYearGraphPoints)
                
                DispatchQueue.main.async {
                    self.graphsCollectionView.reloadData()
                }
            }
        }
    }
}

extension MeteoriteGraphsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCollectionViewCell", for: indexPath) as! GraphCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.gradientLineGraphView.graphDataModel = foundByYearGraphDataModel
        case 1:
            cell.gradientLineGraphView.graphDataModel = fellByYearGraphDataModel
        default:
            fatalError("Got to an unexpected graph collection view index")
        }
        
        return cell
    }
}


extension MeteoriteGraphsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemWidth = collectionView.frame.size.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right
        
        return CGSize(width: itemWidth, height: collectionViewFlowLayout.itemSize.height)
    }
}

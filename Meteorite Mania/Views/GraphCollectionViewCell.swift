//
//  GraphCollectionViewCell.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/24/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit

class GraphCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientLineGraphView: GradientLineGraphView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        
        layer.shadowColor = UIColor.init(white: 0, alpha: 0.23).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
}

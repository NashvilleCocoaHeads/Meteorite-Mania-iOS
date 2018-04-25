//
//  GraphDataModel.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/24/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import Foundation

struct GraphDataModel {
    
    let yAxisTitle: String?
    let graphPoints: [GraphPoint]
}

struct GraphPoint {
    let xValue: Double
    let yValue: Double
}

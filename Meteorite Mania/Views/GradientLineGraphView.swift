//
//  GradientLineGraphView.swift
//  Meteorite Mania
//
//  Created by Jonathan Wiley on 4/24/18.
//  Copyright © 2018 LunarLincoln. All rights reserved.
//

import UIKit

@IBDesignable
class GradientLineGraphView: UIView {

    var graphDataModel: GraphDataModel? {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    let yAxisLabelColor = UIColor(red: 233/255, green: 127/255, blue: 1/255, alpha: 1)
    let xAxisLabelColor = UIColor.white
    let graphLineColor = UIColor(red: 240/255, green: 61/255, blue: 162/255, alpha: 1)
    
    override func prepareForInterfaceBuilder() {
        
        let testFoundDates = [
            GraphPoint(xValue: 1900, yValue: 200),
            GraphPoint(xValue: 1910, yValue: 400),
            GraphPoint(xValue: 1920, yValue: 600),
            GraphPoint(xValue: 1930, yValue: 200),
            GraphPoint(xValue: 1940, yValue: 600),
            GraphPoint(xValue: 1950, yValue: 700),
            GraphPoint(xValue: 1960, yValue: 800),
            GraphPoint(xValue: 1970, yValue: 200),
            GraphPoint(xValue: 1980, yValue: 100),
            GraphPoint(xValue: 1990, yValue: 700),
            GraphPoint(xValue: 2000, yValue: 0)
        ]
        
        graphDataModel = GraphDataModel(yAxisTitle: "Found", graphPoints: testFoundDates)
    }

    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard let graphDataModel = graphDataModel else { return }
        
        //draw y axis
        let minYValue = graphDataModel.graphPoints.min{ return $0.yValue < $1.yValue }?.yValue ?? 0
        let maxYValue = graphDataModel.graphPoints.max{ return $0.yValue < $1.yValue }?.yValue ?? 100
        
        let yLabelStrings = axisLabelStrings(minValue: Double(minYValue), maxValue: Double(maxYValue), numberOfLabels: 10)
        
        var yLabelAttributedStrings = [NSAttributedString]()
        var maxYLabelWidth: CGFloat = 0
        for yLabelString in yLabelStrings {
            
            let yLabelAttributedString = NSAttributedString(string: yLabelString,
                                                            attributes: [
                                                                .foregroundColor: yAxisLabelColor,
                                                                .font: UIFont.systemFont(ofSize: 6)
                ])
            yLabelAttributedStrings.append(yLabelAttributedString)
            
            if (yLabelAttributedString.size().width > maxYLabelWidth) {
                maxYLabelWidth = yLabelAttributedString.size().width
            }
        }
        
        let leftPadding: CGFloat = 8
        let bottomPadding: CGFloat = 30
        
        for yLabelAttributedString in yLabelAttributedStrings {
            
            guard let currentIndex = yLabelAttributedStrings.index(of: yLabelAttributedString) else { continue }
            
            yLabelAttributedString.draw(at: CGPoint(x: leftPadding,
                                                    y: (self.bounds.size.height-bottomPadding) / CGFloat(yLabelAttributedStrings.count) * CGFloat(yLabelAttributedStrings.count - 1 - currentIndex)))
        }
        
        let leftGraphPadding = leftPadding + maxYLabelWidth
        
        //draw x axis
        let minXValue = graphDataModel.graphPoints.min{ return $0.xValue < $1.xValue }?.xValue ?? 0
        let maxXValue = graphDataModel.graphPoints.max{ return $0.xValue < $1.xValue }?.xValue ?? 100
        
        let xLabelStrings = axisLabelStrings(minValue: Double(minXValue), maxValue: Double(maxXValue), numberOfLabels: 11)
        
        for xLabelString in xLabelStrings {
            
            let xLabelAttributedString = NSAttributedString(string: xLabelString,
                                                            attributes: [
                                                                .foregroundColor: xAxisLabelColor,
                                                                .font: UIFont.systemFont(ofSize: 6, weight: .light)
                ])
            
            guard let currentIndex = xLabelStrings.index(of: xLabelString) else { continue }
            
            xLabelAttributedString.draw(at: CGPoint(x: leftGraphPadding +
                (self.bounds.size.width-leftGraphPadding) / CGFloat(xLabelStrings.count) * CGFloat(currentIndex),
                                                    y: self.bounds.size.height - bottomPadding))
        }
        
        //draw graph
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setStrokeColor(graphLineColor.cgColor)
        context.setLineWidth(2)
        
        let graphViewRect = CGRect(x: leftGraphPadding,
                                   y: 0,
                                   width: self.bounds.size.width-leftGraphPadding,
                                   height: self.bounds.size.height-bottomPadding)
        
        let drawingPoints = convertGraphPointXYValuesToDrawingPoints(graphDataModel.graphPoints, targetViewRect: graphViewRect)
        
        guard let firstDrawingPoint = drawingPoints.first else { return }
        
        context.move(to: firstDrawingPoint)
        context.addLines(between: drawingPoints)
        context.strokePath()
        
        //draw title
        guard let graphTitle = graphDataModel.yAxisTitle else { return }
        
        let titleLabelAttributedString = NSAttributedString(string: graphTitle,
                                                            attributes: [
                                                                .foregroundColor: UIColor.white,
                                                                .font: UIFont.systemFont(ofSize: 8, weight: .light)
            ])
        
        let titleLabelX = (self.bounds.width-leftGraphPadding)/2 - titleLabelAttributedString.size().width/2
        let titleLabelY = self.bounds.height-bottomPadding+bottomPadding/2-titleLabelAttributedString.size().height/2
        let titleLabelDrawPoint = CGPoint(x: titleLabelX, y: titleLabelY)
        
        titleLabelAttributedString.draw(at: titleLabelDrawPoint)
    }
    
    func axisLabelStrings(minValue: Double, maxValue: Double, numberOfLabels: Int) -> [String] {
        
        var axisLabelStrings = [String]()
        for index in 0...numberOfLabels-1 {
            
            axisLabelStrings.append("\(Int(minValue + (maxValue - minValue)/Double(numberOfLabels-1)*Double(index)))")
        }
        
        return axisLabelStrings
    }
    
    func convertGraphPointXYValuesToDrawingPoints(_ graphPoints: [GraphPoint], targetViewRect: CGRect) -> [CGPoint] {
        
        let minXValue = graphPoints.min{ return $0.xValue < $1.xValue }?.xValue ?? 0
        let maxXValue = graphPoints.max{ return $0.xValue < $1.xValue }?.xValue ?? 100
        
        let minYValue = graphPoints.min{ return $0.yValue < $1.yValue }?.yValue ?? 0
        let maxYValue = graphPoints.max{ return $0.yValue < $1.yValue }?.yValue ?? 100
        
        let xScaleFactor = targetViewRect.width / (CGFloat(maxXValue) - CGFloat(minXValue))
        let yScaleFactor = targetViewRect.height / (CGFloat(maxYValue) - CGFloat(minYValue))
        
        var drawingPoints = [CGPoint]()
        graphPoints.forEach { (graphPoint) in
            let drawingPoint = CGPoint(x: targetViewRect.minX + CGFloat(graphPoint.xValue - minXValue)*xScaleFactor,
                                       y: targetViewRect.minY + CGFloat(graphPoint.yValue - minYValue)*yScaleFactor)
            drawingPoints.append(drawingPoint)
        }
        
        return drawingPoints
    }
}

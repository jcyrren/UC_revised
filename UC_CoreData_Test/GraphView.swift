//
//  GraphView.swift
//  UC_CoreData_Test
//
//  Created by Katie Collins on 2/23/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit

class GraphView: UIView {
    var vals : [Int] = []
    var number : Int = 9
    var maxHeight: Int = 85
    
    
    
    var dates: [String] = [] // these dates are in "short-style" format and are in the same order as the values of the actual data in the values array
    var shownDates: [String] = []
    
    override func draw(_ rect: CGRect){
        self.subviews.forEach({$0.removeFromSuperview()})
        let gradientView = UIImageView(frame: self.bounds)
        gradientView.image = #imageLiteral(resourceName: "green_to_red")
        gradientView.alpha = 0.7
        addSubview(gradientView)
        
        let fieldColor: UIColor = UIColor.black
        let fieldFont = UIFont(name: "SFUIDisplay-Semibold", size: 13)
        let attributes: [String: Any] = [
            NSForegroundColorAttributeName: fieldColor,
            //NSFontAttributeName: fieldFont!,
            NSKernAttributeName: 1.3
        ]
        
        let width = Int(bounds.width)
        let height = Int(bounds.height)
        if (vals.count > 0) {
            let p1 = UIBezierPath()
            p1.move(to: CGPoint(x: width/(number + 1), y: pointer(vals: vals, height: height, number : number)[0]))
            var w : Int = 0
            for p in pointer(vals: vals, height: height, number : number) {
                w += 1
                p1.addLine(to: CGPoint(x: w * width/(number + 1), y: p))
                p1.move(to: CGPoint(x: w * width/(number + 1), y: p))
                let dateLabel = LabelView(frame: CGRect(x: w * width/(number + 1), y: Int(bounds.height)-30, width: 20, height: 100))
                dateLabel.attributedText = NSMutableAttributedString(string: "Entry \((vals.count - number) + w - 1)", attributes: attributes)
                self.addSubview(dateLabel)
        }
        
        p1.lineWidth = 5
        p1.stroke()
        } else {
            
            let noDataLabel = LabelView(frame: CGRect(x: 12, y: bounds.height/2 - 50, width: 20, height: 100))
            noDataLabel.attributedText = NSMutableAttributedString(string: "No Data", attributes: attributes)
            self.addSubview(noDataLabel)
            
            
            
        }
        
        let p2 = UIBezierPath()
        p2.move(to: CGPoint(x: 0, y: 0))
        p2.addLine(to: CGPoint(x: 0, y: height))
        p2.move(to: CGPoint(x: 0, y: height))
        p2.addLine(to: CGPoint(x: width, y: height))
        
        p2.lineWidth = 3
        p2.stroke()
        
        
        
        
        let severityLabel = LabelView(frame: CGRect(x: 6, y: bounds.height/2 - 50, width: 20, height: 100))
        severityLabel.attributedText = NSMutableAttributedString(string: "severity", attributes: attributes)
        self.addSubview(severityLabel)
        
        
        
        
        
    }
    
    //func dateFinder(w: Int) -> String {
     //   let d = dates[dates.count - (number - w)]
    //    return d
    //}
    
    func pointer(vals: [Int], height : Int, number: Int) -> [Int]{
        
        var modvals : [Int] = []
        //shownDates = []
        
        for n in 1...number {
            
            modvals.insert(vals[vals.count - n], at: 0)
            //modvals.append(vals[vals.count - n])
            
            //shownDates.insert(dates[dates.count - n], at: 0)
        }
        var finalvals : [Int] = []
        
        for m in modvals {
            finalvals.append(height - (m * (height/maxHeight)))
        }
        
        return finalvals
    }
}

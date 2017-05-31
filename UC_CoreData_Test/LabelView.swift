//
//  LabelView.swift
//  UC_CoreData_Test
//
//  Created by John Barbone on 5/29/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import UIKit

class LabelView: UILabel{
    override func draw(_ rect: CGRect) {
        guard let text = self.text else {
            return
        }
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        //let doTransform = false
        
        let transform = CGAffineTransform(
            
            rotationAngle: CGFloat(-Double.pi / 2))
        context!.concatenate(transform)
        context!.translateBy(x: -rect.size.height, y: 0)
        
        var newRect = rect.applying(transform)
        
        newRect.origin = CGPoint(x: 0, y: 0)
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineBreakMode = self.lineBreakMode
        textStyle.alignment = self.textAlignment
        
        let attributeDict: [String:AnyObject] = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.textColor,
            NSParagraphStyleAttributeName: textStyle,
            ]
        
        let nsStr = text as NSString
        nsStr.draw(in: newRect, withAttributes: attributeDict)
    }
}

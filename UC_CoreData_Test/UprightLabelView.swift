//
//  UprightLabelView.swift
//  UC_CoreData_Test
//
//  Created by John Barbone on 5/31/17.
//  Copyright © 2017 CollinsInnovation. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class UprightLabelView: UILabel{
    override func draw(_ rect: CGRect) {
        guard let text = self.text else {
            return
        }
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        //let doTransform = false
        
        
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.lineBreakMode = self.lineBreakMode
        textStyle.alignment = self.textAlignment
        
        let attributeDict: [String:AnyObject] = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.textColor,
            NSParagraphStyleAttributeName: textStyle,
            ]
        
        let nsStr = text as NSString
        nsStr.draw(in: rect, withAttributes,: attributeDict)
    }
}

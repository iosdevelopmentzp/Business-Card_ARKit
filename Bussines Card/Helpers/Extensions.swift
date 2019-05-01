//
//  Extensions.swift
//  Bussines Card
//
//  Created by Imac on 3/13/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit


extension Float {
    func cgFloat () -> CGFloat {
        return CGFloat(self)
    }
}

extension CGFloat {
    func float () -> Float {
        return Float(self)
    }
    
    var double: Double  {
        return Double(self)
    }
}

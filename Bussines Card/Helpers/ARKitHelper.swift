//
//  ARKitHelper.swift
//  Bussines Card
//
//  Created by Imac on 3/18/19.
//  Copyright © 2019 idev. All rights reserved.
//

import ARKit
import SceneKit




class ARKitHelper {
    
    static func createTextNode(string: String, size: Float, color: UIColor) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = color
        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = size
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        
        return textNode
    }
}

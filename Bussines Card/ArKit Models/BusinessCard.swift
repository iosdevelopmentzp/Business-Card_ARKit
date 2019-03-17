//
//  BusinessCard.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import Foundation
import ARKit
import WebKit
import MapKit



class BusinessCard: SCNNode {
    
    // C O N S T A N T S
    //MARK: - Constans
    let k_sceneName = "scn.scnassets/BusinessCard.scn"
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(employee: (PersonProtocol & EmployeeProtocol) ) {
        super.init()
        
        guard   let template = SCNScene(named: k_sceneName),
                let cardRoot = template.rootNode.childNode(withName: "RootNode", recursively: false),
                let target = cardRoot.childNode(withName: "BusinessCardTarget", recursively: false),
                let avatar = cardRoot.childNode(withName: "Avatar", recursively: false)
            else { fatalError("Error Getting Business Card Node Data") }
        
        avatar.geometry?.materials.first?.diffuse.contents = employee.avatar
        target.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        
        self.addChildNode(cardRoot)
        self.eulerAngles.x = -.pi / 2
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("Business Card Coder Not Implemented") }
    
    deinit {
//        flushFromMemory()
    }
    
    /// Removes All SCNMaterials & Geometries From An SCNNode
    func flushFromMemory(){

        debugPrint("Cleaning Business Card")
        
        if let parentNodes = self.parent?.childNodes{ parentNodes.forEach {
            $0.geometry?.materials.forEach({ (material) in material.diffuse.contents = nil })
            $0.geometry = nil
            $0.removeFromParentNode()
            }
        }
        
        for node in self.childNodes{
            node.geometry?.materials.forEach({ (material) in material.diffuse.contents = nil })
            node.geometry = nil
            node.removeFromParentNode()
        }
    }
}

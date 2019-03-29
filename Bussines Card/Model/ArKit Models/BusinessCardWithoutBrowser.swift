//
//  BusinessCard.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import Foundation
import ARKit

import MapKit

class BusinessCardWithoutBrowser: SCNNode {
    
    // // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    
    
    var type: CardType

    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(type: CardType) {
        self.type = .horizontal
        super.init()

        guard   let template = SCNScene(named: type.sceneName() ),
            let cardRoot = template.rootNode.childNode(withName: "RootNode", recursively: false),
                let target = cardRoot.childNode(withName: "BusinessCardTarget", recursively: false),
                let caseStudiesNode = target.childNode(withName: "CaseStudies", recursively: false),
                let linkNode = target.childNode(withName: "LinkNode", recursively: false),
                let buttonLinkedin = target.childNode(withName: "button_linkedin", recursively: true),
                let buttonFacebook = target.childNode(withName: "button_facebook", recursively: true),
                let buttonTwitter = target.childNode(withName: "button_twitter", recursively: true),
                let buttonInstagram = target.childNode(withName: "button_instagram", recursively: true),
                let occlusionCardNode = cardRoot.childNode(withName: "OcclusionCardNode", recursively: false)
            else { fatalError("Error Getting Business Card Node Data") }
        
        target.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        
        caseStudiesNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Case studies.png")
        linkNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Link Square")
        
        
        // social link buttons
        buttonLinkedin.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Linkedin")
        buttonFacebook.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Facebook")
        buttonTwitter.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Twitter")
        buttonInstagram.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Instagram")
        
        // occlusion
        occlusionCardNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        occlusionCardNode.renderingOrder = -1
        
        
        self.addChildNode(cardRoot)
        self.eulerAngles.x = -.pi / 2
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Business Card Coder Not Implemented") }
    
    deinit {
        debugPrint("\(String(describing: BusinessCard.self)) deinited")
    }
    
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
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods

}

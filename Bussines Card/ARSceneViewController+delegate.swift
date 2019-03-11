//
//  ARSceneViewController+delegate.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


//--------------------------
//MARK: -  ARSessionDelegate
//--------------------------

extension ARSceneViewController: ARSessionDelegate{
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        if menuShown { return }
        
        //1. Enumerate Our Anchors To See If We Have Found Our Target Anchor
        for anchor in anchors{
            
            if let imageAnchor = anchor as? ARImageAnchor, imageAnchor == targetAnchor{
                
                //2. If The ImageAnchor Is No Longer Tracked Then Reset The Business Card
                if !imageAnchor.isTracked{
                    businessCardPlaced = false
                    businessCard.setBaseConfiguration()
                }else{
                    
                    //3. Layout The Card Again
                    if !businessCardPlaced{
                        businessCard.animateBusinessCard()
                        businessCardPlaced = true
                    }
                }
            }
        }
    }
}

//--------------------------
//MARK: -  ARSCNViewDelegate
//--------------------------


extension ARSceneViewController: ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        //1. Check We Have A Valid Image Anchor
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        //2. Get The Detected Reference Image
        let referenceImage = imageAnchor.referenceImage
        
        //3. Load Our Business Card
        if let matchedBusinessCardName = referenceImage.name, matchedBusinessCardName == "BlackMirrorz" && !businessCardPlaced{
            
            businessCardPlaced = true
            node.addChildNode(businessCard)
            businessCard.animateBusinessCard()
            targetAnchor = imageAnchor
            
        }
        
        if let matchedBusinessCardName = referenceImage.name, matchedBusinessCardName == "secondCard" && !businessCardPlaced{
            
            businessCardPlaced = true
            node.addChildNode(businessCard)
            businessCard.animateBusinessCard()
            targetAnchor = imageAnchor
            
        }
    }
}

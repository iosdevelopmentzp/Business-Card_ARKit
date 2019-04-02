//
//  ARSceneViewController+delegate.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

// Help link - https://www.viget.com/articles/using-arkit-and-image-tracking/

import UIKit
import ARKit
import SceneKit
import AVFoundation


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
                    //debugPrint("f The ImageAnchor Is No Longer Tracked Then Reset The Business Card")
                    setupARSession()
                    businessCardPlaced = false
                    webViewNode?.removeFromParentNode()
                    self.webViewNode = nil
                    
                }else{
                    
                    //3. Layout The Card Again
                    if !businessCardPlaced, let _ = mainNode {
                        //debugPrint("Layout The Card Again")
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
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        
        debugPrint("Finded image"	)
        
        if let name = imageAnchor.referenceImage.name {
            debugPrint("\(name) image")
        }
        
        let referenceImage = imageAnchor.referenceImage
        
        animateCard(node: node, anchor: anchor)
    }
}

//
//  ARSceneViewController+delegate.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

// https://www.viget.com/articles/using-arkit-and-image-tracking/

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
                    debugPrint("f The ImageAnchor Is No Longer Tracked Then Reset The Business Card")
                    setupARSession()
                    businessCardPlaced = false
                    webViewNode?.removeFromParentNode()
                    self.webViewNode = nil
                    
                }else{
                    
                    //3. Layout The Card Again
                    if !businessCardPlaced, let _ = mainNode {
                        debugPrint("Layout The Card Again")
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
        
        let referenceImage = imageAnchor.referenceImage
        
        animateCard(node: node, anchor: anchor)
        
        
//        //##############################################################################################################################
        // Add Video Node

        
        
//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] (_) in
//
//            guard let cardOcclusionNode = self?.cardOcclusionNode,
//                  let textNode = self?.textNode,
//                  let videoNode = self?.videoNode
//            else {return}
//            node.addChildNode(cardOcclusionNode)
//
//            // Text Action
//            let textOpacityAction = SCNAction.fadeOpacity(to: 0, duration: 0.1)
//            let textNewVector = SCNVector3Make(textNode.position.x,
//                                               textNode.position.y,
//                                               node.position.z + Float(heightImage)/2 - 0.01 )
//            let textMoveAction = SCNAction.move(to: textNewVector, duration: 0.1)
//            textNode.runAction(textOpacityAction)
//            textNode.runAction(textMoveAction)
//        }
//
//        let videoHolder = SCNNode()
//        let videoHolderGeometry = SCNPlane(width: widthImage, height: heightImage)
//        videoHolder.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
//        videoHolder.geometry = videoHolderGeometry
//        videoHolder.position.z = textNode.position.z + Float(heightImage)/2
//
//        //4. Create Our Video Player
//        if let videoURL = Bundle.main.url(forResource: "BusinessCard", withExtension: "mp4") {
//            setupVideoOnNode(videoHolder, fromURL: videoURL)
//        }
//
//        // animation appeareance
//
//        let rotationAsRadian = CGFloat(GLKMathDegreesToRadians(360))
//        let videoAction = SCNAction.rotate(by: rotationAsRadian, around: SCNVector3(1, 0, 0), duration: 5)
//
//        //5. Add It To The Hierarchy
////        node.addChildNode(videoHolder)
////        videoHolder.runAction(videoAction)
//
//        self.videoNode = videoHolder
    }
    
    
}

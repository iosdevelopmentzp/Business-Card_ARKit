//
//  ARSceneViewController+Interactor.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

import Foundation
import ARKit


extension ARSceneViewController {
    
    //-----------------------
    //MARK: - UserInteraction
    //-----------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //1. Get The Current Touch Location & Perform An SCNHitTest To Detect Which Nodes We Have Touched
        guard let currentTouchLocation = touches.first?.location(in: self.augmentedRealityView),
            let hitTestResult = self.augmentedRealityView.hitTest(currentTouchLocation, options: nil).first?.node.name
            else { return }
        
        //2. Perform The Neccessary Action Based On The Hit Node
        switch hitTestResult {
        case ARSceneViewController.buttonInfoName:
          webIsHide = false
        case ARSceneViewController.buttonInfoHide:
            webIsHide = true
        default: ()
        }
    }
    
    
    
    //-----------------------
    //MARK: - AnimateMethods
    //-----------------------
    
    
    
    
    func animateCard (node: SCNNode?, anchor: ARAnchor?) {
        //1. Check We Have A Valid Image Anchor
        
        guard let imageAnchor = anchor as? ARImageAnchor,
             let node = node else { return }
        
        businessCardPlaced = true
        self.mainNode = node
        self.targetAnchor = imageAnchor
        
        let referenceImage = imageAnchor.referenceImage
        
        let widthImage = referenceImage.physicalSize.width
        let heightImage = referenceImage.physicalSize.height
        self.widthCard = widthImage
        self.heightCard = heightImage
        
        
        
        
        // create cardOcclusionNode
        let cardOcclusionNode = createCardOcclusionNode(width: widthImage, height: heightImage)
        self.cardOcclusionNode = cardOcclusionNode
        node.addChildNode(cardOcclusionNode)
        
        
        // ADD NAME TEXT
        let sizeText = heightImage * 0.1
        let textNode = createTextNode(string: "Schevchenko Natalia", size: Float(sizeText), color: #colorLiteral(red: 0.3098039329, green: 0.0119162152, blue: 0.05550052771, alpha: 1))
        textNode.eulerAngles.x = -.pi/2
        textNode.position.x = textNode.position.x - Float(widthImage/2)
        textNode.position.y -= 0.005
        textNode.opacity = 0.0
        
        let finishPositionText = SCNVector3Make(textNode.position.x,
                                                textNode.position.y,
                                                textNode.position.z + Float(heightImage/2 + sizeText * 2) + 0.001 )
        let animationText = SCNAction.move(to: finishPositionText, duration: 0.5)
        let opacityAnimation = SCNAction.fadeOpacity(by: 1.0, duration: 0.5)
        
        textNode.runAction(animationText)
        textNode.runAction(opacityAnimation)
        self.textNode = textNode
        node.addChildNode(textNode)
        
        
        
        // ADD AVATAR IMAGE
        let widthAvatar =  heightImage * ARSceneViewController.heightNameLabelCoephysient
        let avatarImageNode = SCNNode(geometry: SCNPlane(width: widthAvatar, height: widthAvatar))
        
        // 1. add image
        avatarImageNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "avatar")
        node.addChildNode(avatarImageNode)
        
        // 2. geometry
        avatarImageNode.eulerAngles.x = -.pi/2
        avatarImageNode.position.y = avatarImageNode.position.y - 0.005
        avatarImageNode.position.z = Float(node.position.y) - Float(heightImage/2) + Float(widthAvatar) / 2
        
        //  3. animation
        
        let finishVectorAvatar = SCNVector3Make(node.position.x + Float(widthImage/2) + Float(widthAvatar/2) + 0.001,
                                                node.position.y,
                                                avatarImageNode.position.z)
        let moveActionAvatar = SCNAction.move(to: finishVectorAvatar, duration: 1.0)
        
        

        // ADD BUTTON INFO
        
        let widthButton = widthAvatar
        let heightButton: CGFloat = 0.01
        let infoButtonNode = SCNNode(geometry: SCNPlane(width: widthButton, height: heightButton ))
        self.infoButtonNode = infoButtonNode
        infoButtonNode.name = ARSceneViewController.buttonInfoName
        infoButtonNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "button_info")
        avatarImageNode.addChildNode(infoButtonNode)
        infoButtonNode.position.z = avatarImageNode.position.z + 0.005
        infoButtonNode.opacity = 0.0
        let finishVectorButton = SCNVector3Make(0,
                                                infoButtonNode.position.y - Float(widthAvatar/2) - 0.005,
                                                0)
        let moveActionButton = SCNAction.move(to: finishVectorButton, duration: 0.3)
        let opacityActionButton = SCNAction.fadeOpacity(to: 1, duration: 0.3)
        
        
        // ADD BUTTON HIDE (in the begining button will be hide)
        let hideButtonNode = SCNNode(geometry: SCNPlane(width: widthButton, height: heightButton ))
        self.hideButtonNode = hideButtonNode
        hideButtonNode.name = ARSceneViewController.buttonInfoHide
        hideButtonNode.geometry?.materials.first?.diffuse.contents = UIImage(named: "button_hide")
        hideButtonNode.opacity = 0
        avatarImageNode.addChildNode(hideButtonNode)
        
        // animate
        avatarImageNode.runAction(moveActionAvatar) {
            infoButtonNode.runAction(moveActionButton)
            infoButtonNode.runAction(opacityActionButton)
            hideButtonNode.runAction(moveActionButton)
        }
        
    }
    
   
    
    func infoButtonHide( _ isHide: Bool) {
        let duration = 0.5
        if isHide {
            self.hideButtonNode?.runAction(.fadeOpacity(to: 1, duration: duration))
            self.infoButtonNode?.runAction(.fadeOpacity(to: 0, duration: duration))
        } else {
            self.hideButtonNode?.runAction(.fadeOpacity(to: 0, duration: duration))
            self.infoButtonNode?.runAction(.fadeOpacity(to: 1, duration: duration))
        }
        
    }
    
    
    
    func showWebInfo () {
        
        guard let mainNode = mainNode,
            let textNode = textNode,
            let cardOcclusionNode = cardOcclusionNode,
            businessCardPlaced else { return }
        
        infoButtonHide(true)
        
        // HIDE TEXT
        let pointForHideText = SCNVector3Make(textNode.position.x,
                                              textNode.position.y,
                                              cardOcclusionNode.position.z)
        let hideText = SCNAction.move(to: pointForHideText, duration: 1.0)
        let opacityText = SCNAction.fadeOpacity(to: 0, duration: 1.0)
        textNode.runAction(hideText)
        textNode.runAction(opacityText) { [weak self] in
            // SHOW Info
            self?.schowWebView(on: mainNode, yOffset: (self?.heightCard ?? 0) * 0.1)
        }
    }
    
    func hideWebInfo () {
        guard let textNode = textNode,
            let cardOcclusionNode = cardOcclusionNode,
            businessCardPlaced else { return }
        
        infoButtonHide(false)
        
        // SHOW TEXT
        if let heightCard = heightCard {
            
            let sizeText = heightCard * 0.1
            let offset: Float = 0.005
            let zPozition = cardOcclusionNode.position.z + heightCard.float() / 2 + sizeText.float() + offset
           
            let pointForShowText = SCNVector3Make(textNode.position.x,
                                                  textNode.position.y,
                                                  zPozition)
            
            textNode.runAction(.move(to: pointForShowText, duration: 1.0))
            textNode.runAction(.fadeOpacity(to: 1, duration: 1.0))
        }
        
        
        // HIDE WEB
        if let rootNode = self.mainNode {
            self.hideWebView(on: rootNode, yOffset: (self.heightCard ?? 0) * 0.1)
        }
        
        
    }
    
    func schowWebView(on rootNode: SCNNode, yOffset: CGFloat) {
        // Xcode yells at us about the deprecation of UIWebView in iOS 12.0, but there is currently
        // a bug that does now allow us to use a WKWebView as a texture for our webViewNode
        // Note that UIWebViews should only be instantiated on the main thread!
        
        guard let widthCard = widthCard, let heightCard = heightCard else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            
            guard let occurencNode = self?.createCardOcclusionNode(width: widthCard, height: heightCard * 2) else { return }
            occurencNode.position.z -= heightCard.float() / 2
            rootNode.addChildNode(occurencNode)
            
            
            
            var webViewNode: SCNNode
            
            if let webNode = self?.webViewNode {
                webViewNode = webNode
            } else {
                
                let webViewPlane = SCNPlane(width: widthCard, height: heightCard * 2)
                webViewPlane.cornerRadius = 0.005
                
                webViewNode = SCNNode(geometry: webViewPlane)
                self?.webViewNode = webViewNode
                
                webViewNode.position.z -= heightCard.float() / 2 + 0.001
                webViewNode.eulerAngles.x = -.pi / 2
                
                // Set the web view as webViewPlane's primary texture
                webViewNode.geometry?.firstMaterial?.diffuse.contents = self?.webView
            }
            
            webViewNode.position.y -= 0.005
           
            rootNode.addChildNode(webViewNode)
            
            let newPosition = SCNVector3(x: webViewNode.position.x, y: webViewNode.position.y,
                                         z: webViewNode.position.z + heightCard.float() * 2 + yOffset.float())
            
            webViewNode.isHidden = false
            webViewNode.runAction( .move(to: newPosition , duration: 0.7))
        }
    }
    
    func hideWebView(on rootNode: SCNNode, yOffset: CGFloat) {
        guard
            let webViewNode = self.webViewNode,
            let widthCard = widthCard,
            let heightCard = heightCard else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let occurencNode = self?.createCardOcclusionNode(width: widthCard, height: heightCard * 2) else { return }
            occurencNode.position.z -= heightCard.float() / 2
            rootNode.addChildNode(occurencNode)

            let moveAction = SCNAction.move(to: occurencNode.position, duration: 0.7)

            webViewNode.position.y -= 0.005
            
            webViewNode.runAction(moveAction, completionHandler: {
                webViewNode.isHidden = true
                occurencNode.removeFromParentNode()
            })
        }
        
    }
    
    func createCardOcclusionNode(width: CGFloat, height: CGFloat) -> SCNNode {
        let mainPlane = SCNPlane(width: width, height: height)
        mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
        let occlusionNode = SCNNode(geometry: mainPlane)
        occlusionNode.eulerAngles.x = -.pi / 2
        occlusionNode.renderingOrder = -1
        occlusionNode.opacity = 1
        return occlusionNode
    }
    
    func createTextNode(string: String, size: Float, color: UIColor) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = color
        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = size
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        
        return textNode
    }
    
    func setupVideoOnNode(_ node: SCNNode, fromURL url: URL){
        
        //1. Create An SKVideoNode
        var videoPlayerNode: SKVideoNode!
        
        //2. Create An AVPlayer With Our Video URL
        let videoPlayer = AVPlayer(url: url)
        
        //3. Intialize The Video Node With Our Video Player
        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        
        //4. Create A SpriteKitScene & Postion It
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayerNode)
        
        //6. Set The Nodes Geoemtry Diffuse Contenets To Our SpriteKit Scene
        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        
        //5. Play The Video
        videoPlayerNode.play()
        videoPlayer.volume = 1
        
    }
    
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOpacity(to: 0.15, duration: 0.25),
            .fadeOpacity(to: 0.85, duration: 0.25),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
            ])
    }
    
}

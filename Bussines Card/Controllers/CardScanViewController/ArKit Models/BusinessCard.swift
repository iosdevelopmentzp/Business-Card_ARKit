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
import AVFoundation

enum CardType {
    case vertical
    case horizontal
    
    func sceneName () -> String {
        switch self {
        case .vertical:
            return "scn.scnassets/BusinessCard.scn"
        case .horizontal:
            return "scn.scnassets/BusinessCardHorizontalWithFrontTemplate.scn"
        }
    }
}

class BusinessCard: SCNNode {
 
    // // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    
    fileprivate(set) var type: CardType = .horizontal
    fileprivate var webView: UIWebView?
    fileprivate var videoPlayer: AVPlayer?
    fileprivate var timeObserverToken: Any?
    fileprivate var currentCriticalPoint: CriticalsPointsVideo = .unknow
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(type: CardType, webView: UIWebView) {
        self.type = type
        //self.webView = webView
        super.init()
        
        switch type {
        case .horizontal:
            setupHorizontalCard()
        case .vertical:
            setupVerticalCard()
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("Business Card Coder Not Implemented") }
    
    deinit {
        self.removePeriodicTimeObserver()
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
    }
    
    func flushFromMemory(){

        debugPrint("Cleaning Business Card")

        DispatchQueue.main.async { [weak self] in
            self?.webView?.stopLoading()
            self?.webView = nil
        }

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
    
    func loadRequest(_request request: URLRequest) {
        DispatchQueue.main.async { [weak self] in
            self?.webView?.loadRequest(request)
        }
    }
    
    func playTheTemplateVideoFromTheBegining () {
        self.videoPlayer?.seek(to: CMTime.zero)
        self.videoPlayer?.play()
    }
    
    func continuePlayingTheTemplateVideo () {
        self.videoPlayer?.play()
    }
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods
    
    fileprivate func setupHorizontalCard () {
        guard   let template = SCNScene(named: CardType.horizontal.sceneName() ),
            let cardRoot = template.rootNode.childNode(withName: "RootNode", recursively: false),
            let target = cardRoot.childNode(withName: "BusinessCardTarget", recursively: false),
            let caseStudiesNode = target.childNode(withName: "CaseStudies", recursively: false),
            let linkNode = target.childNode(withName: "LinkNode", recursively: false),
            let buttonLinkedin = target.childNode(withName: "button_linkedin", recursively: true),
            let buttonFacebook = target.childNode(withName: "button_facebook", recursively: true),
            let buttonTwitter = target.childNode(withName: "button_twitter", recursively: true),
            let buttonInstagram = target.childNode(withName: "button_instagram", recursively: true),
            let webNode = target.childNode(withName: "web", recursively: false),
            let occlusionCardNode = cardRoot.childNode(withName: "OcclusionCardNode", recursively: false),
            let occlusionWebNode = cardRoot.childNode(withName: "OcclusionWebNode", recursively: true),
            let videoPlane = target.childNode(withName: "VideoPlane", recursively: false)
            else { fatalError("Error Getting Business Card Node Data") }
        
        // target template init
        DispatchQueue.main.async { [weak self] in
            
            //4. Create Our Video Player
            if let videoURL = Bundle.main.url(forResource: "Logo", withExtension: "mp4"){
                self?.setupVideoOnNode(videoPlane, fromURL: videoURL)
            }
            
            self?.addPeriodicTimeObserver()
        }
        
        target.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        
        caseStudiesNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Case studies.png")
        linkNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Link Square")
        
        // web init
        DispatchQueue.main.async { [weak self] in
            self?.webView = self?.createWebView()
            webNode.geometry?.firstMaterial?.diffuse.contents = self?.webView
        }
        
        // social link buttons
        buttonLinkedin.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Linkedin")
        buttonFacebook.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Facebook")
        buttonTwitter.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Twitter")
        buttonInstagram.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Instagram")
        
        // occlusion
        occlusionCardNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        occlusionCardNode.renderingOrder = -1
        occlusionWebNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        occlusionWebNode.renderingOrder = -1
        
        self.addChildNode(cardRoot)
        self.eulerAngles.x = -.pi / 2
    }
    
    fileprivate func setupVerticalCard () {
        
        guard   let template = SCNScene(named: CardType.vertical.sceneName() ),
            let cardRoot = template.rootNode.childNode(withName: "RootNode", recursively: false),
            let target = cardRoot.childNode(withName: "BusinessCardTarget", recursively: false),
            let caseStudiesNode = target.childNode(withName: "CaseStudies", recursively: false),
            let linkNode = target.childNode(withName: "LinkNode", recursively: false),
            let buttonLinkedin = target.childNode(withName: "button_linkedin", recursively: true),
            let buttonFacebook = target.childNode(withName: "button_facebook", recursively: true),
            let buttonTwitter = target.childNode(withName: "button_twitter", recursively: true),
            let buttonInstagram = target.childNode(withName: "button_instagram", recursively: true),
            let webNode = target.childNode(withName: "web", recursively: false),
            let occlusionCardNode = cardRoot.childNode(withName: "OcclusionCardNode", recursively: false),
            let occlusionWebNode = cardRoot.childNode(withName: "OcclusionWebNode", recursively: true)
            else { fatalError("Error Getting Business Card Node Data") }
        
        target.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        
        caseStudiesNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Case studies.png")
        linkNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Link Square")
        
        // web init
        DispatchQueue.main.async { [weak self] in
            self?.webView = self?.createWebView()
            webNode.geometry?.firstMaterial?.diffuse.contents = self?.webView
        }
        
        // social link buttons
        buttonLinkedin.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Linkedin")
        buttonFacebook.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Facebook")
        buttonTwitter.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Twitter")
        buttonInstagram.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Instagram")
        
        // occlusion
        occlusionCardNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        occlusionCardNode.renderingOrder = -1
        occlusionWebNode.geometry?.firstMaterial?.colorBufferWriteMask = .alpha
        occlusionWebNode.renderingOrder = -1
        
        self.addChildNode(cardRoot)
        self.eulerAngles.x = -.pi / 2
    }
    
    fileprivate func setupVideoOnNode(_ node: SCNNode, fromURL url: URL){
        
        //1. Create An SKVideoNode
        var videoPlayerNode: SKVideoNode!
        
        //2. Create An AVPlayer With Our Video URL
        let videoPlayer = AVPlayer(url: url)
        self.videoPlayer = videoPlayer
        
        //3. Intialize The Video Node With Our Video Player
        videoPlayerNode = SKVideoNode(avPlayer: videoPlayer)
        videoPlayerNode.yScale = -1
        
        //4. Create A SpriteKitScene & Postion It
        let spriteKitScene = SKScene(size: CGSize(width: 600, height: 300))
        spriteKitScene.scaleMode = .aspectFit
        videoPlayerNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoPlayerNode.size = spriteKitScene.size
        spriteKitScene.addChild(videoPlayerNode)
        spriteKitScene.backgroundColor = .clear
        
        //6. Set The Nodes Geoemtry Diffuse Contenets To Our SpriteKit Scene
        node.geometry?.firstMaterial?.diffuse.contents = spriteKitScene
        
        //5. Play The Video
        videoPlayer.volume = 0
    }
    
    fileprivate enum CriticalsPointsVideo {
        case first
        case second
        case unknow
        
        func criticalPoint () -> CGPoint {
            switch self {
            case .first:
                return CGPoint.init(x: 9, y: 10)
            case .second:
                return CGPoint.init(x: 24, y: 25)
            case .unknow:
                return CGPoint.init(x: 0, y: 0)
            }
        }
    }
    
    fileprivate func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        self.currentCriticalPoint = .first
        
        self.timeObserverToken = self.videoPlayer?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            
            guard let criticalPoint = self?.currentCriticalPoint, criticalPoint != .unknow else { return }

            if time.seconds > criticalPoint.criticalPoint().x.double && time.seconds < criticalPoint.criticalPoint().y.double {
                self?.videoPlayer?.pause()
                self?.currentCriticalPoint = criticalPoint == .first ? .second : .first
            }
        }
        
        // Run loop video
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
    }
    
    
    fileprivate func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            self.videoPlayer?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    fileprivate func createWebView () -> UIWebView {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 770))
        let request = URLRequest(url: URL(string: "https://incode-group.com/about")!)
        webView.loadRequest(request)
        return webView
    }
}

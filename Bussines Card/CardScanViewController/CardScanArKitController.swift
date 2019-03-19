//
//  CardScanArKitController.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

enum IncodeLinkButton: String {
    case button_pillboxed
    case button_glustory
    case button_cryptonymous
    case button_insake
    case button_linkedin
    case button_facebook
    case button_twitter
    case button_instagram
}

protocol CardScanArKitControllerDelegate: NSObjectProtocol {
    
}

protocol CardScanArKitControllerProtocol: NSObjectProtocol {
    var sceneView: ARSCNView {get set}
    var delegate: CardScanArKitControllerDelegate? {get set}
    
    func setupARSession()
    func pauseSession()
    func touchOccurred(nodeName: String)
}

class CardScanArKitController: NSObject, CardScanArKitControllerProtocol {
    
    
    
    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    var sceneView: ARSCNView
   
    weak var delegate: CardScanArKitControllerDelegate?
    
    weak var cardScanController: CardScanControllerProtocol?
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods
    
    fileprivate let session = ARSession()
    fileprivate let configuration = ARImageTrackingConfiguration()
    fileprivate let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")
    fileprivate var bussinesCard: BusinessCard?
    
    fileprivate var targetAnchor: ARImageAnchor?
    fileprivate var businessCardPlaced = false
    fileprivate var menuShown = false
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        sceneView.delegate = self
    }
    
    deinit {
        bussinesCard?.flushFromMemory()
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    func setupARSession () {
        
        //1. Setup Our Tracking Images
        guard let trackingImages =  ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        
        //2. Configure & Run Our ARSession
        sceneView.session = session
        session.delegate = self
        sceneView.delegate = self
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        updateQueue.async { [weak self] in
            if let employee = self?.cardScanController?.employee {
                self?.bussinesCard = BusinessCard(employee: employee)
            }
        }
    }
    
    func pauseSession() {
        session.pause()
    }
    
    func touchOccurred(nodeName: String) {
        debugPrint("Touched node name - \(nodeName)")
        var urlString: String?
        
        switch nodeName {
            case IncodeLinkButton.button_linkedin.rawValue:
            urlString = "https://www.linkedin.com/company/incode-group"
            case IncodeLinkButton.button_facebook.rawValue:
            urlString = "https://www.facebook.com/incode.group/"
            case IncodeLinkButton.button_twitter.rawValue:
            urlString = "https://twitter.com/incode_group"
            case IncodeLinkButton.button_instagram.rawValue:
            urlString = "https://www.instagram.com/incode_group/"
        case IncodeLinkButton.button_pillboxed.rawValue:
            urlString = "http://www.pillbox.org.uk/"
            case IncodeLinkButton.button_glustory.rawValue:
            urlString = "http://www.guyslikeus.org/"
        case IncodeLinkButton.button_cryptonymous.rawValue:
            urlString = "https://www.collinsdictionary.com/dictionary/english/cryptonymous"
            case IncodeLinkButton.button_insake.rawValue:
            urlString = "https://www.behance.net/gallery/74581481/Insake"
        default:
            break
        }
        
        if let url = urlString {
            let request = URLRequest(url: URL(string: url)!)
            bussinesCard?.loadRequest(_request: request)
        }
    }
    
}

extension CardScanArKitController: ARSCNViewDelegate {
    
    /// Variable Declaration(s)
    var imageHighlightAction: SCNAction {
        return .sequence([
            .wait(duration: 0.15),
            .fadeOpacity(to: 0.55, duration: 0.15),
            .fadeOpacity(to: 0.15, duration: 0.15),
            .fadeOut(duration: 0.2),
            .removeFromParentNode()
            ])
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        updateQueue.async { [weak self] in
            guard let self = self else { return }
            let physicalWidth = imageAnchor.referenceImage.physicalSize.width
            let physicalHeight = imageAnchor.referenceImage.physicalSize.height
            
            let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)

            // Add the plane visualization to the scene
            let imageHightingAnimationNode = SCNNode(geometry: mainPlane)
            imageHightingAnimationNode.eulerAngles.x = -.pi / 2
            imageHightingAnimationNode.opacity = 0.25
            node.addChildNode(imageHightingAnimationNode)
            
            imageHightingAnimationNode.runAction(self.imageHighlightAction) { [weak self] in
                
                guard let businessCard = self?.bussinesCard else { return }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    node.addChildNode(businessCard)
                })
                
            }
        }
    }
    
}

extension CardScanArKitController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        if menuShown { return }
        
        for anchor in anchors{
            
            if let imageAnchor = anchor as? ARImageAnchor, imageAnchor == targetAnchor{
                
                if !imageAnchor.isTracked{
                    debugPrint("f The ImageAnchor Is No Longer Tracked Then Reset The Business Card")
                    setupARSession()
                    businessCardPlaced = false
                    
                }else{
                    
                    //3. Layout The Card Again
                    if !businessCardPlaced {
                        debugPrint("Layout The Card Again")
                        businessCardPlaced = true
                    }
                }
            }
        }
    }
    
}

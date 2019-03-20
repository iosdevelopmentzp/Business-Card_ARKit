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
    
    func setupARSession(webView: UIWebView)
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
    
    fileprivate var bussinesCardVetical: BusinessCard?
    fileprivate var bussinesCardHorizontal: BusinessCard?
    fileprivate var currentType: CardType?
    fileprivate var verticalCardFirstAppear: Bool = true
    fileprivate var horizontalCardFirstAppear: Bool = true
    fileprivate var cardShow: Bool = false

    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        sceneView.delegate = self
    }
    
    deinit {
        bussinesCardVetical?.flushFromMemory()
        bussinesCardHorizontal?.flushFromMemory()
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    func setupARSession (webView: UIWebView) {
        
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
            
            self?.bussinesCardVetical = BusinessCard(type: .vertical)
            self?.bussinesCardHorizontal = BusinessCard(type: .horizontal)
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
            urlString = "https://incode-group.com/blockchain-healthcare-industry-project"
            case IncodeLinkButton.button_glustory.rawValue:
            urlString = "https://incode-group.com/project-clustory"
        case IncodeLinkButton.button_cryptonymous.rawValue:
            urlString = "https://incode-group.com/crypto-exchange-platform-cryptonymous"
            case IncodeLinkButton.button_insake.rawValue:
            urlString = "https://incode-group.com/iot-marketplace-insake"
        default:
            break
        }
        
        guard let currentType = currentType else { return }
        
        if let url = urlString {
            let request = URLRequest(url: URL(string: url)!)
           
            switch currentType {
            case .vertical:
                bussinesCardVetical?.loadRequest(_request: request)
            case .horizontal:
                bussinesCardHorizontal?.loadRequest(_request: request)
            }  
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
            
            guard let imageName = imageAnchor.referenceImage.name else { return }
            
            
            let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
            
            var businessCard: BusinessCard?
            var type: CardType?
            switch imageName {
            case _ where imageName.hasPrefix("incode_horizontal"):
                businessCard = self.bussinesCardHorizontal
                type = .horizontal
            case _ where imageName.hasPrefix("incode_vertical"):
                businessCard = self.bussinesCardVetical
                type = .vertical
            default: break
            }
            
            guard let card = businessCard, let currentType = type
                else { return }
            
            switch currentType {
            case .horizontal:
                if !self.horizontalCardFirstAppear {
                    node.addChildNode(card)
                    return
                } else { self.horizontalCardFirstAppear = false}
            case .vertical:
                if !self.verticalCardFirstAppear {
                    node.addChildNode(card)
                    return
                } else { self.verticalCardFirstAppear = false }
            }
            
            // Add the plane visualization to the scene
            let imageHightingAnimationNode = SCNNode(geometry: mainPlane)
            imageHightingAnimationNode.eulerAngles.x = -.pi / 2
            imageHightingAnimationNode.opacity = 0.25
            node.addChildNode(imageHightingAnimationNode)
            
            imageHightingAnimationNode.runAction(self.imageHighlightAction) { [weak self] in
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
                    node.addChildNode(card)
                })

            }
        }
    }
    
}

extension CardScanArKitController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors{
            
            if let imageAnchor = anchor as? ARImageAnchor{
                
                guard let nameImage = imageAnchor.referenceImage.name else { return }
                
                guard imageAnchor.isTracked else {
                    cardShow = false
                    currentType = nil
                    return
                }
                
                cardShow = true
                
                switch nameImage {
                case _ where nameImage.hasPrefix("incode_horizontal"):
                    currentType = .horizontal
                case _ where nameImage.hasPrefix("incode_vertical"):
                    currentType = .vertical
                default: break
                }
               
                
            }
        }
    }
    
}


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
    
    func link () -> String {
        
        switch self {
        case .button_linkedin:
            return "https://www.linkedin.com/company/incode-group"
        case .button_facebook:
            return "https://www.facebook.com/incode.group/"
        case .button_twitter:
            return "https://twitter.com/incode_group"
        case .button_instagram:
            return "https://www.instagram.com/incode_group/"
        case .button_pillboxed:
            return "https://incode-group.com/blockchain-healthcare-industry-project"
        case .button_glustory:
            return "https://incode-group.com/project-clustory"
        case .button_cryptonymous:
            return "https://incode-group.com/crypto-exchange-platform-cryptonymous"
        case .button_insake:
            return "https://incode-group.com/iot-marketplace-insake"
        }
    }
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
    
    enum TypeCard: String {
        case horizontalFaceSide = "incode_horizontal_face_side"
        case horizontalFlipSideKravchenko = "incode_horizontal_flip_side_kravchenko"
        case horizontalFlipSideGrebenataya = "incode_horizontal_flip_side_grebenataya"
        case verticalMeleshko = "incode_vertical_meleshko"
        case verticalGerasymenko = "incode_vertical_gerasymenko"
        case unknow = ""
    }
    
    
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
    

    fileprivate var bussinesCardHorizontalFaceSide: BusinessCard?
    fileprivate var bussinesCardHorizontalFlipSide: BusinessCard?
    fileprivate var bussinesCardVertical: BusinessCard?
    
    fileprivate var nodesStorage: Dictionary<TypeCard, SCNNode> = [:]
    
    fileprivate var currentType: TypeCard = .unknow
    
    
    fileprivate var verticalCardFirstAppear: Bool = true
    fileprivate var horizontalCardFirstAppear: Bool = true

    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        super.init()
        sceneView.delegate = self
    }
    
    deinit {
        bussinesCardHorizontalFaceSide?.flushFromMemory()
        bussinesCardHorizontalFlipSide?.flushFromMemory()
        bussinesCardVertical?.flushFromMemory()
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
            self?.bussinesCardHorizontalFaceSide = BusinessCard(type: .horizontal)
            self?.bussinesCardHorizontalFlipSide = BusinessCard(type: .horizontal)
            self?.bussinesCardVertical = BusinessCard(type: .vertical)
        }
    }
    
    func pauseSession() {
        session.pause()
    }
    
    func touchOccurred(nodeName: String) {
        
        if nodeName == "VideoPlane" {
            
            switch currentType {
            case .horizontalFaceSide:
                bussinesCardHorizontalFaceSide?.continuePlayingTheTemplateVideo()
            case .horizontalFlipSideKravchenko, .horizontalFlipSideGrebenataya:
                bussinesCardHorizontalFlipSide?.continuePlayingTheTemplateVideo()
            case .verticalMeleshko, .verticalGerasymenko:
                bussinesCardVertical?.continuePlayingTheTemplateVideo()
            case .unknow:
                return
            }
            
            return
        }
        
        
        guard let linkButton = IncodeLinkButton(rawValue: nodeName) else { return }
        
        let url = URL(string: linkButton.link())!
        let request = URLRequest(url: url)
        
        
        // if social links open in native browser
        switch linkButton {
        case .button_facebook, .button_instagram, .button_linkedin, .button_twitter:
            cardScanController?.loadUrl(url)
            return
        default:
            break
        }
        
        // if other links open in ArKit browser
        switch currentType {
        case .horizontalFaceSide:
            bussinesCardHorizontalFaceSide?.loadRequest(_request: request)
        case .horizontalFlipSideKravchenko, .horizontalFlipSideGrebenataya:
            bussinesCardHorizontalFlipSide?.loadRequest(_request: request)
        case .verticalMeleshko, .verticalGerasymenko:
            bussinesCardVertical?.loadRequest(_request: request)
        case .unknow:
            return
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
            
            self.currentType = TypeCard(rawValue: imageName) ?? .unknow
            
            var businessCard: BusinessCard?
            
            switch self.currentType {
            case .horizontalFaceSide :
                businessCard = self.bussinesCardHorizontalFaceSide
            case .horizontalFlipSideKravchenko, .horizontalFlipSideGrebenataya:
                businessCard = self.bussinesCardHorizontalFlipSide
            case .verticalMeleshko, .verticalGerasymenko:
                businessCard = self.bussinesCardVertical
            case .unknow:
                return
            }
            
            guard let card = businessCard else { return }
            
            // Add the plane visualization to the scene
            let imageHightingAnimationNode = SCNNode(geometry: mainPlane)
            imageHightingAnimationNode.eulerAngles.x = -.pi / 2
            imageHightingAnimationNode.opacity = 0.25
            node.addChildNode(imageHightingAnimationNode)
            
            node.addChildNode(card)
            
            //save node
            self.nodesStorage[self.currentType] = node;
            
            imageHightingAnimationNode.runAction(self.imageHighlightAction) {
                if card.type == .horizontal {
                    card.playTheTemplateVideoFromTheBegining()
                }
            }
        }
    }
}

extension CardScanArKitController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors{
            
            if let imageAnchor = anchor as? ARImageAnchor{
                
                guard let imageName = imageAnchor.referenceImage.name else { return }
                
                guard imageAnchor.isTracked else {
                    currentType = .unknow
                    return
                }
                
                self.currentType = TypeCard(rawValue: imageName) ?? .unknow
                
                var businessCard: BusinessCard?
                
                switch self.currentType {
                case .horizontalFaceSide :
                    businessCard = self.bussinesCardHorizontalFaceSide
                case .horizontalFlipSideKravchenko, .horizontalFlipSideGrebenataya:
                    businessCard = self.bussinesCardHorizontalFlipSide
                case .verticalMeleshko, .verticalGerasymenko:
                    businessCard = self.bussinesCardVertical
                case .unknow:
                    return
                }
                
                guard let card = businessCard, let node = nodesStorage[self.currentType] else { return }
                node.addChildNode(card)
            }
        }
    }
    
}

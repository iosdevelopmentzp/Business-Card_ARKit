//
//  ViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/11/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARSceneViewController: UIViewController {

    @IBOutlet weak var augmentedRealityView: ARSCNView!
    
    let augmentedRealitySession = ARSession()
    let configuration = ARImageTrackingConfiguration()
    var targetAnchor: ARImageAnchor?
    
    var businessCardPlaced = false
    
    var menuShown = false
    
    var webView: UIWebView = {
        let request = URLRequest(url: URL(string: "https://www.zolotoyvek.ua/ru/")!)
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 672))
        webView.loadRequest(request)
        return webView
    }()
    
    var hideButtonNode: SCNNode?
    var infoButtonNode: SCNNode?
    var cardOcclusionNode: SCNNode?
    var textNode: SCNNode?
    var videoNode: SCNNode?
    var mainNode: SCNNode?
    var widthCard: CGFloat?
    var heightCard: CGFloat?
    var webViewNode: SCNNode?
    var webIsHide: Bool = true{
        didSet {
            if webIsHide {
                 hideWebInfo()
            } else {
               showWebInfo()
            }
        }
    }
    
    // CONSTANTS
    static let buttonInfoName = "BUTTON INFO"
    static let buttonInfoHide = "BUTTON INFO HIDE"
    static let heightNameLabelCoephysient: CGFloat = 0.4
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        augmentedRealityView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        augmentedRealityView.session.run(configuration)
        augmentedRealityView.automaticallyUpdatesLighting = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !menuShown { setupARSession() }
    }
    
    func setupARSession() {
        
        //1. Setup Our Tracking Images
        guard let trackingImages =  ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = trackingImages
        configuration.maximumNumberOfTrackedImages = 1
        
        //2. Configure & Run Our ARSession
        augmentedRealityView.session = augmentedRealitySession
        augmentedRealitySession.delegate = self
        augmentedRealityView.delegate = self
        augmentedRealitySession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
}


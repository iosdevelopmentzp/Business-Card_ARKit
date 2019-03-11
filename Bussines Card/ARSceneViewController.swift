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
    var businessCard: BusinessCard!
    var socialLinkData: SocialLinkData?
    
    var menuShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        augmentedRealityView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        augmentedRealityView.session.run(configuration)
        augmentedRealityView.automaticallyUpdatesLighting = true
        
         setupBusinessCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !menuShown { setupARSession() }
        socialLinkData = nil
    }
    
    fileprivate func setupARSession() {
        
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
    
    /// Create A Business Card
    func setupBusinessCard(){
        
        //1. Create Our Business Card
        let businessCardData = BusinessCardData(firstName: "Josh",
                                                surname: "Robbins",
                                                position: "Software Engineer",
                                                company: "BlackMirrorz",
                                                address: BusinessAddress(street: "1 Infinite Loop",
                                                                         city: "Cupertino", state: "CA", postalCode: "95015",
                                                                         coordinates: (latittude: 37.3349, longtitude: -122.0090201)),
                                                website: SocialLinkData(link: "https://www.blackmirrorz.tech", type: .Website),
                                                phoneNumber: "+821049550384",
                                                email: "josh.robbins@blackmirroz.tech",
                                                stackOverflowAccount: SocialLinkData(link: "https://stackoverflow.com/users/8816868/josh-robbins", type: .StackOverFlow),
                                                githubAccount: SocialLinkData(link: "https://github.com/BlackMirrorz", type: .GitHub))
        
        //2. Assign It To The Business Card Node
        businessCard = BusinessCard(data: businessCardData, cardType: .noProfileImage)
        
    }
    
    
    


}


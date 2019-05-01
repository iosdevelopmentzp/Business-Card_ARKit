//
//  CardScanViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class CardScanViewController: UIViewController {

    
    
    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var templateView: UIView!
    
    @IBOutlet fileprivate var videoPlayerView: AVPlayerView!
    
    fileprivate lazy var arKitScanController: CardScanArKitController = CardScanArKitController(sceneView: sceneView)
    
    fileprivate lazy var scanController: CardScanControllerProtocol? = getScanController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        scanController?.startScan()
    }
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        scanController?.arKitController = arKitScanController
        arKitScanController.cardScanController = scanController
        
        scanController?.startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        scanController?.pauseScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.templateView.alpha = 0.0
        }) { [weak self] (_) in
            self?.templateView.removeFromSuperview()
        }
    }
    
    fileprivate func getScanController() -> CardScanController {
        let controller = CardScanController()
        controller.viewController = self
        return controller
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    
    func loadUrl(_ url: URL) {
        guard let pulleyController = pulleyViewController as? BrowserProtocol
            else { return }
        
        pulleyController.loadUrl(url: url)
    }
    
    func setupARSession () {
        arKitScanController.setupARSession()
    }
    
    // U S E R  I N T E R A C T I O N
    // MARK: - User Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView),
            let hitTestResultName = self.sceneView.hitTest(currentTouchLocation, options: nil).first?.node.name
            else { return }
        
        arKitScanController.touchOccurred(nodeName: hitTestResultName)
    }
}

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

    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    var scanController: CardScanControllerProtocol?
    
    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    
    fileprivate lazy var arKitScanController: CardScanArKitController = CardScanArKitController(sceneView: sceneView)

    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanController?.arKitController = arKitScanController
        arKitScanController.cardScanController = scanController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scanController?.startScan()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        scanController?.pauseScan()
    }
}

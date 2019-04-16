//
//  CardScanController.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

protocol CardScanControllerProtocol: NSObjectProtocol {
    var arKitController: CardScanArKitControllerProtocol? {get set}
    
    func startScan()
    func pauseScan()
    func touchOccurred(nodeName: String)
    func loadUrl(_ url: URL)
}

class CardScanController: NSObject, CardScanControllerProtocol {
 
    
    
    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    
    var arKitController: CardScanArKitControllerProtocol?
    var viewController: CardScanViewController?
    
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    
    func startScan() {
        arKitController?.setupARSession()
    }
    
    func pauseScan() {
        arKitController?.pauseSession()
    }
    
    func touchOccurred(nodeName: String) {
        arKitController?.touchOccurred(nodeName: nodeName)
    }
    
    func loadUrl(_ url: URL) {
        viewController?.loadUrl(url)
    }
}

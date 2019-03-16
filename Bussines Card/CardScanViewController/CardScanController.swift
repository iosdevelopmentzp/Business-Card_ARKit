//
//  CardScanController.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

protocol CardScanControllerProtocol: NSObjectProtocol {
    var employee: Employee {get }
    var webView: UIWebView {get}
    var arKitController: CardScanArKitControllerProtocol? {get set}
    
    func startScan()
    func pauseScan()
}

class CardScanController: NSObject, CardScanControllerProtocol {
    
    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    
    var arKitController: CardScanArKitControllerProtocol?
    
    var employee: Employee {
        didSet {
            guard let jobLink = employee.jobLink,
                let url = URL(string: jobLink)  else { return }
            
            let request = URLRequest(url: url )
            webView.loadRequest(request)
        }
    }
    
    fileprivate(set) lazy var webView: UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 672))
    

    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(employee: Employee) {
        self.employee = employee
        super.init()
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    
    func startScan() {
        arKitController?.setupARSession()
    }
    
    func pauseScan() {
        arKitController?.pauseSession()
    }
}

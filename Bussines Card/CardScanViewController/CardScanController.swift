//
//  CardScanController.swift
//  Bussines Card
//
//  Created by Imac on 3/15/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

protocol CardScanControllerProtocol: NSObjectProtocol {
    
    var viewController: CardScanViewController? {get set}
    var employee: Employee? {get }
    var webView: UIWebView {get}
    var arKitController: CardScanArKitControllerProtocol? {get set}
    
    func startScan()
    func pauseScan()
    func touchOccurred(nodeName: String)
}

class CardScanController: NSObject, CardScanControllerProtocol {
 
    
    
    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    
    var viewController: CardScanViewController?
    
    var arKitController: CardScanArKitControllerProtocol?
    
    var employee: Employee? {
        didSet {
            guard let jobLink = employee?.jobLink,
                let url = URL(string: jobLink)  else { return }
            
            //let request = URLRequest(url: url )
            //webView.loadRequest(request)
        }
    }
    
    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    
    fileprivate var isFirstTouch: Bool = true
    
    fileprivate(set) var webView: UIWebView

    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    init(employee: Employee?, webView: UIWebView) {
        self.webView = webView
        self.employee = employee
        super.init()
    }

    
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    
    func startScan() {
        arKitController?.setupARSession(webView: webView)
    }
    
    func pauseScan() {
        arKitController?.pauseSession()
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
            if isFirstTouch {
                urlString = "https://incode-group.com/"
                isFirstTouch = false
            }
        }
        
        if let urlString = urlString, let url = URL(string: urlString)  {
            viewController?.loadRequest(url: url)
        }
    }
}

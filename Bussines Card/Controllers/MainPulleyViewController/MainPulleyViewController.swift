//
//  MainPulleyViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/29/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import Pulley
import SafariServices

protocol BrowserProtocol: NSObjectProtocol {
    func loadUrl(url: URL)
}

class MainPulleyViewController: PulleyViewController, BrowserProtocol {
    
    
    
    weak var safariViewController: SFSafariViewController? {
        didSet {
            guard let safariViewController = safariViewController else { return }
            
            setDrawerContentViewController(controller: safariViewController)
        }
    }
    
    override func viewDidLoad() {
        
    }
    
    func loadUrl(url: URL) {
        
        DispatchQueue.main.async { [weak self] in
            let safariVC = SFSafariViewController(url: url)
            self?.safariViewController = safariVC
            safariVC.delegate = self
            safariVC.additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
            self?.setDrawerPosition(position: .open, animated: true)
        }
        
        
    }
    
    // drawer protocol
    
    override func supportedDrawerPositions() -> [PulleyPosition] {
        return [.closed, .open]
    }
}

extension MainPulleyViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        setDrawerPosition(position: .closed, animated: true)
    }
}

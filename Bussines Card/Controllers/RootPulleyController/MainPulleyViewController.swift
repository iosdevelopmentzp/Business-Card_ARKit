//
//  MainPulleyViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/29/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
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
        super.viewDidLoad()
        
        setDrawerPosition(position: .closed, animated: false)
        view.backgroundColor = #colorLiteral(red: 0.09019607843, green: 0.1137254902, blue: 0.1490196078, alpha: 1)
        view.subviews.forEach{$0.isHidden = true}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] (_) in
            self?.view.subviews.forEach{$0.isHidden = false}
        }
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

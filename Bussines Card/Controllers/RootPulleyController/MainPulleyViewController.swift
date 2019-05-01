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
    
    weak var safariViewController: SafariViewController? {
        didSet {
            guard let safariViewController = safariViewController else { return }
            safariViewController.delegate = self
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
            self?.safariViewController?.loadUrl(url: url)
            self?.setDrawerPosition(position: .open, animated: true)
        }
    }
    
    // drawer protocol
    

    override func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        
        guard drawer.drawerPosition != .open, drawer.drawerPosition != .closed  else { return }
        setDrawerPosition(position: .closed, animated: true)
    }
    
    override func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        
        if distance == 0 {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] (_) in
                self?.safariViewController?.removeSafariViewControllerFromSuperView()
            }
        }
    }
}

extension MainPulleyViewController: SafariViewControllerProtocol {
    func safariDidFinish(controller: SafariViewController) {
        setDrawerPosition(position: .closed, animated: true)
    }
}

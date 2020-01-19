//
//  SafariViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/29/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import SafariServices

protocol SafariViewControllerProtocol: NSObjectProtocol {
    func safariDidFinish(controller: SafariViewController)
}

class SafariViewController: UIViewController, BrowserProtocol {

    var delegate: SafariViewControllerProtocol?
    
    fileprivate var safariViewController: SFSafariViewController?
    
    @IBOutlet weak var safariContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("Safari deinited")
    }

    func loadUrl(url: URL) {
        
        additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        removeSafariViewControllerFromSuperView()
        self.safariViewController = loadSafariViewController(url: url)
    }
    
    func removeSafariViewControllerFromSuperView () {
        guard let safariVC = safariViewController else {
            return
        }
        safariVC.willMove(toParent: nil)
        safariVC.view.removeFromSuperview()
        safariVC.removeFromParent()
        safariViewController = nil
    }
    
    fileprivate func loadSafariViewController (url: URL) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.delegate = self
        addChild(controller)
        safariContentView.addSubview(controller.view)
        controller.view.constrainToParent()
        controller.didMove(toParent: self)
        
        if self.isViewLoaded {
            self.view.setNeedsLayout()
        }
        return controller
    }
}

extension SafariViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        delegate?.safariDidFinish(controller: self)
    }
}

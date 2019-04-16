//
//  SafariViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/29/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: UIViewController {

    var safariController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        let urlString = "https://incode-group.com/"
//        let url = URL(string: urlString)!
//        let configuration = SFSafariViewController.Configuration()
//        configuration.barCollapsingEnabled = false
//        let safariVC = SFSafariViewController(url: url, configuration: configuration)
//        safariVC.additionalSafeAreaInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
//        addChild(safariVC)
//
//        view.addSubview(safariVC.view)
//
//        safariVC.view.translatesAutoresizingMaskIntoConstraints = false
//
//        self.view.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            safariVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            safariVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            safariVC.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            safariVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
//            ])
//
//        safariVC.didMove(toParent: self)
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler(gesture:)) )
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func panHandler (gesture: UIPanGestureRecognizer) {
        debugPrint("Boooo")
    }

}

extension SafariViewController: UIGestureRecognizerDelegate {
    
}

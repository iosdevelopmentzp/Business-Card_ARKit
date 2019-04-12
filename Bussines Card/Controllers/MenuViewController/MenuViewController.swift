//
//  MenuViewController.swift
//  Bussines Card
//
//  Created by Imac on 4/4/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit
import APNGKit


class MenuViewController: UIViewController {

    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    
    @IBOutlet  weak var animateView: APNGImageView!
    @IBOutlet weak var labelImage: UIImageView!
    
    var scanViewController: UIViewController?
    
    
    struct Constants {
        static let backgroundColor = UIColor(named: "MenuViewController_background")
        static let startScaningButtonColor = UIColor(named: "MenuViewController_button")
        static let startScaningButtonTitleColors = UIColor(named: "MenuViewController_button_title")
        static let startButtonCornerRadius: CGFloat = 6.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        labelImage.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // U I
    //MARK: - UI
    
    fileprivate func setupUI () {
        
        view.backgroundColor = Constants.backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupVideoView()
        
        // Scan ViewController init
        let identifierVC = String(describing: CardScanViewController.self)
        let scanVC = UIStoryboard.init(name: identifierVC, bundle: nil).instantiateViewController(withIdentifier: identifierVC)
        self.scanViewController = scanVC
    }
    
    fileprivate func setupVideoView () {
        let recourcePath = Bundle.main.path(forResource: "Logo Animation Fast", ofType: "apng")!
        if let image = APNGImage(contentsOfFile: recourcePath, saveToCache: false, progressive: true) {
            
            animateView.image = image
            animateView.contentMode = .scaleAspectFit
            animateView.delegate = self
            animateView.startAnimating()
        }
    }
    
    fileprivate func pushCardScanController() {

        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.animateView.alpha = 0.0
            self?.labelImage.alpha = 0.0
        }) { [weak self] (_) in
            guard let scanViewController = self?.scanViewController else { return }
            self?.navigationController?.pushViewController(scanViewController, animated: false)
        }
        
    }
    
}

extension MenuViewController: APNGImageViewDelegate {
    func apngImageView(_ imageView: APNGImageView, didFinishPlaybackForRepeatedCount count: Int) {
        animateView.stopAnimating()
        pushCardScanController()
    }
}

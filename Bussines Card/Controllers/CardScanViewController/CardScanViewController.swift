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
import Pulley


class CardScanViewController: UIViewController {

    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var viewForVideo: UIView!
    @IBOutlet fileprivate weak var scanButton: UIButton!
    
    @IBOutlet fileprivate var videoPlayerView: AVPlayerView!
    
    fileprivate lazy var pulleyController: (PulleyControllerProtocol & PulleyDelegate & PulleyDrawerViewControllerDelegate) = CardScanPulleyController()
    
    fileprivate lazy var arKitScanController: CardScanArKitController = CardScanArKitController(sceneView: sceneView)
    
    fileprivate lazy var scanController: CardScanControllerProtocol? = getScanController()
    
    fileprivate lazy var safariController: SafariControllerProtocol? = CardScanSafariController()
    
    struct Constants {
        static let backgroundColor = UIColor(named: "CardScanViewController_background")
        static let startScaningButtonColor = UIColor(named: "CardScanViewController_button")
        static let startScaningButtonTitleColors = UIColor(named: "CardScanViewController_button_title")
        static let startButtonCornerRadius: CGFloat = 6.0
    }
    
    

    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pulleyViewController?.delegate = pulleyController
        
        scanController?.arKitController = arKitScanController
        arKitScanController.cardScanController = scanController
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scanController?.startScan()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
        videoPlayerView?.alpha = 0.0
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (_) in
            self.videoPlayerView?.alpha = 1.0
            self.videoPlayerView?.player?.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        scanController?.pauseScan()
    }
    
    fileprivate func getScanController() -> CardScanController {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 770))
        let request = URLRequest(url: URL(string: "https://incode-group.com/")!)
        webView.loadRequest(request)
        let controller = CardScanController(employee: nil, webView: webView)
        controller.viewController = self
        return controller
    }
    
    // U S E R  I N T E R A C T I O N
    // MARK: - User Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView) else { return }
        let hitTestResult = self.sceneView.hitTest(currentTouchLocation, options: nil).first?.node.name ?? ""
        
        
        scanController?.touchOccurred(nodeName: hitTestResult)
    }
    
    @IBAction func startScanAction(_ sender: UIButton) {
        
        videoPlayerView?.player?.pause()
        videoPlayerView?.removeFromSuperview()
        videoPlayerView = nil
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.viewForVideo.alpha = 0
            self?.scanButton.alpha = 0
        }
        
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    
    func loadRequest(url: URL) {
        guard let pulleyController = pulleyViewController as? BrowserProtocol
            else { return }
        
        pulleyController.loadUrl(url: url)
    }
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods

    // UI methods
    
    fileprivate func setupUI () {
        
        // scanButton setup
        scanButton.setTitleColor(Constants.startScaningButtonTitleColors, for: .normal)
        scanButton.backgroundColor = Constants.startScaningButtonColor
        
        scanButton.layer.cornerRadius = Constants.startButtonCornerRadius
        scanButton.layer.masksToBounds = false
        scanButton.layer.shadowColor = UIColor.gray.cgColor
        scanButton.layer.shadowOpacity = 0.3
        scanButton.layer.shadowRadius = 4
        scanButton.layer.shadowOffset = CGSize.init(width: 1, height: 3)

        // video setup
        viewForVideo.backgroundColor = Constants.backgroundColor
        setupVideoView()
    }
    
    
    fileprivate func setupVideoView() {
        
        let playerLayer: AVPlayerLayer = videoPlayerView.playerLayer
        playerLayer.pixelBufferAttributes = [ (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]

        let videoUrl: URL = Bundle.main.url(forResource: "Vertical - vertical duplication", withExtension: "mp4")!
        videoPlayerView.loadVideo(from: videoUrl) { [weak self] playerItem, error in
            guard let playerItem = playerItem, error == nil else {
                return print("Something went wrong when loading our video", error!)
            }
            
            playerItem.seekingWaitsForVideoCompositionRendering = true
            playerItem.videoComposition = self?.createVideoComposition(for: playerItem)
        }
    }
    
    fileprivate func createVideoComposition(for playerItem: AVPlayerItem) -> AVVideoComposition {
        let videoSize = CGSize(width: playerItem.presentationSize.width, height: playerItem.presentationSize.height / 2.0)
        let composition = AVMutableVideoComposition(asset: playerItem.asset, applyingCIFiltersWithHandler: { request in
            let sourceRect = CGRect(origin: .zero, size: videoSize)
            let alphaRect = sourceRect.offsetBy(dx: 0, dy: sourceRect.height)
            let filter = AlphaFrameFilter()
            filter.inputImage = request.sourceImage.cropped(to: alphaRect)
                .transformed(by: CGAffineTransform(translationX: 0, y: -sourceRect.height))
            filter.maskImage = request.sourceImage.cropped(to: sourceRect)
            return request.finish(with: filter.outputImage!, context: nil)
        })
        
        composition.renderSize = videoSize
        return composition
    }
    
}

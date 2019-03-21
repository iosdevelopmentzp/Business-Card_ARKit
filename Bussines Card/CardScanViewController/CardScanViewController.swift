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


class CardScanViewController: UIViewController {

    
    
    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var viewForVideo: UIView!
    @IBOutlet fileprivate weak var scanButton: UIButton!
    
    fileprivate var videoPlayer: AVPlayerView?
    
    fileprivate lazy var arKitScanController: CardScanArKitController = CardScanArKitController(sceneView: sceneView)
    
    fileprivate lazy var scanController: CardScanControllerProtocol? = {
            
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 500, height: 770))
            let request = URLRequest(url: URL(string: "https://incode-group.com/")!)
            webView.loadRequest(request)
        return CardScanController(employee: nil, webView: webView)
    }()

    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanController?.arKitController = arKitScanController
        arKitScanController.cardScanController = scanController
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scanController?.startScan()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        videoPlayer?.player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        scanController?.pauseScan()
    }
    
    // U S E R  I N T E R A C T I O N
    // MARK: - User Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let currentTouchLocation = touches.first?.location(in: self.sceneView),
            let hitTestResult = self.sceneView.hitTest(currentTouchLocation, options: nil).first?.node.name
            else { return }
        
        arKitScanController.touchOccurred(nodeName: hitTestResult)
    }
    
    @IBAction func startScanAction(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.viewForVideo.alpha = 0
            self?.scanButton.alpha = 0
        }
        
    }
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods
    
    fileprivate func setupUI () {
        setupVideoView()
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
    
    fileprivate func setupVideoView() {
        
        let videoSize = CGSize(width: 350, height: 350)
        let playerView = AVPlayerView(frame: CGRect(origin: .zero, size: videoSize))
        videoPlayer = playerView
        viewForVideo.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.widthAnchor.constraint(equalToConstant: videoSize.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: videoSize.height).isActive = true
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let playerLayer: AVPlayerLayer = playerView.playerLayer
        playerLayer.pixelBufferAttributes = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        
        viewForVideo.backgroundColor = .black
        
        let videoUrl: URL = Bundle.main.url(forResource: "Vertical - vertical duplication", withExtension: "mp4")!
        playerView.loadVideo(from: videoUrl) { [weak self] playerItem, error in
            guard let playerItem = playerItem, error == nil else {
                return print("Something went wrong when loading our video", error!)
            }
            
            playerItem.seekingWaitsForVideoCompositionRendering = true
            playerItem.videoComposition = self?.createVideoComposition(for: playerItem)
        }
    }
    
}

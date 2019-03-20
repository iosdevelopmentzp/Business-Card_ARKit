//
//  ChoiceEmployeeViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/14/19.
//  Copyright © 2019 idev. All rights reserved.
// https://www.designlisticle.com/list-ui-mobile-apps/

import UIKit
import AVFoundation

protocol ChoiceEmployeeControllerProtocol: NSObjectProtocol {
    var count: Int {get}
    var viewController: UIViewController? {get}
    
    func employee(indexPath: IndexPath) -> Employee?
    func dataForIndexPath(indexPath: IndexPath) -> EmployeeCellModel
}

class ChoiceEmployeeViewController: UIViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet fileprivate weak var scanButton: UIButton!
    @IBOutlet weak var viewForVideoView: UIView!
    
    
    fileprivate var videoPlayer: AVPlayerView?
    
    fileprivate lazy var controller: ChoiceEmployeeControllerProtocol = {
        return ChoiceEmployeeController(viewController: self)
    }()
    
    fileprivate var selectedIndexPath: IndexPath = IndexPath.init(row: 0, section: 0) {
        didSet {
            collectionView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    
    // C O N S T A N T S
    //MARK: - Constans
    let cellIdentifier = String(describing: EmployeeCollectionViewCell.self)
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        videoPlayer?.player?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPlayer?.player?.play()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        scanButton.alpha = 0.0
        
        UIView.animate(withDuration: 1.0, delay: 5.0, options: [], animations: {
            [weak self] in
            self?.scanButton.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func setupUI () {
        setupVideoView()
    }
    
    
        
    
    // U S E R  I N T E R A C T I O N
    // MARK: - User Interaction
    
    @IBAction func scanAction(_ sender: UIButton) {
        pushScanController()
    }
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods
    
    fileprivate func pushScanController () {
//        let storyboard = UIStoryboard(name: String(describing: CardScanViewController.self) , bundle: nil)
//        let scanVC = storyboard.instantiateViewController(withIdentifier: String(describing: CardScanViewController.self)) as!  CardScanViewController
//        
//        guard let employee = controller.employee(indexPath: selectedIndexPath) else { return }
//        
//        let scanController = CardScanController(employee: nil, webView: UIWebView() )
//        //scanVC.scanController = scanController
//        
//        let transition: CATransition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.fade
//        self.navigationController!.view.layer.add(transition, forKey: nil)
//        
//        navigationController?.pushViewController(scanVC, animated: false)
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
        viewForVideoView.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.widthAnchor.constraint(equalToConstant: videoSize.width).isActive = true
        playerView.heightAnchor.constraint(equalToConstant: videoSize.height).isActive = true
        playerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let playerLayer: AVPlayerLayer = playerView.playerLayer
        playerLayer.pixelBufferAttributes = [
            (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        
        viewForVideoView.backgroundColor = .black
        
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

// U I C O L L E C T I O N  V I E W  D A T A  S O U R C E
// Mark: - UICollectionViewDataSource
extension ChoiceEmployeeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! EmployeeCollectionViewCell
        cell.configure(model: controller.dataForIndexPath(indexPath: indexPath))
        cell.checkMark = indexPath == selectedIndexPath
        return cell
    }
    
    
}

// U I C O L L E C T I O N  V I E W    D E L E G A T E
// Mark: - UICollectionViewDelegate
extension ChoiceEmployeeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        
        collectionView.visibleCells.forEach{ ($0 as? EmployeeCollectionViewCell)?.checkMark = false }
        
        if let item = collectionView.cellForItem(at: indexPath) as? EmployeeCollectionViewCell {
            item.checkMark = true
            title = item.nameLabel.text
        }
    }
}

extension ChoiceEmployeeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        
        
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            return CGSize(width: width/2 + 10, height: width/2 + 10)
        default:
            return CGSize(width: width/2, height: width/2)
        }
    }
    
    
}

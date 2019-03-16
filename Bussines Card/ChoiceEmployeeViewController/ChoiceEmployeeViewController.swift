//
//  ChoiceEmployeeViewController.swift
//  Bussines Card
//
//  Created by Imac on 3/14/19.
//  Copyright © 2019 idev. All rights reserved.
// https://www.designlisticle.com/list-ui-mobile-apps/

import UIKit

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    fileprivate func setupUI () {

        // collection view
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.minimumInteritemSpacing = 10
        collectionLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        scanButton.layer.cornerRadius = 10.0
        scanButton.layer.borderWidth = 3.0
        scanButton.layer.borderColor = UIColor.init(red: 0, green: 220, blue: 0, alpha: 1).cgColor
    }
    
    // U S E R  I N T E R A C T I O N
    // MARK: - User Interaction
    
    @IBAction func scanAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: String(describing: CardScanViewController.self) , bundle: nil)
        let scanVC = storyboard.instantiateViewController(withIdentifier: String(describing: CardScanViewController.self)) as!  CardScanViewController
       
        guard let employee = controller.employee(indexPath: selectedIndexPath) else { return }
        
        let scanController = CardScanController(employee: employee)
        scanVC.scanController = scanController
        
        navigationController?.pushViewController(scanVC, animated: true)
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

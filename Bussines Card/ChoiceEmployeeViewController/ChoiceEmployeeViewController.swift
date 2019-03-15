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
    
    func dataForIndexPath(indexPath: IndexPath) -> EmployeeCellModel
}

class ChoiceEmployeeViewController: UIViewController {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var collectionLayout: UICollectionViewFlowLayout!
    
    lazy var controller: ChoiceEmployeeControllerProtocol = {
        return ChoiceEmployeeController(viewController: self)
    }()
    
    // C O N S T A N T S
    //MARK: - Constans
    let cellIdentifier = String(describing: EmployeeCollectionViewCell.self)
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    fileprivate func setupUI () {

        // collection view
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
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
        cell.checkMark = false
        return cell
    }
    
    
}

// U I C O L L E C T I O N  V I E W    D E L E G A T E
// Mark: - UICollectionViewDelegate
extension ChoiceEmployeeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.visibleCells.forEach{ ($0 as? EmployeeCollectionViewCell)?.checkMark = false }
        
        if let item = collectionView.cellForItem(at: indexPath) as? EmployeeCollectionViewCell {
            item.checkMark = true
        }
        
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}

extension ChoiceEmployeeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 20
        
        
        switch collectionView.indexPathsForSelectedItems?.first {
        case .some(indexPath):
            return CGSize(width: width/2 + 10, height: width/2 + 10)
        default:
    
            return CGSize(width: width/2, height: width/2)
        }
    }
    
    
}






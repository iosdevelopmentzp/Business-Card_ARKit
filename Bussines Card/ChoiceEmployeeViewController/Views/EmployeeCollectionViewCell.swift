//
//  EmployeeCollectionViewCell.swift
//  Bussines Card
//
//  Created by Imac on 3/14/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

protocol EmployeeCellModel {
    var avatar: UIImage? {get set}
    var name: String {get set}
    var checkMark: Bool {get set}
}

class EmployeeCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate(set) weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var checkMarkImage: UIImageView!
    @IBOutlet fileprivate weak var content: UIView!
    
    var checkMark: Bool = false {
        didSet {
            content.backgroundColor = checkMark ? UIColor.gray : UIColor.white
            checkMarkImage.isHidden = !checkMark
        }
    }


    func configure(model: EmployeeCellModel) {
        avatarImageView.image = model.avatar
        nameLabel.text = model.name
        checkMark = model.checkMark
        
        UIConfigure()
    }
    
    fileprivate func UIConfigure() {
        content.layer.cornerRadius = 4.0
        content.layer.masksToBounds = true
    }
}

struct EmployeeCellData: EmployeeCellModel {
    var avatar: UIImage?
    var name: String
    var checkMark: Bool = false
    
    init(avatar: UIImage?, name: String) {
        self.avatar = avatar
        self.name = name
    }
}

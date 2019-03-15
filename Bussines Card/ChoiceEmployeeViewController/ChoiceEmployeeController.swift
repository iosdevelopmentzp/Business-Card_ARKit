//
//  ChoiceEmployeeController.swift
//  Bussines Card
//
//  Created by Imac on 3/14/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit

class ChoiceEmployeeController: NSObject, ChoiceEmployeeControllerProtocol {
    
    
    // I N T E R N A L   P R O P E R T I E S
    // MARK: - Internal Properties
    var count: Int { return items.count }
    weak var viewController: UIViewController?
    
    
    // P R I V A T E   P R O P E R T I E S
    // MARK: - Private Properties
    fileprivate lazy var items: [Employee] = createEmployee()
    
    
    // L I F E   C Y C L E
    // MARK: - Life Cycle
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // I N T E R N A L   M E T H O D S
    // MARK: - Internal Methods
    func dataForIndexPath(indexPath: IndexPath) -> EmployeeCellModel {
        return items[indexPath.row].cellData()
    }
    
    
    // P R I V A T E   M E T H O D S
    // MARK: - Private Methods
    fileprivate func createEmployee () -> [Employee] {
        let avatarStanislav = UIImage(named: "Stanislav")
        let stanislavGerasymenko = Employee.init(avatar: avatarStanislav, name: "Stanislav", lastName: "Gerasymenko", phoneNumber: "+38 (068) 927 14 12", email: "s.gerasymenko@incode-group.com", jobLink: "https://incode-group.com", job: "Incode Group")
        
        let avatarOleh = UIImage(named: "Oleg")
        let olehMeleshko = Employee.init(avatar: avatarOleh, name: "Oleh", lastName: "Meleshko", phoneNumber: "+38 (096) 719 52 40", email: "o.meleshko@incode-group.com", jobLink: "https://incode-group.com", job: "Incode Group")
        
        let avatarVadym = UIImage(named: "Vadym")
        let vadymDykyi = Employee.init(avatar: avatarVadym, name: "Vadym", lastName: "Dykyi", phoneNumber: "+38(063) 470 94 09", email: "dykyi@incode-group.com", jobLink: "https://incode-group.com", job: "Incode Group")
        
        return [stanislavGerasymenko, olehMeleshko, vadymDykyi, stanislavGerasymenko, olehMeleshko, vadymDykyi, stanislavGerasymenko, olehMeleshko, vadymDykyi, stanislavGerasymenko, olehMeleshko, vadymDykyi]
    }
}

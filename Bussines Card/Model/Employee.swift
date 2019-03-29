//
//  Employee.swift
//  Bussines Card
//
//  Created by Imac on 3/14/19.
//  Copyright © 2019 idev. All rights reserved.
//

import UIKit



struct Employee: PersonProtocol, EmployeeProtocol {
    var avatar: UIImage?
    var name: String
    var lastName: String
    var phoneNumber: String?
    var email: String?
    var jobLink: String?
    var job: String
}


protocol EmployeeProtocol {
    var phoneNumber: String? {get set}
    var email: String? {get set}
    var jobLink: String? {get set}
    var job: String {get set}
    var avatar: UIImage? {get set}
}

protocol PersonProtocol {
    var name: String {get set}
    var lastName: String {get set}
}







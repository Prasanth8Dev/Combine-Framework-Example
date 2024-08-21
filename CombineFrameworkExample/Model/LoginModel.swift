//
//  LoginModel.swift
//  CombineFrameworkExample
//
//  Created by Prasanth S on 20/08/24.
//

import Foundation


// MARK: - UserLoginModel
struct UserLoginModel: Codable {
    let status: Bool
    let message: String
    let user: [User]
}

// MARK: - User
struct User: Codable {
    let registerNumber, name, institution, course: String
    let designation, email, contactNumber, bloodGroup: String
    let password, busroute, source, destination: String
    let profileimage: String
    let dID: Int
    let parentName, parentContact: String
    let status, isLoggedIn, profileimagestatus: Int

    enum CodingKeys: String, CodingKey {
        case registerNumber = "RegisterNumber"
        case name = "Name"
        case institution = "Institution"
        case course = "Course"
        case designation = "Designation"
        case email
        case contactNumber = "ContactNumber"
        case bloodGroup = "BloodGroup"
        case password = "Password"
        case busroute = "Busroute"
        case source = "Source"
        case destination = "Destination"
        case profileimage
        case dID = "DId"
        case parentName = "ParentName"
        case parentContact = "ParentContact"
        case status = "Status"
        case isLoggedIn, profileimagestatus
    }
}

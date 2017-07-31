//
//  Contact.swift
//  MedKaikaiDemoMedia
//
//  Created by Med Kaikai on 2017-07-30.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit

struct Contact {

    var title: String!
    var firstname: String!
    var surname: String!
    var address: String!
    var phoneNumber: String!
    var email: String!
    var createdAt: String!
    var updatedAt: String!
    
    init(title: String, firstname: String, surname: String, address: String, phoneNumber: String, email: String, createdAt: String, updatedAt: String) {
        self.title = title
        self.firstname = firstname
        self.surname = surname
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

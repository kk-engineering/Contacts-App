//
//  ContactDetailsViewController.swift
//  MedKaikaiDemoMedia
//
//  Created by Med Kaikai on 2017-07-30.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    var getTitle = String()
    var getFirstname = String()
    var getSurname = String()
    var getAddress = String()
    var getPhoneNumber = String()
    var getEmail = String()
    var getCreatedAt = String()
    var getUpdatedAt = String()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = getTitle
        firstNameLabel.text = getFirstname
        surnameLabel.text = getSurname
        addressLabel.text = getAddress
        phoneNumberLabel.text = getPhoneNumber
        emailLabel.text = getEmail
        createdAtLabel.text = getCreatedAt
        updatedAtLabel.text = getUpdatedAt
        
    }
}

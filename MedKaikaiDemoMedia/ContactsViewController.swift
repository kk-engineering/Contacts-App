//
//  ContactsViewController.swift
//  MedKaikaiDemoMedia
//
//  Created by Med Kaikai on 2017-07-30.
//  Copyright © 2017 MedKaikai. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var people = [NSManagedObject]()

    @IBOutlet weak var contactsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        retrieveContacts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ContactModel")
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveContacts() {        
        let url = "http://demomedia.co.uk/files/contacts.json"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray

                    for item in parsedData {
                        let eachContact = item as! [String : Any]
                        let title = eachContact["title"] as! String
                        let firstname = eachContact["firstname"] as! String
                        let surname = eachContact["surname"] as! String
                        let address = eachContact["address"] as! String
                        let phoneNumber = eachContact["phoneNumber"] as! String
                        let email = eachContact["email"] as! String
                        let createdAt = eachContact["createdAt"] as! String
                        let updatedAt = eachContact["updatedAt"] as! String
                        
                        self.save(title: title, firstname: firstname, surname: surname, address: address, phoneNumber: phoneNumber, email: email, createdAt: createdAt, updatedAt: updatedAt)
                    }
                    self.refreshTable()
                }
                catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func save(title: String, firstname: String, surname: String, address: String, phoneNumber: String, email: String, createdAt: String, updatedAt: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ContactModel", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        person.setValue(title, forKeyPath: "title")
        person.setValue(firstname, forKeyPath: "firstname")
        person.setValue(surname, forKeyPath: "surname")
        person.setValue(address, forKeyPath: "address")
        person.setValue(phoneNumber, forKeyPath: "phoneNumber")
        person.setValue(email, forKeyPath: "email")
        person.setValue(createdAt, forKeyPath: "createdAt")
        person.setValue(updatedAt, forKeyPath: "updatedAt")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func refreshTable() {
        DispatchQueue.main.async {
            self.contactsTableView.reloadData()
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! ContactCell
        
        let person = people[indexPath.row]
        
        let email = person.value(forKeyPath: "email") as! String
        let avatarUrl = URL(string: "http://api.adorable.io/avatars/285/\(email).png")
        
        URLSession.shared.dataTask(with: avatarUrl!, completionHandler: { (data, response, err) in
            if err != nil {
                print(err!)
                return
            }
            
            let imageData = UIImage(data: data!)
            cell.avatarImage.image = imageData
        }).resume()
        
        cell.firstnameLabel.text = person.value(forKeyPath: "firstname") as? String
        cell.surnameLabel.text = person.value(forKeyPath: "surname") as? String
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "contactDetailsVC") as! ContactDetailsViewController
        
        let person = people[indexPath.row]
        cVc.getTitle = person.value(forKeyPath: "title") as! String
        cVc.getFirstname = person.value(forKeyPath: "firstname") as! String
        cVc.getSurname = person.value(forKeyPath: "surname") as! String
        cVc.getAddress = person.value(forKeyPath: "address") as! String
        cVc.getPhoneNumber = person.value(forKeyPath: "phoneNumber") as! String
        cVc.getEmail = person.value(forKeyPath: "email") as! String
        cVc.getCreatedAt = person.value(forKeyPath: "createdAt") as! String
        cVc.getUpdatedAt = person.value(forKeyPath: "updatedAt") as! String

        self.navigationController?.pushViewController(cVc, animated: true)
    }
}

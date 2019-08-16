//
//  TableTableViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {

    @IBOutlet var refreshButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadLocations()        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentLocationData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let student = StudentModel.studentLocationData[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.studentLocationData[indexPath.row]
            let app = UIApplication.shared
            let toOpen = student.mediaURL
            if let url = URL(string: toOpen) {
            app.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func refreshTapped(_ sender: Any) {
        loadLocations()
    }
    
    func loadLocations() {
        MapClient.getStudentLocations { (students, error) in
            StudentModel.studentLocationData = students
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func pinButtonTapped(_ sender: Any) {
        for student in StudentModel.studentLocationData {
            if student.uniqueKey == MapClient.Auth.uniqueKey {
                MapClient.Auth.updatingLocation = true
                MapClient.Auth.objectID = student.objectId
                
                let vc = UIAlertController(title: "Existing Location Found", message: "Would you like to update your exisiting location?", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (segue) in
                    self.performSegue(withIdentifier: "mapPin2", sender: segue)
                }))
                vc.addAction(UIAlertAction(title: "Cancel", style: .default))
                self.present(vc, animated: true)
            } else {
                MapClient.Auth.updatingLocation = false
                performSegue(withIdentifier: "mapPin2", sender: nil)
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

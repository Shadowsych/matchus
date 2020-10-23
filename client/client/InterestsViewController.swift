//
//  interestsViewController.swift
//  client
//
//  Created by Jinho Yoon on 10/12/20.
//  Copyright © 2020 MatchUs. All rights reserved.
//

import UIKit
import Alamofire

public var interests: [String] = []

class InterestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var email: String = ""
    
    var password: String = ""
    
    var location: String = ""
    
    let textCellIdentifier: String = "TextCell"
    
    let maxInterests: Int = 4
    
    let tableRowSpacing: CGFloat = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var interestText: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interests.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableRowSpacing
    }
    
    // clears out the section background color
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)

        let row = indexPath.section
        cell.textLabel?.text = interests[row]
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.cornerRadius = 6.0
        
        return cell
    }
    
    @IBAction func xButton(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        
        interests.remove(at: indexPath!.section)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @IBAction func addButton(_ sender: Any) {
        var alertTitle: String?
        var alertMessage: String?
        
        if interests.count >= maxInterests {
            alertTitle = "Too many interests"
            alertMessage = "Please enter only \(maxInterests) interests."
        } else if(interestText.text == nil || interestText.text == "") {
            alertTitle = "Invalid input"
            alertMessage = "Please enter text into the interest box."
        }
        
        if alertTitle != nil {
            let alert = UIAlertController(title: alertTitle!, message: alertMessage!, preferredStyle: UIAlertController.Style.alert)
            
            // add an OK button to cancel the alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // present the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        interests.append(interestText.text!)
        interestText.text = ""
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func registerUser(email: String, password: String, location: String, interests: [String]) {
        let registerURL: String = "\(Constants.serverURI)/signup/"
        let parameters = ["email": email, "password": password, "location": location, "interests": interests] as [String : Any]
        
        AF.request(URL.init(string: registerURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                switch response.response?.statusCode {
                    case 200?:
                        if let json = response.value {
                            let success = json as! [String: AnyObject]
                            let successMessage: String? = success["success"] as? String
                            
                            // create a successfully register alert
                            let alert = UIAlertController(title: "Registered!", message: successMessage, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an OK button to cancel the alert
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // present the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        break
                    default:
                        if let json = response.value {
                            let error = json as! [String: AnyObject]
                            let errorArray: [String]? = error["__all__"] as? [String]
                            let emailErrorArray: [String]? = error["email"] as? [String]
                            
                            // receive the type of error message that this error orignated from
                            var errorMessage: String?
                            if errorArray != nil {
                                errorMessage = emailErrorArray?[0]
                            } else if emailErrorArray != nil {
                                errorMessage = emailErrorArray?[0]
                            }
                            
                            // create a failure register alert
                            let alert = UIAlertController(title: "Registration Failed", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
                            
                            // add an OK button to cancel the alert
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            
                            // present the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        break
                }
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if interests.count == maxInterests {
            registerUser(email: email, password: password, location: location, interests: interests)
        } else {
            // create an alert that notifies the user they need more interests
            let alert = UIAlertController(title: "Not enough interests", message: "Please input at least \(maxInterests) interests.", preferredStyle: UIAlertController.Style.alert)
            
            // add an OK button to cancel the alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // present the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}
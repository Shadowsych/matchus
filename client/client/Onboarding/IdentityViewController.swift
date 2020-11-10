//
//  IdentityViewController.swift
//  Matchus
//
//  Created by pbhusal on 11/5/20.
//  Copyright © 2020 MatchUs. All rights reserved.
//

import UIKit

class IdentityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let locationSegueIdentifier: String = "LocationSegue"
    
    var googleUserId: String = ""
    
    var email: String = ""
    
    var password: String = ""
    
    @IBOutlet weak var profilePhoto: UIButton!
    
    @IBOutlet weak var firstNameText: UITextField!
    
    @IBOutlet weak var bioText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioText.layer.borderWidth = 1
        bioText!.layer.borderColor = UIColor.black.cgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func profilePhotoPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        profilePhoto.setBackgroundImage(image, for: .normal)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        if firstNameText.text == nil || firstNameText.text == "" || bioText.text == nil || bioText.text == "" {
            // create a failure alert because there were missing fields
            let alert = UIAlertController(title: "Missing Info", message: "Please enter all of the fields.", preferredStyle: UIAlertController.Style.alert)
            
            // add an OK button to cancel the alert
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // present the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.performSegue(withIdentifier: self.locationSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == locationSegueIdentifier {
            if let locationVC = segue.destination as? LocationViewController {
                // pass over the identity view controller's variables
                locationVC.googleUserId = googleUserId
                locationVC.email = email
                locationVC.password = password
                locationVC.profilePhoto = profilePhoto.backgroundImage(for: .normal)
                locationVC.name = firstNameText.text!
                locationVC.biography = bioText.text!
            }
        }
    }
    
}

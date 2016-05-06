//
//  AddRestoViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 04/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import MapKit

//Pour utiliser l'appareil photo il faut importer ci-dessous
import MobileCoreServices

// Ne pas oublier les protocoles : UIImagePickerControllerDelegate, UINavigationControllerDelegate

class AddRestoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var descriptionTExtField: UITextView!
    @IBOutlet var restoNameTextField: UITextField!
    
    
    @IBOutlet var restoImage: UIImageView!
    
    var newRestoPosition : CLLocation!
    var newRestoAdress = ""
    
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(sender: UIButton){
        if restoNameTextField.text != nil && descriptionTExtField.text != "" {
            
            let newRestoName = restoNameTextField.text!
            let newRestoDescription = descriptionTExtField.text!
        
            newRestoAdress = addressLabel.text!
            
            uploadImageToFirebase(restoImage.image!) { imageId in
                addRestoToFireBase(newRestoName, address: self.newRestoAdress, position: self.newRestoPosition, restoImage: imageId, description: newRestoDescription) { success in
                    print(success)
                    if success {
                        simpleAlert("Bravo", message: "Le resto a bien été ajouté", view: self)
                    } else {
                        simpleAlert("Oups !", message: "Un problème est survenu", view: self)
                    }
                }
            }
        } else {
            simpleAlert("Oups", message: "Veuillez rentrer toutes les informations", view: self)
        }
    }
    
    @IBAction func addPicturePressed() {
        let alertController = UIAlertController(title: "Photo", message: "Veuillez choisir une action", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let pictureAction = UIAlertAction(title: "Prendre une photo", style: UIAlertActionStyle.Default) { (action) in
            self.useCameraMobile()
        }
        alertController.addAction(pictureAction)
        
        let libraryAction = UIAlertAction(title: "Choisir une photo", style: UIAlertActionStyle.Default) { (action) in
            self.useCameraGalery()
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action) in
            //print("nope")
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Pour utiliser la camera
    func useCameraMobile() {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            //  newMedia = true
        }
    }
    
    // récupère une image dans le cameraRoll
    func useCameraGalery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true,
                                       completion: nil)
            // newMedia = false
        }
    }
    
    // recupère une photo via le pickerController
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as String) {
            
            // on récupère ici l'image
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            restoImage.image = image
            
            
            //on pourrait faire d'autres choses comme sauvegarder l'image dans la gallery comme le code ci-dessous
            /*
             if (newMedia == true) {
             UIImageWriteToSavedPhotosAlbum(image, self,
             "image:didFinishSavingWithError:contextInfo:", nil)
             } else if mediaType == (kUTTypeMovie as String) {
             // Code to support video here
             }
            */
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = newRestoAdress
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

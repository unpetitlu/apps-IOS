//
//  AddRestoViewController.swift
//  troiswresto
//
//  Created by nicolas on 03/05/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit
import CoreLocation
import MobileCoreServices //pour le picker photo

class AddRestoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var restoNamePlaceHolderLabel : UILabel!
    @IBOutlet var restoNameTextField : UITextField!
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var descriptionPlaceHolderLabel : UILabel!
    @IBOutlet var descriptionTextView : UITextView!
    @IBOutlet var priceRangePlaceHolder : UILabel!
    @IBOutlet var priceRangeLabel : UILabel!
    @IBOutlet var priceSlider : UISlider!
    @IBOutlet var saveRestoButton : UIButton!
    @IBOutlet var restoImageView : UIImageView!
    @IBOutlet var myNavigationItem : UINavigationItem!
    
    @IBOutlet var cameraButtonItem : UIBarButtonItem!
    
    var restoAddress : String!
    var restoLocation : CLLocation!
    
    /*
    @IBAction func testButtonPressed() {
        self.performSegueWithIdentifier("backtorestos", sender: self)
    }*/
    
    @IBAction func addPictureButtonPressed() {
        let alertController = UIAlertController(title: "addresto.getapicture".translate , message: "", preferredStyle: .ActionSheet)
        
        // Create the action.
        let cameraRollAction = UIAlertAction(title: "addresto.usecameraroll".translate, style: .Default) { _ in
            self.useCameraRoll()
        }
        let cameraAction = UIAlertAction(title: "addresto.takeapicture".translate, style: .Default) { _ in
            self.useCamera()
        }
        
        let cancelAction = UIAlertAction(title: "cancel".translate, style: .Destructive) { _ in
        }
        
        // Add the action.
        alertController.addAction(cameraRollAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        if isIpad() {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = restoImageView
                popoverController.sourceRect = restoImageView.bounds
            }
        }
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func useCamera() {
        
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
    func useCameraRoll() {
        
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
            
            restoImageView.image = image
            
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
    
    
    @IBAction func saveRestoButtonPressed () {
        if restoNameTextField.text != nil && restoNameTextField.text != "" {
            createRestoInCloud(restoNameTextField.text!, address : restoAddress, location: restoLocation, image: restoImageView.image, priceRange: PriceRange(rawValue:Int(priceSlider.value))!, description: descriptionTextView.text) {() in
                simpleAlert("main.restocreated", message: nil, acceptTitle: nil, myController: self, completion: {() in
                    self.performSegueWithIdentifier("backtorestos", sender: self)
                    
                   // self.performSegueWithIdentifier("backtorestos", sender: self)
                })
            }

        } else {
            simpleAlert("addresto.incomplete".translate, message: "addresto.typeaname".translate, acceptTitle: nil, myController: self, completion: nil)
        }
    }
    
    @IBAction func textEditingDidEnd() {
        restoNameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBAction func sliderDidEnd(sender : UISlider) {
        
        logDebug("slider did end")
        
        let input = sender.value
        var output : Float = 0.0
        if input < 0.5 {
            output = 0
        } else if input < 1.5 {
            output = 1
        } else {
            output = 2
        }
        
        priceSlider.setValue(output, animated: true)
        updateDisplay()
        
        
    }

    func updateDisplay() {
        
        restoNamePlaceHolderLabel.text = "addresto.name".translate
        restoNameTextField.placeholder = "addresto.restonameplaceholder".translate
        descriptionPlaceHolderLabel.text = "addresto.description".translate
        saveRestoButton.setTitle("addresto.saveresto".translate, forState: .Normal)
        priceRangePlaceHolder.text = "addresto.pricerange".translate
        myNavigationItem.title = "addresto.addaresto".translate
        
        addressLabel.text = restoAddress
        logDebug("restAdress=\(restoAddress)")
        var myText = ""
        
        switch priceSlider.value {
        case 0.0:
            myText = "addresto.cheap".translate
        case 1.0:
            myText = "addresto.medium".translate
        case 2.0:
            myText = "addresto.expensive".translate
        default:
            myText = ""
            break
        }
        priceRangeLabel.text = myText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
        priceSlider.setValue(1, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Remonter la vue avec le clavier
    func textViewDidBeginEditing(textView: UITextView) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        animateViewMoving(false, moveValue: 100)
    }

    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    // MARK: -
}

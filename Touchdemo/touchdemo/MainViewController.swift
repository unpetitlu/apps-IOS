//
//  ViewController.swift
//  touchdemo
//
//  Created by David on 31/03/2016.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

// Ajout import pour le son
import AVFoundation

class MainViewController: UIViewController {
    
    @IBOutlet var positionBeganLabel : UILabel!
    @IBOutlet var positionMoveLabel : UILabel!
    @IBOutlet var positionEndLabel : UILabel!
    @IBOutlet var sandboxView : UIView!
    @IBOutlet var sizeSlider : UISlider!
    @IBOutlet var screenButton : UIButton!
    
    var drawImages = [UIView]()
    var defaultColor = UIColor.blueColor()
    var defaultSizeBrush = CGSize()
    
    // Ajout variable globale pour le son	
    var playerAudio = AVAudioPlayer()
    
    @IBAction func changeValueSizeBrush(sender: UISlider!)
    {
        defaultSizeBrush.width = CGFloat(sender.value)
        defaultSizeBrush.height = CGFloat(sender.value)
        NSUserDefaults.standardUserDefaults().setFloat(Float(defaultSizeBrush.width), forKey: "sizeWidth")
        NSUserDefaults.standardUserDefaults().setFloat(Float(defaultSizeBrush.height), forKey: "sizeHeight")
    }
    
    func playSound(soundName: String, ofType : String)
    {
        let playFile = NSBundle.mainBundle().pathForResource(soundName, ofType: ofType)
        if (playFile != nil) {
            do {
                playerAudio = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:playFile!))
                playerAudio.prepareToPlay()
                playerAudio.play()
            } catch let error as NSError {
                print("audio error:\(error)")
            }
        } else {
            print("error to play sound for filename=\(soundName)")
        }
    }
    
    func positionInView(position:CGPoint, view: UIView) -> Bool
    {	
        if (position.x >= view.frame.origin.x && position.x <= view.frame.origin.x + view.frame.width)
            &&
            (position.y >= view.frame.origin.y && position.y <= view.frame.origin.y + view.frame.height)
        {
            return true
        }
        
        return false
    }
    
    func drawPoint(position:CGPoint) {
        if positionInView(position, view: sandboxView)
        {
            playSound("jump", ofType: "aiff")
            let myView = UIView(frame : CGRectMake(position.x - (defaultSizeBrush.width / 2) , position.y - (defaultSizeBrush.height / 2), defaultSizeBrush.width, defaultSizeBrush.height))
            myView.backgroundColor = defaultColor
            self.view.addSubview(myView)
            drawImages.append(myView)
        }
    }

    func drawCircle (position:CGPoint) {
        if positionInView(position, view: sandboxView)
        {
            let myImageView = UIImageView(image: UIImage(named: "rond_orange"))
            myImageView.frame = CGRectMake(position.x - (defaultSizeBrush.width / 2) , position.y - (defaultSizeBrush.height / 2), defaultSizeBrush.width, defaultSizeBrush.height)
            self.view.addSubview(myImageView)
            drawImages.append(myImageView)
        }
    }
    
    func resetButtonPressed()
    {
        for item in drawImages
        {
            item.removeFromSuperview()
        }
        drawImages.removeAll()
        defaultColor = UIColor.blueColor()
        initBrush()
    }
    
    func gumButtonPressed()
    {
        defaultColor = UIColor.whiteColor()
        defaultSizeBrush.width = 20
        defaultSizeBrush.height = 20
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(view)
            positionBeganLabel.text = "x =" + "\(position.x)" + "y =" + "\(position.y)"
            drawPoint(position)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(view)
            positionMoveLabel.text = "x =" + "\(position.x)" + "y =" + "\(position.y)"
            drawCircle(position)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(view)
            positionEndLabel.text = "x =" + "\(position.x)" + "y =" + "\(position.y)"
            drawPoint(position)
        }
    }
    
    func initBrush()
    {
        if NSUserDefaults.standardUserDefaults().objectForKey("sizeWidth") != nil
        {
            defaultSizeBrush.width = CGFloat(NSUserDefaults.standardUserDefaults().integerForKey("sizeWidth"))
        }
        else
        {
            defaultSizeBrush.width = 5
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("sizeHeight") != nil
        {
            defaultSizeBrush.height = CGFloat(NSUserDefaults.standardUserDefaults().integerForKey("sizeHeight"))
        }
        else
        {
            defaultSizeBrush.height = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBrush()
        
        sizeSlider.setValue(Float(defaultSizeBrush.width), animated: true)
        
        
        let resetButton = UIButton(type :UIButtonType.System)
        resetButton.frame = CGRectMake(10, 40, 100, 40)
        resetButton.setTitle("Reset", forState: .Normal)
        self.view.addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(MainViewController.resetButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        let gumButton = UIButton(type :UIButtonType.InfoLight)
        gumButton.frame = CGRectMake(100, 40, 100, 40)
        gumButton.setTitle("Gum", forState: .Normal)
        self.view.addSubview(gumButton)
        gumButton.addTarget(self, action: #selector(MainViewController.gumButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Screenshot
    func captureScreen() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, 0);
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image
    }
    
    @IBAction func takeScreenShot() {
        let myImage = captureScreen()
        
        UIImageWriteToSavedPhotosAlbum(myImage, self, #selector(MainViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }


}


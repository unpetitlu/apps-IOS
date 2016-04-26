//
//  ViewController.swift
//  timer
//
//  Created by etudiant-02 on 20/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var startButton : UIButton!
    @IBOutlet var stopButton : UIButton!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var sizeSlider : UISlider!
    @IBOutlet var progressBar : UIProgressView!
    @IBOutlet var sunImageView : UIImageView!
    @IBOutlet var sunXConstraint : NSLayoutConstraint!
    @IBOutlet var sunYConstraint : NSLayoutConstraint!
    
    
    var remainingTime = 0 // temps qu'il reste
    var myTimer = NSTimer()
    var sablierDuration = 40 // durée du sablier
    var counter = 0
    var pixelPerSecond = 0.0
    
    @IBAction func changeValueSizeBrush(sender: UISlider!)
    {
        sablierDuration = Int(sender.value)
        initTimer()
    }
    
    @IBAction func stopTimer () {
        myTimer.invalidate()
        
        initTimer()
    }
    
    @IBAction func startTimer()
    {
        stopTimer()
        updateTimer()
    }
    
    func updateTimer () {
        //NSLog("temps restant=\(remainingTime)")
        if remainingTime <= 0 {
            myTimer.invalidate()
        } else {
            remainingTime -=  1
            titleLabel.text = "\(remainingTime)"

            progressBar.progress = Float(remainingTime) / Float(sablierDuration)
            
            
            // Permet de rafraichir le layout si besoin afin d'éviter les saccades
            // A utiliser avant et à la fin d'une animation. 2 étapes
            // 1 etape
            self.view.layoutIfNeeded()
            
            /*
             Création d'une animation
            */
             counter += 1
             UIView.animateWithDuration(NSTimeInterval(0.5), delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
             
                let moveDown = CGAffineTransformMakeTranslation(0, CGFloat(self.pixelPerSecond * Double(self.counter)))
                self.titleLabel.transform = moveDown
                
                // Animation du soleil
                self.sunXConstraint.constant = 15 * CGFloat(self.counter)
                self.sunYConstraint.constant = 15 * CGFloat(self.counter)
                
                
                // 2 etape
                self.view.layoutIfNeeded()
             
             }  , completion: nil)
        
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self,
                                                         selector: #selector(self.updateTimer),
                                                         userInfo: nil,
                                                         repeats: false)
        }
    }
    
    func initTimer()
    {
        remainingTime = sablierDuration
        titleLabel.text = "\(remainingTime)"
        counter = 0
        titleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        progressBar.progress = 1
        // milieu de l'écran - 120 : la hauteur du label d'origine
        pixelPerSecond = Double((realScreenHeight() / 2) - 120) / Double(remainingTime)
        
        
        // Initialisation des contraintes du soleil
        self.sunXConstraint.constant = 0
        self.sunYConstraint.constant = 0
        self.view.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initTimer()
        sizeSlider.setValue(Float(remainingTime), animated: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//
//  ViewController.swift
//  tictactoe
//
//  Created by Nicolas on 28/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation //pour le son

class MainViewController: UIViewController {
    
    @IBOutlet var nextPlayerLabel : UILabel!
    @IBOutlet var nextPlayerImage : UIImageView!
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var restartButton : UIButton!
    @IBOutlet var timerLabel : UILabel!
        
    var activePlayer : Int! //1 ou 2
    var playing = true // savoir si jeu en cours ou non
    var timeSinceGameStarted = 0
    var myTimer = NSTimer()
    
    var game : Game!
    
  //  var grid = Array<Array<Int>>()  autre notation possible
     // grille des coups joués. Tableau à deux dimensions.
    
    var playerImages = [UIView]()//tableau des images des coups joués
    var lines = [UIView]() //tableau des lignes de la grille

    var playAudio = AVAudioPlayer()

    @IBAction func restartButtonPressed() {
        startGame(game.nbColumns)
    }
    
    func incrementTimer () {
        timerLabel.text = "\(timeSinceGameStarted.secondsToTime)"
        timeSinceGameStarted += 1
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self,
            selector: #selector(MainViewController.incrementTimer),
            userInfo: nil,
            repeats: false)
    }
    
    func playSound(soundName: String, ofType : String)
    {
        let playFile = NSBundle.mainBundle().pathForResource(soundName, ofType: ofType)
        if (playFile != nil) {
            do {
                playAudio = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath:playFile!))
                playAudio.prepareToPlay()
                playAudio.play()
            } catch let error as NSError {
                print("audio error:\(error)")
            }
        } else {
            print("error to play sound for filename=\(soundName)")
        }
    }
    
    // MARK: - Fonctions d'affichage
    func showGrid() {
        for index in 1...game.nbColumns-1 {
            showVerticalLine(self.view, x: game.leftMargin + CGFloat(index) * game.columnWidth, y: game.topMargin, length: game.gridSize, lineWidth : game.lineWidth)
            showHorizontalLine(self.view, x: game.leftMargin, y: game.topMargin + CGFloat(index) * game.columnWidth, length: game.gridSize, lineWidth : game.lineWidth)
        }
    }
    
    func showVerticalLine (view : UIView, x : CGFloat, y : CGFloat, length : CGFloat, lineWidth : CGFloat) {
        let newLine = UIView(frame: CGRectMake(x - lineWidth / 2, y, lineWidth, length))
        newLine.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        view.addSubview(newLine)
        lines.append(newLine)
        
        appearFromRight(newLine, duree: 0.3, delay : 0, completionHandler: nil)
    }
    
    func showHorizontalLine (view : UIView, x : CGFloat, y : CGFloat, length : CGFloat, lineWidth : CGFloat) {
        let newLine = UIView(frame: CGRectMake(x, y - lineWidth / 2, length, lineWidth))
        newLine.backgroundColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        view.addSubview(newLine)
        lines.append(newLine)
        
        appearFromRight(newLine, duree: 0.3, delay : 0, completionHandler: nil)
    }
    
    func drawImage (imageName : String, position : CGPoint, size : CGFloat) {
        let myImageView = UIImageView(frame: CGRectMake(position.x , position.y , size, size))
        myImageView.image = UIImage(named: imageName)
        self.view.addSubview(myImageView)
        
        playerImages.append(myImageView)
        appearExpandView(myImageView, duration: 0.3, delay: 0)
    }
    
    
    func showImageIngrid (i: Int, j : Int, player : Int) {
        
        drawImage((player == 1) ? "rond" : "croix", position: CGPoint(x: game.leftMargin + CGFloat(i) * game.columnWidth, y: game.topMargin + CGFloat(j) * game.columnWidth), size: game.columnWidth)

    }
    
    func detectPositionInGrid(position : CGPoint)->Move? {
        if ((position.x > game.leftMargin)
            && (position.x < game.leftMargin + CGFloat(game.nbColumns) * game.columnWidth)
            && (position.y > game.topMargin)
            && (position.y < game.topMargin + CGFloat(game.nbColumns) * game.columnWidth)
            ) {
                
                let i0 = Int( (position.x - game.leftMargin) / game.columnWidth )
                let j0 = Int ((position.y - game.topMargin) / game.columnWidth )
                
                return Move(i: i0, j: j0)
        } else {
            return nil
        }
    }
    
    func updateDisplay() {
        nextPlayerImage.image = UIImage(named: (activePlayer == 1) ? "rond" : "croix")
    }
    
    // MARK: - Logique de jeu

    //annule le coup précédent
    func cancelPreviousMove() {
        if (game.moves.count > 0) {
            
            prepareNextMove()
            
            //suppression de l'affichage du dernier coup
            playerImages.last?.removeFromSuperview()
            playerImages.removeLast()
            
            game.grid[game.moves.last!.i][game.moves.last!.j] = 0
            
            game.moves.removeLast()
        }
    }
    
    //répond au swipe. Affiche une alerte pour confirmer.
    @IBAction func swipeAction(sender: UISwipeGestureRecognizer) {
        
        // on ne présente l'alerte que si il y a un coup à annuler et la partie n'est pas terminée
        if (game.moves.count > 0) && playing {
            let alertController = UIAlertController(title: "Cancel previous move ?"
                , message: "There is no turning back" , preferredStyle: .Alert)
            
            // Action si OK
            let acceptAction = UIAlertAction(title:  "OK", style: .Default) { _ in
                self.playSound("flipcard", ofType: "aiff")

                self.cancelPreviousMove()
            }
            
            // Actionn si Cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {_ in
                // on ne fait rien
            }
            
            // Add the action.
            alertController.addAction(acceptAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // détecte un touch sur l'écran
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if playing {
            if let touch = touches.first {
                let position = touch.locationInView(view)
                
                if let move = detectPositionInGrid(position) {
                    // print ("i=\(coordonnees.i) j=\(coordonnees.j)")
                    analyseMove(move, player: self.activePlayer)
                    
                } else {
                    messageLabel.text = "out of bounds"
                }
            }
        }
    }
    
    func prepareNextMove() {
        messageLabel.text = ""
        activePlayer = activePlayer + 1
        if activePlayer == 3 {
            activePlayer = 1
        }
        updateDisplay()
    }
    
    func analyseMove(move : Move, player : Int) {
        if (game.grid[move.i][move.j] == 0) {
            
            playSound("click_start", ofType: "caf")
            
            showImageIngrid(move.i, j: move.j, player: player)
            game.grid[move.i][move.j] = player //on met le numéro du joueur dans la case
            
            if game.detectWin
            {//un joueur a gagné
                gameOverWithWinner(true)
            } else if game.detectGameOver {// personne n'a gagné
                gameOverWithWinner(false)
            } else {
                game.moves.append(move)
                
                prepareNextMove()
            }
        } else {
            messageLabel.text = "impossible move"
        }
    }
    
    func gameOverWithWinner(weHaveAWinner : Bool) {
        playing = false
        myTimer.invalidate()
        
        playSound("tada", ofType: "aifc")
        if weHaveAWinner {
            let winnerString = (activePlayer == 1) ? "rond" : "croix"
            messageLabel.text =  winnerString + " wins"
        } else {
            messageLabel.text = "The only winning move is not to play"
        }
        restartButton.hidden = false
    }
    
    func resetDisplay() {
        for item in playerImages {
            item.removeFromSuperview()
        }
        
        playerImages.removeAll()
        
        for item in lines {
            item.removeFromSuperview()
        }
        lines.removeAll()
    }
    
    func startGame(nbColumns : Int) {
        //on réinitialise le Game
        game = Game(nbColumns : nbColumns)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            game.topMargin = 250
            game.leftMargin = 100
            game.lineWidth = 8
        }
        myTimer.invalidate()

        resetDisplay()
        
        showGrid()
        
        messageLabel.text = ""
        restartButton.hidden = true
        activePlayer = 1
        
        updateDisplay()
        timeSinceGameStarted = 0
        incrementTimer()
        playing = true
    }
    // MARK: - Navigation
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "maintoprofile")
        {
            let mydestination: ProfileViewController =  segue.destinationViewController as! ProfileViewController
            mydestination.game = game
            mydestination.mainViewController = self // je suis ton père
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextPlayerLabel.text = "Next:"
        messageLabel.adjustsFontSizeToFitWidth = true
        
        /*
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft"))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        */
        startGame(3)
       // showImageIngrid(1, j: 2, player: 1)
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


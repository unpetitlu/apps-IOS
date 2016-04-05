//
//  MainViewController.swift
//  tictactoe
//
//  Created by etudiant-02 on 01/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var game : Game!
    var activePlayer: Int!
    var lastMoves = [Move]()
    var imagesView = [UIImageView]()
    var gridView = [UIView]()
    
    @IBOutlet var imageNextPlayer : UIImageView!
    @IBOutlet var matchLabel : UILabel!
    @IBOutlet var restartButton : UIButton!
    
    
    /**
        Create grid with property "nbColumns" of game
    */
    func createGrid()
    {
        for index in 1..<game.nbColumns
        {
            showVerticalLine(CGPoint(x:( game.leftMargin + CGFloat(index) * game.columnWidth ),y: game.topMargin), width: game.lineWidth, height: game.gridSize)
            
            showHorizontalLine(CGPoint(x: game.leftMargin, y: ( game.topMargin + CGFloat(index) * game.columnWidth )), width: game.gridSize, height: game.lineWidth)
        }
    }
    
    //MARK: - Create line
    /**
        Create grid
        - parameter myView: UIView
    */
    func showLine(myView : UIView)
    {
        myView.backgroundColor = UIColor.blackColor()
        gridView.append(myView)
        self.view.addSubview(myView)
    }
    
    /**
        Display vertical line
        - parameter position: CGPoint
        - parameter width: CGFloat
        - parameter height: CGFloat
    */
    func showVerticalLine(position: CGPoint, width : CGFloat, height: CGFloat)
    {
        showLine(UIView(frame : CGRect(x: position.x - (width / 2), y: position.y, width: width, height: height)))
    }
    
    /**
        Display horizontal line
        - parameter position: CGPoint
        - parameter width: CGFloat
        - parameter height: CGFloat
    */
    func showHorizontalLine(position: CGPoint, width : CGFloat, height: CGFloat)
    {
        showLine(UIView(frame : CGRect(x: position.x, y: position.y - (height / 2), width: width, height: height)))
    }
    //MARK: -
    
    
    //MARK: - Create image (circle or cross)
    func drawImage(imageName: String, position:CGPoint, size: CGFloat) {
        let myImageView = UIImageView(image: UIImage(named: imageName))
        myImageView.frame = CGRectMake(position.x , position.y, size, size)
        self.view.addSubview(myImageView)
        
        imagesView.append(myImageView)
    }
    
    /**
        Display image (circle or cross)
        - parameter i: représente la colonne
        - parameter j: représente la ligne
        - parameter player: représente le joueur
    */
    func showImageInGrid(i: Int, j: Int, player: Int)
    {
        drawImage(player==1 ? "rond" : "croix", position: CGPoint(x: (game.leftMargin + CGFloat(i) * game.columnWidth), y: (game.topMargin + CGFloat(j) * game.columnWidth)), size: game.columnWidth)
    }
    //MARK: -
    
    
    //MARK: - game
    
    /**
        Return position of circle or cross
        Ex: (i: 1, j:0) -> positionnera le cercle ou la croix tout en haut au milieu
        - parameter position: CGPoint
        - returns: tuple
    */
    func detectPositionInGrid(position : CGPoint) -> Move? {
        if ((position.x > game.leftMargin)
            && (position.x < game.leftMargin + CGFloat(game.nbColumns) * game.columnWidth)
            && (position.y > game.topMargin)
            && (position.y < game.topMargin + CGFloat(game.nbColumns) * game.columnWidth)
            )
        {
            
            let i0 = Int( (position.x - game.leftMargin) / game.columnWidth )
            let j0 = Int ((position.y - game.topMargin) / game.columnWidth )
            
            return Move(i: i0, j: j0)
        } else {
            return nil
        }
    }
    
    func analyseMove(move : Move, player: Int)
    {
        if 0 == game.gridPlayer[move.i][move.j]
        {
            matchLabel.text = ""
            showImageInGrid(move.i, j: move.j, player: activePlayer)
            
            // sauvegarde le coup du joueur
            game.gridPlayer[move.i][move.j] = activePlayer
            lastMoves.append(move)
            
            if imagesView.count >= (game.nbColumns * 2 - 1)
            {
                // victory or not
                detectVictory(move)
            }
        }
        else
        {
            matchLabel.text = "Not possible"
        }
    }
    
    func nextPlayer()
    {
        imageNextPlayer.image = UIImage(named: activePlayer == 1 ? "croix" : "rond")
        activePlayer = activePlayer == 1 ? 2 : 1
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !game.end
        {
            if let touch = touches.first {
                let position = touch.locationInView(view)
                if let positionPlayer = detectPositionInGrid(position)
                {
                    analyseMove(positionPlayer, player: activePlayer)
                    nextPlayer()
                }
                else
                {
                    matchLabel.text = "Out of bounds"
                }
            }
        }
    }
    
    func detectVictory(move: Move)
    {
        // test horizontal and vertical
        var victoryHOrDG = true
        var victoryVOrDD = true
        for item in 0..<game.nbColumns
        {
            if game.gridPlayer[item][move.j] != activePlayer
            {
                victoryHOrDG = false
            }
            
            if game.gridPlayer[move.i][item] != activePlayer
            {
                victoryVOrDD = false
            }
        }
        
        if (victoryHOrDG == false && victoryVOrDD == false)
        {
            victoryHOrDG = true
            victoryVOrDD = true
            var inverseDiagonal = game.nbColumns - 1
            for item in 0..<game.nbColumns
            {
                if game.gridPlayer[item][item] != activePlayer
                {
                    victoryHOrDG = false
                }
                
                if game.gridPlayer[inverseDiagonal][item] != activePlayer
                {
                    victoryVOrDD = false
                }
                inverseDiagonal -= 1
            }
        }
        
        if victoryHOrDG == true || victoryVOrDD == true
        {
            matchLabel.text = "Victoire : joueur \(activePlayer)"
            endGame()
        }
        else if game.detectFull()
        {
            matchLabel.text = "Egality"
            endGame()
        }
    }
    
    /**
        Start and restart game (create grid, nb grid, player, etc.)
     */
    func startGame(nbColumns : Int)
    {
        game = Game(nbColumns: nbColumns)
        matchLabel.text = ""
        imageNextPlayer.image = UIImage(named: "rond")
        activePlayer = 1
        restartButton.hidden = true
        createGrid()
    }
    
    @IBAction func restart()
    {
        for item in imagesView
        {
            item.removeFromSuperview()
        }
        imagesView.removeAll()
        
        for item in gridView
        {
            item.removeFromSuperview()
        }
        gridView.removeAll()
        startGame(game.nbColumns)
    }
    
    func endGame()
    {
        game.end = true
        restartButton.hidden = false
    }
    //MARK: -
    
    
    
    
    // Prépare la transition vers l'écran Profile
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "maintoprofil")
        {
            let myDestination: ProfilViewController =  segue.destinationViewController as! ProfilViewController
            
            // l'instance user est passée par référence au ProfilViewController
            //mydestination.user = user
            
            myDestination.mainViewController = self // Création d'une référence de MainViewController depuis ProfilViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("columns") != nil
        {
            startGame(NSUserDefaults.standardUserDefaults().integerForKey("columns"))
        }
        else
        {
            startGame(3)
        }
        
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.handleSwipes))
        //let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.handleSwipes))
        leftSwipe.direction = .Left
        //rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        //view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left && !game.end) {
            if imagesView.count > 0
            {
                nextPlayer()
                imagesView[imagesView.count-1].removeFromSuperview()
                imagesView.removeLast()
                game.gridPlayer[lastMoves[lastMoves.count-1].i][lastMoves[lastMoves.count-1].j] = 0
                lastMoves.removeLast()
            }
        }
        
        /*
        if (sender.direction == .Right) {
            print("Swipe Right")
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


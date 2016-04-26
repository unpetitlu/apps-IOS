//
//  MyViewController.swift
//  MemoFlash
//
//  Created by nicolas on 05/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//


// Exemple fictif de ViewController.
// pense bête pour mémoriser les syntaxes et l'organisation du ViewController

import UIKit //import de Librairies

class PenseBeteViewController: UIViewController {// ne pas oublier de choisir PenseBeteViewController dans le storyboard
    
    @IBOutlet var myButton : UIButton! // relier l'objet à l'outlet dans IBOutlet avec New Referencing Outlet
    @IBOutlet var myLabel : UILabel! // l'outlet est nécessaire si on doit modifier la valeur
    @IBOutlet var scoreLabel : UILabel!
    @IBOutlet var myStepper : UIStepper!
    
    // MARK: - Variables globales
    var player : Player! // déclaration de la variable game. Elle est unwrappée, elle doit être initialisée au plus tôt dans le controlleur
    let welcomeString = "Hello" // variable globale
    
    // MARK: - Déclarations de fonctions et d'IBAction
    
    @IBAction func startButtonPressed (sender:UIButton!) {// ne pas oublier de le relier dans le storyboard. En général avec Touch Up Inside
        // préparer le démarrage
        startGame()
    }
    
    @IBAction func valueChanged (sender: UIStepper!) {
        
        let value = sender.value
        // faire quelque chose avec la value
        print("la valeur est \(value)")
    }
    

    func sayHello(name : String)->String { //prend une String et renvoie une String
        return "Hello \(name)"
    }
    
    func startGame() { // exemple de fonction. Il est important de bien décomposer les fonctions
        // code de la fonction
        player.logScore() // appel de la méthode de classe
    }
    
    func initGame() {
        // code de la fonction
    }
    
    func updateDisplay() { // exemple de fonction
        // mettre à jour l'affichage
        myLabel.text = self.welcomeString //self non obligatoire ici
        scoreLabel.text = "le score \(player.score)"
        
        if player.isAGoodPlayer {
            print("well done")
        }
    }

    
    // MARK: - Cycle de vie de la vue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // On pourra obtenir ici une référence vers le ViewController de destination et l'utiliser
        // par exemple pour lui passer des variables
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // effectuer des actions qui doivent être lancées à la première apparition de la vue
        
        player = Player(difficulty: 2)
        initGame()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(sayHello("toto"))
        updateDisplay()
        // effectuer des actions qui doivent être relancées à chaque apparition de la vue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// les déclarations de classes se trouvent en principe dans un autre fichier nommé Player.swift ou Model.swift
// Celle ci est placée ici pour présenter un modèle dans un seul fichier

// MARK: - Modèle. A placer dans un autre fichier
class Player {
    let score = 0 //propriété avec une valeur initiale
    var difficulty : Int // propriété sans valeur initiale, doit être intialisée dans le init
    
    var isAGoodPlayer : Bool { // propriété calculée
        return difficulty > 1 && score > 50
    }
    
    func logScore() { // méthode de classe
        print("My score is \(self.score)")
    }
    
    init(difficulty : Int) {
        self.difficulty = difficulty
    }
}


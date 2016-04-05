//: # Formation développeur mobile sous iOS avec Swift

//: # Cours 4 Initiation à la programmation orientée objet en Swift
import UIKit
//: La POO est une façon de modéliser les algorithmes. Apporte un niveau d'abstraction. Ce n'est pas la panacée. Doit rendre le code plus lisible, sur et réutilisable. Mais a utiliser quand cela apporte quelque chose. Dans le framework Cocoa, tous les éléments sont des objets.

//: ## Struct

//: Les éléments de base de la POO en Swift. Les deux peuvent :
//: * Définir des propriétés pour stocker des valeurs
//: * Définir des méthodes pour effectuer des calculs sur ces valeurs
//: * Définir des méthodes d'initialisation des objets
//: * Se conformer à des protocoles

//: Les Class peuvent en plus :
//: * Définir des héritages
//: * Proposer des fonctions pour tester l'appartenance d'un objet à une classe

//: * Grosse différence. **Les `struct` sont passées par valeur, les `class` par référence**.
//: * On utilise la syntaxe `PascalCase` pour définir les `struct` et les `class`. Pour les différencier des instances de ces classes.

//: ## `Struct`
struct MyStruct {
    //définition de la Struct
}
struct Pixel {
    var positionX = 0
    var positionY = 0
    
    //dans cet exemple on fournit directement les valeurs initiales
    var height : Int? //la hauteur est optionnelle
    var color : UIColor? //la couleur est optionnelle
}

//: Créer une instance
var myPixel = Pixel()
//: Accéder aux propriétés
myPixel.positionX
myPixel.positionY
myPixel.height //on a bien nil car la valeur n'avait pas été définie
//: affecter une valeur
myPixel.height = 4
myPixel.height
myPixel.color = UIColor.blackColor()
//: Afficher les éléments d'une instance dans la console
print(myPixel)
//: La fonction d'initialisation est automatiquement générée
var myOtherPixel = Pixel(positionX: 4, positionY: 5, height: 4, color: nil)
// Remarquer ce que propose l'auto completion
//: Tous les arguments doivent être initialisés. utiliser `nil` quand la valeur n'est pas connue.

//: * Important : Les `struct` sont passées par **valeur**. La variable est recopiée avec ses valeurs.
let myThirdPixel = myOtherPixel
myThirdPixel.positionX // est 4
myOtherPixel.positionX = 3
myThirdPixel.positionX // est toujours 4. Car myThirdPixel et myOtherPixel sont deux variables différentes.
//: On peut définir des propriétés constantes ou variables. Si les valeurs initiales ne sont pas fournies, elles doivent alors être initialisées
struct NewPoint {
    var positionX : Int
    var positionY : Int
    let color : UIColor
}
// let myNewPoint = NewPoint() génère une erreur
var myNewPoint = NewPoint(positionX: 0, positionY: 0, color: UIColor.blackColor())
myNewPoint.positionX = 4
// myNewPoint.color = UIColor.redColor() génère une erreur
//: Propriétés calculées

struct AnotherPixel {
    var positionX : Int
    var positionY : Int
    var distanceToCenter : Double {
        return sqrt(Double(positionX^2 + positionY^2))
    }
}
let myAnotherPixel = AnotherPixel(positionX: -4, positionY: 3)
myAnotherPixel.distanceToCenter
//: Exercice : créer un struct user, avec un nom, un email optionel, un age optionel, et un score Int, initialisé  à 0. Créer des instances de User, jouer avec.
struct User {
    var name : String
    var email : String?
    var age : Int?
    var score = 0
}
//let toto = User()
//toto.age
//let titi = User()

//: ## Méthodes d'instance
//: Une fonction peut être définie dans un struct.
//: Ajouter une fonction sayHello qui affiche Hello suivi du nom du joueur.

//: Des fonctions qui appartiennent à une instance. Peuvent retourner un résultat et agir sur les variables du Struct
struct OneMorePixel {
    var positionX : Int
    var positionY : Int
    mutating func moveRight() {
        positionX += 1
    }
    
    func givePositionString()->String {
        return "positionX=\(positionX) positionY=\(positionY)"
    }
}

var toto = OneMorePixel(positionX: 7, positionY: 4)
toto.moveRight()
print(toto.givePositionString())
//: * Exercice : définir un `struct`. Player. Le profil d'un joueur dans un jeu. Avec : un nom obligatoire, un age optionel, un scoremax initialisé à 0 et un nombre de crédit restant initialisé à 0. définir deux méthodes d'instance pour augmenter et diminuer le crédit d'un nombre entier. La fonction remove credit renvoie faux si le credit est insuffisant. Tester.

//: Corrigé
struct Player {
    var name : String
    var age : Int?
    var scoreMax = 0
    var credit = 0
    
    mutating func addCredit(myCredit : Int) {
        self.credit += myCredit
    }
    
    mutating func removeCredit(myCredit : Int)->Bool {
        if (myCredit <= credit) {
            self.credit -= myCredit
            return true
        } else {
            return false
        }
    }
}
var playerOne = Player(name: "Nicolas", age: 15, scoreMax: 0, credit: 1)
print(playerOne)
playerOne.addCredit(10)
playerOne.removeCredit(5)
playerOne.credit
playerOne.removeCredit(45)
playerOne.credit




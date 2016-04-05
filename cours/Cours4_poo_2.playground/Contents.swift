//: # Formation développeur mobile sous iOS avec Swift

//: # Cours 4 Initiation à la programmation orientée objet en Swift. Partie 2.
import UIKit

//: ## Les classes : `class`
//: La plupart des syntaxes vues sur les struct sont valables.

//: Mais il faut définir le constructeur de la classe avec `init`.
//: Reprendre le `struct` de l'exercice précédent et le copier en remplaçant `struct` par `class`
class AnotherPlayer {
    var name : String
    var age : Int?
    var scoreMax = 0
    var credit = 0
    
    init (name: String) {
        self.name = name
    }
    
    func addCredit(myCredit : Int) {
        self.credit += myCredit
    }
    
    func removeCredit(myCredit : Int)->Bool {
        if (myCredit <= credit) {
            self.credit -= myCredit
            return true
        } else {
            return false
        }
    }
}

var titi = AnotherPlayer(name: "titi")
//: seule la variable name a besoin d'être initialisée
print(titi) //n'affiche pas le détail de titi
titi.name
titi.age = 42
titi.age
titi.credit

//: il a fallu enlever les mutating. Et ajouter l'initializer. Les class n'ont pas d'initializer prédéfini.

//: * Remarque : on peut aussi définir un initializer sur les struct.
class Point {
    var posX : Float
    var posY : Float
    init (x: Float, y: Float) {
        self.posX = x
        self.posY = y
    }
}
//: Les `class` sont passées en référence
let myPoint = Point(x: 0, y: 0)
let myOtherPoint = myPoint
myPoint.posX = 4 // on peut modifier la propriété alors que myPoint est une constante
myOtherPoint.posX // renvoie 4
//: La valeur a été modifiée car myPoint et myOtherPoint désignent la même instance
//: C'est également valable car une instance de classe est passée en paramètre d'une fonction.
func moveRight(myPoint : Point) {
    myPoint.posX += 1
}
moveRight(myPoint)
myPoint.posX
//: Même si la logique est plutôt de faire une méthode de classe.

//: Opérateur d'identité
myOtherPoint === myPoint // est true

//: Option. Définir un Observer sur une propriété
class Eleve {
    var age : Int {
        didSet {
            print("I am now \(self.age)")
        }
    }
    init(age : Int) {
        self.age = age
    }
}
let titix = Eleve(age: 18)
titix.age = 20
//: ## Héritage

//: La classe fille **hérite** des propriétés et des méthodes de la classe mère
class Vehicle {
    var nbOfWheels : Int
    var speed : Double
    init (nbOfWheels : Int, speed : Double) {
        self.nbOfWheels = nbOfWheels
        self.speed = speed
    }
    func makeNoise()->String {
        return "vroum"
    }
}

class Bike : Vehicle {
    var hasKlaxon = true
}
let myBike = Bike(nbOfWheels: 2, speed: 40)
myBike.makeNoise()

//: * Exercice accompagné : reprendre Bike mais avec hasKlaxon non prédéfini et nbOfWheels forcé à deux. On va devoir récupèrer l'initializer de la classe mère. Modifier la fontion makenoise de vehicle.
class BikeV2 : Vehicle {
    var hasKlaxon : Bool
    
    init (speed: Double, hasKlaxon : Bool) {
        self.hasKlaxon = hasKlaxon
        super.init(nbOfWheels: 2, speed: speed)
    }
    
    override func makeNoise() -> String {
        return super.makeNoise() + " VVRRRAAAAOOOUUUUUUMMMMM"
    }
}
let myBikeV2 = BikeV2(speed: 80, hasKlaxon: false)

myBikeV2.hasKlaxon
myBikeV2.nbOfWheels
myBikeV2.speed
myBikeV2.makeNoise()
//: On accède aux propriétés et aux méthode de la superclass par `super.`

//: ## Extensions

//: Possibilité d'ajouter des propriétés, des méthodes, des initializer à des classes (ou des struct) existantes. Y compris des classes que l'on n'a pas définies.
extension Vehicle {
    func makeSmallNoise()->String {
        return "pschitt"
    }
    
    var wheelString : String {
        return "wheels = \(self.nbOfWheels)"
    }
}
myBike.makeSmallNoise()
print(myBike.wheelString)

//: * Exercice faire une extension de `String` qui renvoie vrai si la chaîne contient un a. Créer une fonction qui fait la même chose, comparer les syntaxes.
extension String {
    var containsA : Bool {
        return self.rangeOfString("a") != nil
    }
}

"hello".containsA
"papa".containsA

func containsA (name : String)->Bool {
    return name.rangeOfString("a") != nil
}

containsA("hello")

// en fait, cette extension existe .containsString
//: Fonctionnalité très pratique pour effectuer des opérations courantes sur des types standard et bénéficier d'un syntaxe très lisible en point.

//: * Exercice : Une extension qui prend une sousString en paramètre et répond vrai si cette sousstring est incluse dans la string
extension String {
    func containsMyString (myString : String)->Bool {
        return self.rangeOfString(myString) != nil
    }
}

"Hello".containsMyString("lo")

extension Int {
    func plusX(x: Int)->Int {
        return self + x
    }
}

4.plusX(2)//
//: Une extension peut également modifier la variable. On utilise le préfixe mutating.

//: * Petit exercice, faire une extension qui ajoute X à un `Int`.
extension Int {
    mutating func mutatePlusX (x : Int) {
        self += x
    }
}

extension Int {
    mutating func plus1() {
        self += 1
    }
}

var totox = 4
totox.plus1()
totox
//: * Exercice complémentaire : faire une extension sur un `Int` : isPrime
extension Int {
    func isPrime()->Bool {
        if (self >= 2) {
            for index in 2..<self {
                if self % index == 0 {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}

8.isPrime()
23.isPrime()
1.isPrime()

//: ## Enumérations

//: Permettent de définir des types de variables contenant un groupe de valeurs.
enum Directions  {
    case Nord
    case Sud
    case Est
    case Ouest
}
//voir ce qui se passe en auto completion
let myDirection = Directions.Nord
var anotherDirection = Directions.Sud
anotherDirection = myDirection
anotherDirection = .Est //L'inférence de type dispense de rappeler le nom de l'enum
//: On met une majuscule au nom de l'énumération

//: Pratique dans un `switch`
switch myDirection {
case .Nord:
    //do it
    print("vers le Nord")
case .Sud:
    print("vers le sud")
//do it
default:
    print("Aller quelque part")
    //do the default
}

//: Remarque : Quand tous les cas possibles de l'`enum` ont été traités, le `default` n'est pas nécessaire.
//: Peuvent y associer affecter des valeurs comme dans d'autres langages
enum Number : Int {
    case zero = 0
    case deux = 2
    case trois = 3
}

let myZero = Number.zero
print(myZero)
myZero.rawValue // est la valeur associée
// myZero est de type Number
//
//: ## Protocoles

//: Les Protocoles définissent un ensemble de méthodes et de propriétés pour définir une fonctionnalité. Une Classe ou une Struct va se conformer au Protocole en implémentant les méthodes et propriétés demandées par le Protocole.

//: Dans d'autres langages POO, le protocole correspond à une Interface.
protocol MonProtocole {
    // définition du protocole
}

protocol MonAutreProtocole {
    // définition du protocole
}

class MaClasse : MonProtocole, MonAutreProtocole {
    // définition de la classe
}
//: Exemple
protocol canGiveName {
    func giveName ()->String
}

struct Player2 : canGiveName {
    var name : String
    
    func giveName()->String {
        return self.name
    }
}
//: Regarder le message d'erreur si on ne se conforme pas au protocole

//: On peut étendre une classe pour lui permettre de se conformer à un Protocole

//: On utilisera ce type de syntaxe.
struct Player {
    var name : String
    var age : Int?
    var scoreMax = 0
    var credit = 0
}

extension Player : canGiveName {
    func giveName()->String {
        return self.name
    }
}




















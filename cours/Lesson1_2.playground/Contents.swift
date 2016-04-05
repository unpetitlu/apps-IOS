//: # Formation devenez développeur mobile sous iOS avec Swift

//: # Cours 1 Partie 2
//: # Bases du language Swift : chaînes, tableaux, dictionary, tuples
import UIKit

//: ## Chaînes de caractères

//: Initialiser une chaîne vide
let emptyString = ""
let anotherEmptyString = String()
//: * Le type String est passé par valeur, à la différence de l'objective-C où NSString est passé par référence
print(emptyString.isEmpty) // répond true
let myName = "Nicolas"
for character in myName.characters {
    print(character)
}
//: chaque character est de type `Character`

//: * cliquer sur un élément en tenant la touche `alt` pour connaître son type

//: Concatenation par l'opérande +
print("bonjour" + " les gars")
//: Pour compter le nombre d'éléments dans la String, on compte le nombre d'éléments dans le tableau contenant les caractères avec la propriété `.count`
print("Hello".characters.count) // donne 5
//: * attention, "Hello".characters n'est pas un tableau standard

//: On accède aux caractères d'une chaîne non pas par un index entier mais par un type d'index spécifique le `String.index`
var welcome = "Hello guys"
print(welcome[welcome.startIndex])// premier caractère, erreur si chaîne vide
// .endIndex pointe APRES le dernier caractère
print(welcome[welcome.endIndex.predecessor()])//est bien le dernier caractère
print(welcome[welcome.startIndex.successor()]) //renvoie e
// welcome[welcome.endIndex.successor()] // fait planter

let index = welcome.startIndex.advancedBy(4) //caractères à l'index 4 nouveau sous Swift 2.1
print(welcome[index])
//: `.insert` pour insérer un caractère et `.insertContentsOf` pour insérer une chaîne
welcome.insert("a", atIndex: welcome.startIndex)
welcome.insertContentsOf("to all the ".characters, at : welcome.startIndex.advancedBy(7))
//: Detecter si un `String` se trouve dans une `String`
"Hello guys".rangeOfString("lo") // renvoie 3..<5
"Hello guys".rangeOfString("a") // renvoie nil

//: Pour supprimer : `.removeAtIndex` et `removeRange`
welcome.removeAtIndex(welcome.startIndex)
print(welcome)
let range = welcome.startIndex.advancedBy(6)..<welcome.startIndex.advancedBy(17)
welcome.removeRange(range)
print(welcome)
//: Pour remplacer une substring par une string (`str_replace`) en PHP
let replaced = welcome.stringByReplacingOccurrencesOfString("l", withString: "LL")
//: Comparaison
let coucouString = "coucou"
coucouString == "coucou" //renvoi true
"bonjour".hasPrefix("bo") // renvoi true
"bonjour".hasPrefix("ou") // renvoi false
"bonjour".hasSuffix("ur") //renvoi true
//: Note : on va introduire les NSString de Objective-C plus tard dans le cours.

//: ## Les tableaux : Arrays

//: Sont des listes ordonnées d'éléments de **même type**, défini à l'avance
var myInts = [Int]() //déclare un tableau vide d'entiers, son type s'écrit : `Array<Int>' ou `[Int]`
myInts.append(18) //ajoute l'élément à la suite (équivalent à `array_push`)
myInts.append(21)
print(myInts)
var listeDeCourse = ["lait","oeufs"] //créé un tableau directement avec ses éléments
// listeDeCourse.append(2) donne une erreur
//: Nombre d'éléments dans le tableau `.count`
listeDeCourse.count
listeDeCourse.isEmpty
//: On accède ou on modifie à un élément donné par un index *entier*. 0 désigne le premier élément
listeDeCourse[0]
listeDeCourse[1] = "patates"
listeDeCourse
listeDeCourse.insert("sopalin", atIndex: 1)
listeDeCourse.removeAtIndex(0)
listeDeCourse.indexOf("patates") //renvoi la position de l'élément si il est dans le tableau
listeDeCourse.indexOf("bière") //renvoi nil, car l'élément n'est pas dans le tableau

//: * regarder l'auto completion pour voir la liste des fonctions disponibles
// listeDeCourse[2]//donne une erreur
//: * **Attention**, accéder à un index invalide d'un tableau fait planter le programme erreur BAD ACCESS

//: syntaxe subscript avec un range
var clubsDeFoot = ["psg", "om", "ol", "bordeaux"]
clubsDeFoot[1...2] //renvoie ["om","ol"]
//: Parcourir un tableau
for club in clubsDeFoot {
    print(club)
}
//: Exercice. Ecrire une fonction qui prend un tableau de Double et retourne le plus grand élément.
func maxArray(tableau : [Double])->Double {
    var output = 0.0
    for item in tableau {
        if item > output {
            output = item
        }
    }
    return output
}
maxArray([4, 84.5, 9])

//: ## Exercices
//: Ecrire et tester une fonction qui prend un tableau d'entier et affiche ces entiers les uns à la suite des autres
//: Ecrire et tester une fonction qui prend un tableau d'entiers et renvoie un tableau contenant uniquement les nombres pairs.
// version où les nombres sont affichés ligne après ligne
func afficheTableau(tableau : [Int]) {
    for myInt in tableau {
        print(myInt)
    }
}
afficheTableau(myInts)

//version où les nombres sont sur la même ligne
func afficheTableauV2(tableau : [Int]) {
    // output va contenir les nombres
    var output = ""
    for myInt in tableau {
        output += "\(myInt) "
    }
    print(output)
}
afficheTableauV2(myInts)

//: * Il faut créer les tableaux multidimensionnels à la main

//: ## Petit exercice
//: Ecrire et tester ne fonction qui prend un tabeau d'entiers et renvoie ce tableau retourné (le dernier à la place du premier, etc ...)

func retourne (tableau : [Int])->[Int] {
    var resultat = [Int]()
    
    for item in tableau {
        resultat.insert(item, atIndex: 0)
    }
    return resultat
}

let entiers = [0, 2 , 3, 4]
// retourne(clubsDeFoot) ne marche pas car ce ne sont pas des Tint
retourne(entiers)
retourne([]) // oui, fonctionne avec un tableau vide
entiers
//: Pour une même fonction qui permettrait de retourner tout type de tableau, quel que soit le type de ses éléments. On utilise le concept de **générique**
func retourneTout<T> (tableau : [T])->[T] {
    var resultat = [T]()
    
    for item in tableau {
        resultat.insert(item, atIndex: 0)
    }
    return resultat
}

retourneTout(clubsDeFoot)
//: Exercice.

//: Récursivité possible
func factorielle (n: Int)->Int {
    if n > 1 {
        return n * factorielle(n - 1)
    } else {
        return 1
    }
}

factorielle(3)

//: ## Exercice.
//: Ecrire et tester une fonction qui supprime les voyelles d'une chaîne. Ceci de 5 façons différentes. Bien tester avec la chaîne vide.
//: Donner la fonction .lowercaseString
//avec une boucle et un test bestial
func removeVowelsV1 (myString : String)->String {
    var resultat = ""
    
    for item in myString.characters {
        let lowercaseItem = String(item).lowercaseString
        if ( (lowercaseItem != "a") && (lowercaseItem != "e") && (lowercaseItem != "i") && (lowercaseItem != "o") && (lowercaseItem != "u") && (lowercaseItem != "y") ) {
            resultat += String(item)
        }
    }
    return resultat
}

// avec stringByReplacingOccurencesOfString
func removeVowelsV2 (myString : String)->String {
    return myString.stringByReplacingOccurrencesOfString("a", withString: "")
        .stringByReplacingOccurrencesOfString("e", withString: "")
        .stringByReplacingOccurrencesOfString("e", withString: "")
        .stringByReplacingOccurrencesOfString("i", withString: "")
        .stringByReplacingOccurrencesOfString("o", withString: "")
        .stringByReplacingOccurrencesOfString("u", withString: "")
        .stringByReplacingOccurrencesOfString("A", withString: "")
        .stringByReplacingOccurrencesOfString("E", withString: "")
        .stringByReplacingOccurrencesOfString("I", withString: "")
        .stringByReplacingOccurrencesOfString("O", withString: "")
        .stringByReplacingOccurrencesOfString("U", withString: "")
}


// avec recherche dans un tableau des lettres à enlever
func removeVowelsV3a (myString : String)->String {
    var resultat = myString
    let vowels = ["a", "e", "i", "o", "u"]
    
    for item in vowels {
        resultat = resultat.stringByReplacingOccurrencesOfString(item, withString: "")
    }
    return resultat
}

// avec recherche dans un tableau des lettres à enlever
func removeVowelsV3 (myString : String)->String {
    var resultat = ""
    let vowels = ["a", "e", "i", "o", "u"]
    
    for item in myString.characters {
        if vowels.indexOf(String(item).lowercaseString) == nil {
            resultat += String(item)
        }
    }
    return resultat
}

func isVowel (letter : Character)->Bool {
    let vowels = ["a", "e", "i", "o", "u", "y"]
    return vowels.indexOf(String(letter).lowercaseString) != nil
}

// variante avec une fonction de test à part
func removeVowelsV4 (myString : String)->String {
    var resultat = ""
    
    for item in myString.characters {
        if !isVowel(item) {
            resultat += String(item)
        }
    }
    return resultat
}

/*
 func removeVowelsV4 (myString : String)->String {
 var resultat = myString
 
 
 // return resultat.characters.filter{!"aeiou".characters.contains($0)}
 }
 */
let testString = "Alors les petits gars. Comment ça va"
//let testString = ""

removeVowelsV1(testString)
removeVowelsV2(testString)
removeVowelsV3(testString)
removeVowelsV3a(testString)
removeVowelsV4(testString)

testString

//variante du isVowel
func isVowel2 (letter : Character)->Bool {
    return "aeiou".characters.contains(letter)
}

let vowels = ["a", "e", "i", "o", "u"]

func removeVowelsV5 (myString : String)->String {
    // return String(myString.lowercaseString.characters.filter{!isVowel($0)})
    return String(myString.characters.filter{vowels.indexOf(String($0).lowercaseString) == nil})
}

let theResult = removeVowelsV5(testString)
theResult

"toto".characters.indices

//: ## Dictionaries
//: Ensemble non ordonné d'associations clé / valeur
//: les clés doivent être du même type
//: les valeurs doivent être du même type

//: Le type d'un `Dictionary` s'écrit `Dictionary<Cle, Valeur>`
//: Dans le même esprit qu'un tableau associatif en PHP. Sauf que les clés en valeur peuvent être de tout type.

var aeroports = ["LAX" : "Los Angeles", "CDG" : "Charles de Gaulle"]
var classement = [1 : "Pim", 3  : "Pam", 4 : "Poum"]
var dictionaryVide = [String : Double] ()
dictionaryVide["hello"] = 8
aeroports.count
dictionaryVide.isEmpty
aeroports["LAX"]
aeroports["toto"]
classement[2]
var unEssai = ["premier" : listeDeCourse, "deuxieme" : clubsDeFoot ]

unEssai["premier"]
unEssai["troisieme"]// renvoi `nil` car cet index n'est pas disponible. Il ne fait pas planter le programme.
unEssai["premier"] = nil //pour supprimer un élément
unEssai
//: ### parcourir un dictionnaire

for (maCle, maValeur) in aeroports {
    print("\(maCle) \(maValeur)")
}

for maCle in aeroports.keys {//itérer ses les clés
}

for maValeur in aeroports.values {// itérer sur les valeurs
}

//## Exercice : écrire une fonction qui prend comme argument un tableau comme ci-dessous et qui imprime la meilleure note unitaire et le nom de l'élève qui a la meilleure moyenne
let resultats = [
    "pim" : [14, 12, 17],
    "pam" : [8, 6, 18],
    "poum" : [9, 4, 3]
]

func meilleursNotes (resultats : [String : [Int]]) {
    var meilleurEleve = ""
    var meilleureNote = 0
    var meilleureMoyenne = 0.0
    
    for (nom, notes) in resultats {
        var moyenne = 0.0
        for uneNote in notes {
            moyenne += Double(uneNote)
            if uneNote > meilleureNote {
                meilleureNote = uneNote
            }
        }
        
        moyenne = moyenne / Double(notes.count)
        if (moyenne > meilleureMoyenne) {
            meilleureMoyenne = moyenne
            meilleurEleve = nom
        }
    }
    
    print("la meilleure note est \(meilleureNote)")
    print("le meilleur élève est \(meilleurEleve) avec \(meilleureMoyenne) de moyenne")
}

meilleursNotes(resultats)

// Option: Mettre en forme le résultat avec un NSNumberFormatter
var formatter = NSNumberFormatter()
formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
formatter.maximumFractionDigits = 2
print(formatter.stringFromNumber(14.15698888))

//: ## Les tuples

//: Regroupe plusieurs valeurs de types potentiellement différents

//: créer un Tuple
let myFirstTuple = ("toto", 14, [14, 15]) //sans spécifier le nom des variables
let premierEleve = (prenom : "John", nom : "Doe", age : 24)
print(premierEleve.nom)
var janeDoe = premierEleve
janeDoe.prenom = "Jane"
janeDoe
//: On utilise les Tuples pour renvoyer plusieurs valeurs dans une fonction
func sinusEtCosinus(x : Double)->(sinus : Double,  Double) {
    return (sin(x), cos(x))
}
sinusEtCosinus(M_PI)
sinusEtCosinus

//: on peut accéder aux éléments du tuple par leur numéro
janeDoe.0 //renvoit Jane
janeDoe.1 // renvoit Doe
//: Ou affecter les éléments du Tuple à des variables
let (nom, prenom, age) = janeDoe
nom
prenom
age
//: Petit exercice. Reprendre la fonction de l'exercice précedent pour renvoyer un tuple
func meilleursNotesV2 (resultats : [String : [Int]])->(meilleureNote: Int, meilleurEleve: String) {
    var meilleurEleve = ""
    var meilleureNote = 0
    var meilleureMoyenne = 0.0
    
    for (nom, notes) in resultats {
        var moyenne = 0.0
        for uneNote in notes {
            moyenne += Double(uneNote)
            if uneNote > meilleureNote {
                meilleureNote = uneNote
            }
        }
        
        moyenne = moyenne / Double(notes.count)
        if (moyenne > meilleureMoyenne) {
            meilleureMoyenne = moyenne
            meilleurEleve = nom
        }
    }
    
    return (meilleureNote, meilleurEleve)
}

meilleursNotesV2(resultats).meilleurEleve























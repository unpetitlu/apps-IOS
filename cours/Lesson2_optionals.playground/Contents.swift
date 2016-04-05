//: # Formation devenez développeur mobile sous iOS avec Swift

//: # Cours 2 Les Optionals
import UIKit

//: Les Optionals sont des variables qui peuvent, soit avoir une valeur d'un certain type, soit ne pas être définies, elle retournent alors nil

//: Les variables non optionnelles ne peuvent pas être nil

//: De nombreuses fonctions ou API renvoient une Optional car il n'est pas garanti qu'elles puissent renvoyer une valeur

//: Exemple : conversion de Type. Int() renvoie un Int Optional

//: C'est fondamental. Beaucoup utilisé dans les API en Swift.

let unNombreEnString = "18"
let unNombre = Int(unNombreEnString)
//: alt + clic sur unNombre, son type est Int?

//: c'est un optional d'entier
print(unNombre) //affiche Optional(18)

let unAutreNombre = Int("dixhuit")
print(unAutreNombre) // affiche nil

//: On peut aussi définir un optional
var optionalInt : Int?
//: Important : pour déterminer si un Optionel a une valeur ou pas

if unAutreNombre != nil {
    print("on a une valeur")
} else {
    print("pas de valeur")
}
//: * Essayer avec différentes variables. Essayer avec une valeur qui n'a pas été définie.

//: On ne peut pas utiliser l'optionel pour des calculs. Pour obtenir la valeur, il faut faire un **forced unwrapping**, avec le caractère !

if unNombre != nil {
    print("on a une valeur:\(unNombre!)")
} else {
    print("pas de valeur")
}

unNombre!

//: le ! signifie : je sais qu'il y a une valeur, et je veux cette valeur. Si on s'est trompé : plantage

//: On peut aussi utiliser une optionel en paramètre d'une fonction

//: * écrire une fonction qui prend en paramètre nom et optionnellement le prénom et qui renvoie une chaîne prénom + nom
func makeName(nom : String, prenom : String?)->String {
    if prenom != nil {
        return prenom! + " " + nom
    } else {
        return nom
    }
}
makeName("Lehovetzki", prenom: "Nicolas")
makeName("Lehovetzki", prenom: nil)
//: ## Optional Binding
//: Syntaxe très importante. On teste l'existence d'une valeur pour la variable et on utilise la variable si elle a une valeur.

//optionalInt = 4
if let myNumber = optionalInt {
    print(myNumber)
} else {
    print("no value for myNumber")
}
//: * définir une valeur pour optionalInt et voir l'effet

//: * Exercice. Ecrire une fonction qui prend un entier qui renvoie un optionel : sa racine carré si l'entier est positif ou nul et nil si l'entier est négatif. Utiliser cette fonction avec un if let
func squareRoot(number : Int)->Double? {
    return number >= 0 ? sqrt(Double(number)) : nil
}

let input = -5
if let result = squareRoot(input) {
    print("positive and square root=\(result)")
} else {
    print("negative")
}

//: Sources

//: [http://www.appcoda.com/beginners-guide-optionals-swift/](http://www.appcoda.com/beginners-guide-optionals-swift/)

//: [Doc Apple](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309)









//: # Formation devenez développeur mobile sous iOS avec Swift

//: # Cours 1 Partie 1
//: # Bases du language Swift : variables, contrôle, boucles
//: Le playground permet d'exécuter le code Swift. Il nous permettra d'apprendre les bases de Swift avant de passer à l'environnement iOS avec Xcode

//: * Le playground est très pratique pour tester des fonctions utilitaires avant de les intégrer dans le programme

//: ## Variables

//: Swift est un langage fortement typé.

//: * Les constantes et variables doivent être déclarées, typées et initialisées avant d'être utilisées.

//: Pour déclarer une **constante**, sa valeur ne peut pas être modifiée :
let myInt : Int // déclare un entier Int
//: Pour déclarer une **variable**, sa valeur sera modifiée :
var name : String // déclare une chaîne de caractère String
//: * A noter : un warning est généré dans Xcode si la variable ne change jamais de valeur.

//: Autres type de variable de base :
var x : Double // nombre flottant codé sur 64 bits
let y : Float // nombre flottant codé sur 32 bits
//: **Inférence de type**. Swift attribue automatiquement le type en fonction de la valeur initiale
let lost = false // déclare un Booléen, est équivalent à :
let found : Bool
found = false

let pi = 3.14159 //déclare un Double
let welcomeMessage = "Welcome" // déclare une chaîne de caractères
//: * Il est recommandé de déclarer ainsi les variables et donc de déclarer leur valeur initiale.

//: Fonction simple pour afficher une variable dans la console :
print("hello guys")
print(pi)
// print(x) génère une erreur car la valeur de x n'a pas été fixée
print("\(welcomeMessage) everybody")// syntaxe pour intégrer une variable dans une chaîne
//: ## Assigner les variables
name = "Nicolas"
x = 4.5
myInt = 18
//: * important. Les types de variable de base sont passés par **valeur**.
var a = 2
var b = a
b = b + 1
print("a vaut \(a)")//affiche 2. a vaut toujours 2
print("b vaut \(b)")//affiche 3.
a = a + 1
b = b + 1
//: ## Opérations
//: Les opérandes doivent être de même type
1 + 2 //vaut 3
// y = nbEtudiants + 2.1 ne compile pas
x = Double(myInt) + 2.1 // est correct, on a forcé la conversion en Double de myInt
"bonjour" + " les gars" //concaténation de chaîne. C'est plus compliqué en Objective-C
b += 3 //la valeur de b est incrémentée de 3
//: cas de l'opérateur ++
var z = 0
print(z++)//affiche 0 car la valeur est renvoyée AVANT d'être incrémentée
print(z) // affiche 1

z = 0
print(++z)//affiche 1 car la valeur est renvoyée APRES avoir été incrémentée
print(z) // affiche 1
//: Comparaisons
z == 1 // renvoie true
z != 1 // renvoie false
z > 0 //renvoie true
lost && found //ET
lost || found //OU

//: * raccourci clavier alt+shift+l pour le caractère pipe sur le clavier mac
//On peut aussi comparer des chaînes de caractères.
name == "Toto" //renvoie false
//: opérateur ternaire : question ? reponseSiVrai : reponseSiFaux
//: Opérateur ternaire
print("\((z == 2) ? "ils sont egaux" : "pas egaux")")
//:* Exercice : jouer sur le playground avec les variables. voir les messages d'erreur si on a pas initialisé une variable. Si une change une constante. Si on effectue des opérations sur des variables de type différent.

//: ## Branchement conditionel
if z == 1 {
    //code à executer si vrai
} else {
    //code si faux
}
//: * Les parenthèses ne sont pas obligatoires sur la condition. Mais nous allons parfois en mettre pour la clarté du code.

//: ## Boucle **for**
for index in 1...10 {//boucle de 1 à 10
    print("the index is \(index)")
}

//index est déclarée ici implicitement
//: Fonction dans le style C
for var totox = 0; totox < 10 ; totox++ {
    print("toto")
}
//: ## Boucle **while**

z = 0
while (z <= 10) {
    print(z)
    z++
}// est effectuée 10 fois
//: * attention aux boucles infinies !

//: ## Boucle **repeat** - **while**

z = 0
repeat {
    print(z)
    z++
} while (z <= 10)
//est effectué 11 fois

//: ## Fonctions

//: Fonction sans argument ni valeur de sortie
func myFirstFunction () {
    print("I did it!")
}
//appelée comme ceci
myFirstFunction()

//: Fonction avec argument mais pas de valeur de sortie
func affichePlusUn (x : Int) {
    print("\(x + 1)")
}

//: Fonction avec argument et valeur de sortie
func plusUn (x : Int)->Int {
    return x + 1
}

print(plusUn(2)) //affiche 3

func additionEntiere(x: Int, y : Int)->Int {
    return x + y
}
//: quand on appelle une fonction, on n'a pas besoin de rappeler le nom de la première variable
additionEntiere(4, y: 5)
//: Exercice très facile. Une fonction sayHello qui prend une String et renvoie Bonjour suivi du nom.
func sayHello(name : String)->String {
    return "Bonjour \(name)"
  // variante:  return "Bonjour " + name
}
//: ## Petit exercice facile

//: * créer deux variables Double et une fonction 'division' qui effectue la division des deux nombres et la renvoie dans une chaîne. Dans le cas où le diviseur est 0, la chaîne est 'on ne peut pas diviser <valeur du numérateur> par 0'. tester la fonction. essayer d'envoyer une variable entière dans la fonction
// solution possible
func division (a: Double, b: Double)->String {
    if (b != 0) {
        return "\(a / b)"
    } else {
        return "on ne peut pas diviser \(a) par 0"
    }
}

var number1 = 4.0
var number2 = 0.0

division(number1, b: number2)
number2++
division(number1, b: number2)
division(4 ,b: 7)
division(2, b: 8.0)
// division(myInt, b: 4) génère un message d'erreur


















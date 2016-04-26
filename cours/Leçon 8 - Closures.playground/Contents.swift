//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let myClosure =
{(entier: Int) -> Int in
return entier + 1
}

myClosure(1)

func plusUn (entier: Int) -> Int
{
return entier + 1
}

plusUn(45)

let sayHello =
{() -> Void in

print("Hello")
}

sayHello()

// Closures issues du mainviewcontroller de tableview, (les accolades sont mises un peu différemment)

let cancelAction = UIAlertAction(title: "Cancel", style: .Default)
{_ in
    print("ajout annulé)")
}

let more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "More")
{action, index in
    print("more button tapped")
}



//                              Functionnal programming (programmation fonctionnelle)


let myArray = [2,9,104,45,64,7,21,12,79,85]

func biggerThanTen (nombre: Int) -> Bool
{
    return nombre > 10
}

func filterArray (numbers: [Int]) -> [Int]
{
    var output = [Int]()
    for number in numbers
    {
       if biggerThanTen(number)
        {
            output.append(number)
        }
    }
  return output
}

filterArray(myArray)

myArray.filter(biggerThanTen)

var filtered = myArray.filter(biggerThanTen)

let biggerThanTenClosure =
{(nombre: Int) -> Bool in
    
        return nombre > 10
}

biggerThanTenClosure(16)


myArray.filter({(nombre: Int) -> Bool in
    return nombre > 10})


myArray.filter{(nombre: Int) -> Bool in
    return nombre > 10}


myArray.filter({(nombre) in nombre > 10})


myArray.filter{$0 > 10}

var doubleArray = [10.0, 12.0, 15.0]

doubleArray.filter{$0 > 10}

struct Eleve
{
    var nom : String
    var age : Int
}

var eleves = [Eleve]()
eleves.append(Eleve(nom: "Kevin", age: 23))
eleves.append(Eleve(nom: "David", age: 17))



var adultes = eleves.filter{(eleve) in eleve.age > 17}
var adultes2 = eleves.filter{$0.age > 17}


print(myArray.map{$0 * 2})

print(myArray.map{_ in "toto"})

print(myArray.map{$0 > 16 ? "Ce nombre \($0) est grand" : "Ce nombre \($0) n'est pas si grand"})

print(myArray.sort{$1 < $0})
print(eleves.filter{$0.age > 18}.sort{$0.age < $1.age})



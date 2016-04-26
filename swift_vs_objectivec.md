# Swift vs Objective-C

### Principaux types

Swift  | Objective-C
------------- | -------------
`Int`  | `NSInteger` ou `int`
`Bool` | `Boolean` ou `bool`
`String` | `NSString`
`Array` | `NSArray`
`Dictionary` | `NSDictionary`
`true` | `YES`
`false` | `NO`

### Principales différences
Swift  | Objective-C
------------- | -------------
Elements in Array : same type | Elements in Array : possible different type
String, Int, Array are value types | NSString, NSInteger, NSArray... are reference types
Un seul fichier | .h et .m

### Définitions de variables
```swift
let myString = "hello"
var a = 4
```
```objectivec
NSString *myString = @"hello";
int a = 4;
NSInteger b = 5;
```
### Créer un objet UIKit, exemple UIView et UIImage
```swift
let myView = UIView(frame: myRect)
let myImage = UIImage(named: "image.png")
```
```objectivec
 UIView *myView = [[UIView alloc] initWithFrame:myRect]; 
 UIImage *myImage = [UIImage imageNamed:@"image.png"];

```

### Définir et appeler une fonction

```swift
func sayHello(name : String, age: Int)->String {
    return "Hello \(name), you are \(age)"
}
myString = sayHello("toto", age: 18)
```

```objectivec
-(NSString*) sayHello:(NSString*) name age:(int)age {
    return [NSString stringWithFormat:@"Hello %@ you are %d",name, age];
}
myString = [self sayHello:@"toto" age:18];
```
### Création d'un tableau non modifiable
```swift
let myArray = [4,5,8]
```
```objectivec
NSArray *myArray = @[@4, @5, @6];
```
### Tableau modifiable
```swift
var myArray = [4,5]
myArray.append(6)
```
```objectivec
NSMutableArray *myArray = [[NSMutableArray alloc]init];
[myArray addObject:[NSNumber numberWithInt:4]];
[myArray addObject:[NSNumber numberWithInt:5]];
[myArray addObject:[NSNumber numberWithInt:6]];
```
### Dictionary modifiable
```swift
var myDict = [ "john" : 4, "paul" : 6]
myDict["lisa"] = 7
```
```objectivec
NSMutableDictionary *myDict = [[NSMutableDictionary alloc]init];
[myDict setObject:[NSNumber numberWithInt:4] forKey:@"john"];
```
### Définir une propriété d'un objet
```swift
myView.userInteractionEnabled = true
```
```objectivec
myView.userInteractionEnabled = YES;
[myView setUserInteractionEnabled] = YES;
```
### IBAction et IBOutlet
```swift
@IBOutlet var myLabel : UILabel!
myLabel.hidden = true

@IBAction func buttonPressed() {
}
```
```objectivec
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
_myLabel.hidden = YES;

- (IBAction) buttonPressed {
}
```
### Créer et utiliser une classe
```swift
class MyClass : OptSuperClass, OptProtocol {
	var property : Int
	//si sous classe
	override init() {
		myProperty = 8
	}
}
// utilisation
var myInstance = MyClass()
myInstance.property = 7
```
```objectivec
// MyClass.h
@interface MyClass : OptSuperClass
	//definir les méthodes et propriétés publiques
@end

// MyClass.m
#import "MyClass.h"
@interface MyClass()
// definir les méthodes et propriétés privées
@end

@implementation MyClass {
// définir les variables d'instance privées
}
// définir les méthodes de la classe
@end
// utilisation
MyClass *myInstance = [[MyClass alloc]init];
myInstance.property = 9;
```
### Conversion de type
```swift
let b = 2.1 //double
let a : Int = Int(b) // a vaut 2
let c = Int("18")! // string to int
let d = "\(myDouble) \(myInt)"
```
```objectivec
double b = 2.1;
int a = (int)b;
int c = @"18".intValue; // string to int
NSString *d = [NSString stringWithFormat:@"%f %d",myDouble, myInt];
```
# Exercice traduction en swift
## `swiftvsobjectiveC` version Objective-C

Ajouter un viewController en swift et traduite le .h et .m en un seul fichier swift.

Bien utiliser l'auto completion.

* Commencer par `viewDidLoad`. Il y aura des IBOutlets à créer ainsi que des variables d'instance.
* Puis `fetchAvailableProducts`
* `canMakePurchases`
* `purchaseMyProduct`
* `purchase` avec une difficulté : validProducts est un Array de SKProduct. Il faut en définir le type en Swift. Il faut également remplacer `id ` par `AnyObject`
* Pour `paymentQueue`, bien utiliser l'auto completion
* Option : le body du `didReceiveResponse`
import UIKit

// CREATIOANL PATTERNS
// Creational patterns support the creation of objects or how an object is created
// Postoje dve ideje koje stoje iza Creational patterna
//    - krerianje neophodnih tipova podataka
//    - skrivanje kreiranje instanci ovih tipova podataka
//  1) Abstract factory pattern - kreiraju se relacioni objekti bez specificiranje tipova podataka
//  2) Builder pattern - razdvaja formiranje slozenih objekata od njihovog reprezentovanja, tako da se isti proces moze koristiti za slicne tipove podataka
//  3) Factory method pattern - kreira objekat bez prikazivanja logike kako je kreiran ili kog tipa je objekat
//  4) Prototype pattern - kreira objekat kloniranjem postojeceg objekta
//  5) Singleton pattern - formira se jedna i samo jedna instanca klase tokom lifetime-a aplikacije


// Singleton

class MySingleton {
    static let sharedInstance = MySingleton()
    private init() {} //sprecava ostatak koda da kreira jos jednu instancu ove klase
    var number = 0
}

class MySingleton2 {
    private static var _shared = MySingleton2()
    public static var shared: MySingleton2 {
        return _shared
    }
    public var property: String!
}

var singleA = MySingleton.sharedInstance
var singleB = MySingleton.sharedInstance
var singleC = MySingleton.sharedInstance

singleB.number = 2

print(singleA.number)
print(singleB.number)
print(singleC.number)

singleC.number = 3

print(singleA.number)
print(singleB.number)
print(singleC.number)




// Builder pattern
// Koristi se kada instanci odredjenog tipa treba veliki broj konfigurisucih vrednosti

struct BurgerOld {
    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var ketchup: Bool
    var mustard: Bool
    var lettuce: Bool
    var tomato: Bool
    
    init(name: String, patties: Int, bacon: Bool, cheese: Bool, pickles: Bool,ketchup: Bool,mustard: Bool,lettuce: Bool,tomato: Bool) {
        self.name = name
        self.patties = patties
        self.bacon = bacon
        self.cheese = cheese
        self.pickles = pickles
        self.ketchup = ketchup
        self.mustard = mustard
        self.lettuce = lettuce
        self.tomato = tomato
    }
}

// ova struktura ne koristi Builder pattern, i ovo moze dovesti do veoma slozene inicijalizaije, npr:

var hamburger = BurgerOld(name: "Hamburger", patties: 1, bacon: false, cheese: false, pickles: false, ketchup: false, mustard: false, lettuce: false, tomato: false)

var cheeseburger = BurgerOld(name: "Cheeseburger", patties: 1, bacon: false, cheese: false, pickles: false, ketchup: false, mustard: false, lettuce: false, tomato: false)

//Prva varijanta Builder patterna kod kog se koristi vise razlicitih builder tipova

protocol BurgerBuilder { //setovan builder
    var name: String {get}
    var patties: Int {get}
    var bacon: Bool {get}
    var cheese: Bool {get}
    var pickles: Bool {get}
    var ketchup: Bool {get}
    var mustard: Bool {get}
    var lettuce: Bool {get}
    var tomato: Bool {get}
}

struct HamBurgerBuilder: BurgerBuilder { // setovan prvi tip buildera
    let name = "Burger"
    let patties = 1
    let bacon = false
    let cheese = false
    let pickles = true
    let ketchup = true
    let mustard = true
    let lettuce = false
    let tomato = false
}

struct CheeseBurgerBuilder: BurgerBuilder { // setovan drugi tip buildera
    let name = "CheeseBurger"
    let patties = 1
    let bacon = false
    let cheese = true
    let pickles = true
    let ketchup = true
    let mustard = true
    let lettuce = false
    let tomato = false
}

struct Burger { // setovan opsti tip buildera
    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var ketchup: Bool
    var mustard: Bool
    var lettuce: Bool
    var tomato: Bool
    
    init(builder: BurgerBuilder) {
        self.name = builder.name
        self.patties = builder.patties
        self.bacon = builder.bacon
        self.cheese = builder.cheese
        self.pickles = builder.pickles
        self.ketchup = builder.ketchup
        self.mustard = builder.mustard
        self.lettuce = builder.lettuce
        self.tomato = builder.tomato
    }
    
    func showBurger() {
        print("Name:    \(name)")
        print("Patties: \(patties)")
        print("Bacon:   \(bacon)")
        print("Cheese:  \(cheese)")
        print("Pickles: \(pickles)")
        print("Ketchup: \(ketchup)")
        print("Mustard: \(mustard)")
        print("Lettuce: \(lettuce)")
        print("Tomato:  \(tomato)")
    }
}

var myBurger = Burger(builder: HamBurgerBuilder()) //pozvan builder sa prvim tipom
myBurger.showBurger()

var myCheeseBurgerBuilder = CheeseBurgerBuilder() //pozvan builder sa drugim tipom
var myCheeseBurger = Burger(builder: myCheeseBurgerBuilder)

// izmene, ukoliko su potrebne
myCheeseBurger.tomato = false
myCheeseBurger.showBurger()

// Druga varijanta koriscenja Builder patterna, u kojoj se ne koriste razliciti builder tipovi kao sto su HamBurgerBuilder i CheeseBurgerBuilder, vec se koristi jedan tip

struct BurgBuilder {
    var name = "Burger"
    var patties = 1
    var bacon = false
    var cheese = false
    var pickles = true
    var ketchup = true
    var mustard = true
    var lettuce = false
    var tomato = false
    
    mutating func setPatties(choice: Int) {
        self.patties = choice
        
    }
    mutating func setBacon(choice: Bool) {
        self.bacon = choice
        
    }
    mutating func setCheese(choice: Bool) {
        self.cheese = choice
        
    }
    mutating func setPickles(choice: Bool) {
        self.pickles = choice
        
    }
    mutating func setKetchup(choice: Bool) {
        self.ketchup = choice
        
    }
    mutating func setMustard(choice: Bool) {
        self.mustard = choice
        
    }
    mutating func setLettuce(choice: Bool) {
        self.lettuce = choice
        
    }
    mutating func setTomato(choice: Bool) {
        self.tomato = choice
        
    }
    
    func buildBurgerOld(name: String) -> BurgerOld {
        return BurgerOld(name: name, patties: self.patties,
                         bacon: self.bacon, cheese: self.cheese,
                         pickles: self.pickles, ketchup: self.ketchup,
                         mustard: self.mustard, lettuce: self.lettuce,
                         tomato: self.tomato)
    }
}


var burgerBuilder = BurgBuilder()
burgerBuilder.setCheese(choice: true)
burgerBuilder.setBacon(choice: true)
var jonBurger = burgerBuilder.buildBurgerOld(name: "Jon's Burger")


// Factory pattern
//Ovaj patern koristi metode da bi kreirao instance objekata bez preciziranja koji tip ce biti kreiran.
//Upotrebljava se kada ima vise tipova podataka koji se podvrgavaju jednom protokolu

protocol TextValidationProtocol {
    var regExFindMatchString: String {get}
    var validationMessage: String {get}
}

extension TextValidationProtocol {
    
    var regExMatchingString: String {
        get {
            return regExFindMatchString + "$"
        }
    }
    
    func validateString(str: String) -> Bool {
        if let _ =  str.range(of: regExMatchingString, options: .regularExpression) {
            return true
        } else {
            return false
        }
    }
    func getMatchingString(str: String) -> String? {
        if let newMatch =  str.range(of: regExFindMatchString, options: .regularExpression) {
            return str.substring(with: newMatch)
        } else {
            return nil
        }
    }
}

//Sada cu napravit tri tipa koji se podvrgavaju ovom protokolu
class AlphaValidation: TextValidationProtocol {
    static let sharedInstance = AlphaValidation()
    private init(){}
    
    let regExFindMatchString = "^[a-zA-Z]{0,10}"
    let validationMessage = "Can only contain Alpha characters"
}

class AlphaNumericValidation: TextValidationProtocol {
    static let sharedInstance = AlphaNumericValidation()
    private init(){}
    
    let regExFindMatchString = "^[a-zA-Z0-9]{0,10}"
    let validationMessage = "Can only contain Alpha Numeric characters"
}

class NumericValidation: TextValidationProtocol {
    static let sharedInstance = NumericValidation()
    private init(){}
    
    let regExFindMatchString = "^[0-9]{0,10}"
    let validationMessage = "Display Name can contain a maximum of 15 Alphanumeric Characters"
}

//da bismo mogli da odredimo koju od ove tri validirajuce klase da koristimo, na osnovu stringa koji se validira, korisitcemo Factory pattern metodu
func getValidator(alphaCharacters: Bool, numericCharacters: Bool) -> TextValidationProtocol? {
    if alphaCharacters && numericCharacters {
        return AlphaNumericValidation.sharedInstance
    } else if alphaCharacters && !numericCharacters {
        return AlphaValidation.sharedInstance
    } else if !alphaCharacters && numericCharacters {
        return NumericValidation.sharedInstance
    } else {
        return nil
    }
}
//prednost ovog paterna je izbor validirajuce klase iz skupa validirajucih klasa u jednoj funkciji
var str = "abc123"

var validator1 = getValidator(alphaCharacters: true, numericCharacters: false)
print("String validated: \(String(describing: validator1!.validateString(str: str)))")

var validator2 = getValidator(alphaCharacters: true, numericCharacters: true)
print("String validated: \(String(describing: validator2!.validateString(str: str)))")








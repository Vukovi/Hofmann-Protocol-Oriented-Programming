import UIKit

// Behavioral design patterns

// Ovi paterni omogucuju laksu interakciju izmedju razlicitih tipova podataka, tj kako jedni tipovi
// salju poruke drugim tipovima da bi se desile odredjene akcije.
// Postoji devet dobro poznatih paterna:

// 1) Chain of responibility - koristi se da bi se obradio veliki broj request-ova, a svaki od njih moze biti delegiran razlicitom handleru
// 2) Command - kreira objekte koji mogu da enkapsuliraju akcije ili parametre, kako bi oni mogli biti kasnije pozvani ili pozvani nekom drugom komponentom
// 3) Iterator - omogucava nam da pristupimo elementima objekta redom, ali bez otkrivanja strukture objekta
// 4) Mediator - smanjuje spajanje izmedju tipova koji medjusobno komuniciraju
// 5) Memento - korsti se da bi se sacuvalo trenutno stanje objekta na nacin da se kasnije moze koristiti
// 6) Observer - omogucuje da objekat pablisuje svoje promene, a drugi objekti mogu slusati objavu i preduzeti akcije
// 7) State - koristi se da se promeni ponassanje objekta, kada se njegovo unutrasnje stanje promeni
// 8) Strategy - ovim se omogucava da se odabere jedan od algoritama tokom runtime-a
// 9) Visitor - ovim se odvaja algoritam od objektne strukture



// Command design pattern
// kreira objekte koji mogu da enkapsuliraju akcije ili parametre, kako bi oni mogli biti kasnije pozvani ili pozvani nekom drugom komponentom
// Nekad u aplikaciji treba da razdvojimo izvrsenje komande od njenog invokatora, obicno je ovo situacija kada treba da obavimo nekoliko akcija, ali izbor akcije se desava tokom runtime-a

protocol Command {
    func execute()
}

struct RockerSwitchLightOnCommand: Command {
    func execute() {
        print("Rocker Switch:  Turning Light On")
    }
}
struct RockerSwitchLightOffCommand: Command {
    func execute() {
        print("Rocker Switch:  Turning Light Off")
    }
}
struct PullSwitchLightOnCommand: Command {
    func execute() {
        print("Pull Switch:  Turning Light On")
    }
}
struct PullSwitchLightOffCommand: Command {
    func execute() {
        print("Pull Switch:  Turning Light Off")
    }
}

class Light {
    var lightOnCommand: Command
    var lightOffCommand: Command
    
    init(lightOnCommand: Command, lightOffCommand: Command) {
        self.lightOnCommand = lightOnCommand
        self.lightOffCommand = lightOffCommand
    }
    
    func turnOnLight() {
        self.lightOnCommand.execute()
    }
    
    func turnOffLight() {
        self.lightOffCommand.execute()
    }
}


var on = PullSwitchLightOnCommand()
var off = PullSwitchLightOffCommand()
var light = Light(lightOnCommand: on, lightOffCommand: off)

light.turnOnLight()
light.turnOffLight()

light.lightOnCommand = RockerSwitchLightOnCommand() //ovde smo promenili ponasanje u toku runtime-a
light.turnOnLight() // koje se implemetira ovde tek



// Strategy pattern
// Ovaj patern je slican Command patternu s tim sto se odnosi na odabir algoritma tokom runtime-a i funkcionalsnost ce biti ista, samo drugacije odigrana.
// Nekad je potrebno promeniti bekend algoritam, i to kad imamo nekoliko rzlicitih algoritama koji se mogu koristiti za obavljanje istog zadatka.

protocol CompressionStrategy {
    func compressFiles(filePaths: [String])
}

struct ZipCompressionStrategy: CompressionStrategy {
    func compressFiles(filePaths: [String]) {
        print("Using Zip Compression")
    }
}

struct RarCompressionStrategy: CompressionStrategy {
    func compressFiles(filePaths: [String]) {
        print("Using RAR Compression")
    }
}

class CompressContent {
    var strategy: CompressionStrategy
    
    init(strategy: CompressionStrategy) {
        self.strategy = strategy
    }
    
    func compressFiles(filePaths: [String]) {
        self.strategy.compressFiles(filePaths: filePaths)
    }
}

var filePaths = ["file1.txt", "file2.txt"]
var zip = ZipCompressionStrategy()
var rar = RarCompressionStrategy()

var compress = CompressContent(strategy: zip)
compress.compressFiles(filePaths: filePaths)

compress.strategy = rar
compress.compressFiles(filePaths: filePaths)



// Observer pattern
// The NotificaitionCenter class provides us with a mechanism to register for, post, and receive notifications. All Cocoa- and Cocoa Touch-based applications have a default notification center when they are running.

let NCNAME = "Notification Name"

class PostType {
    let nc = NotificationCenter.default
    
    func post() {
        nc.post(name: Notification.Name(rawValue: NCNAME), object: nil)
    }
}

class ObserverType {
    let nc = NotificationCenter.default
    
    init() {
        nc.addObserver(self, selector:
            #selector(receiveNotification(notification:)), name:
            Notification.Name(rawValue: NCNAME), object: nil)
    }
    
    @objc func receiveNotification(notification: Notification) {
        print("Notification  Received")
    }
}

var postType = PostType()
var observerType = ObserverType()
postType.post()

protocol ZombieObserverProtocol {
    func turnLeft()
    func turnRight()
    func seesUs()
}

class MyObserver: ZombieObserverProtocol {
    func turnLeft() {
        print("Zombie turned left, we move right")
    }
    func turnRight() {
        print("Zombie turned right, we move left")
    }
    func seesUs() {
        print("Zombie sees us, RUN!!!!")
    }
}


struct Zombie {
    var observer: ZombieObserverProtocol
    
    func turnZombieLeft() {
        //Code to turn left
        //Notify observer
        observer.turnLeft()
    }
    func turnZombieRight() {
        //Code to turn right
        //Notify observer
        observer.turnRight()
    }
    func spotHuman() {
        //Code to lock onto a human
        //Notify observer
        observer.seesUs()
    }
}


var observer = MyObserver()
var zombie = Zombie(observer: observer)

zombie.turnZombieLeft()
zombie.spotHuman()


protocol PropertyObserverProtocol {
    func propertyChanged(propertyName: String, newValue: Any)
}

class MyObserverType: PropertyObserverProtocol {
    func propertyChanged(propertyName: String, newValue: Any) {
        print("----changed----")
        print("Property Name: \(propertyName)")
        print("New Value:  \(newValue)")
    }
}

struct PropertyObserver {
    var observer: PropertyObserverProtocol
    var property1: String {
        didSet{
            observer.propertyChanged(propertyName: "property1",
                                     newValue: property1)
        }
        willSet(newValue) {
            print("Property Changing")
        }
    }
}

var myObserver = MyObserverType()
var p = PropertyObserver(observer: myObserver, property1: "Initial String")
p.property1 = "My String" 

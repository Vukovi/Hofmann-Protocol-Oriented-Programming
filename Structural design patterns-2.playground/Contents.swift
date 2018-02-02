import UIKit

// STRUCTURAL PATTERNS
// Structural patterni pomazu da se razliciti tipovi iskombinuju da bi formirali veliku strukturu
// Postoji sedam poznatih paterna
//  1) Adapter pattern - omogucava rad nekompatibilnih interfejsa
//  2) Bridge pattern - razdvaja apstraktne elemente od implementacije tako da oni mogu da variarju po tipu
//  3) Composite pattern - omogucava da tretiramo grupu objekata kao jedan objekat
//  4) Decorator pattern - omogucava da pregazimo ili dodamo ponasanje postojecoj metodi objekta
//  5) Facade pattern - omogucava koriscenje pojednostavljenog interfejsa umesto komplikovanog i velikog koda
//  6) Flyweight pattern - omogucava smanjenje resursa potrebnih za kreiranje i koriscenje velikog broja slicnih objekata
//  6) Proxy pattern - on je tip koji se ponasa kao interfejs za drugu klasu ili klase



// Bridge pattern
// Moze se smatrati kao dvosljona apstrakcija. Koristi se kad se ukaze potreba za prosirivanjem koda novim funkcionalnostima i svojstvima, to bi znacilo da bez ovog paterna mora das se refaktorise kod i to je u OOP poznato kao exploding class hierarchy.
// Ovim paternom se uzimaju delovi koji su medjusobno vezani i razdvajaju se funkcionalnosti koji su karakteristicne za svaki taj deo pojedninacno od onih funkcionalnosti koje su zajednicke.
// Primer su dve funkcionalnosti od kojih prva cuva i priprema poruke za slanje, a druga salje te poruke specificnim kanalom kao sto je email ili SMS

protocol MessageProtocol {
    var messageString: String {get set}
    init(messageString: String)
    func prepareMessage()
}

protocol SenderProtocol {
    func sendMessage(message: MessageProtocol)
}

class PlainTextMessage: MessageProtocol {
    var messageString: String
    required init(messageString: String) {
        self.messageString = messageString
    }
    func prepareMessage() {
        //  Nothing to do
    }
}

class DESEncryptedMessage: MessageProtocol {
    var messageString: String
    required init(messageString: String) {
        self.messageString = messageString
    }
    func prepareMessage() {
        // Ovde metoda za razliku od gornje klase, kao ubacuje logiku za ekripciju, to je simulirano ovim "DES: "
        self.messageString = "DES: " + self.messageString
    }
}

class EmailSender: SenderProtocol {
    func sendMessage(message: MessageProtocol) {
        print("Sending through E-Mail:")
        print(" \(message.messageString)")
    }
}

class SMSSender: SenderProtocol {
    func sendMessage(message: MessageProtocol) {
        print("Sending through SMS:")
        print(" \(message.messageString)")
    }
}


var myMessage = PlainTextMessage(messageString: "Plain Text Message")
myMessage.prepareMessage()
var sender = SMSSender()
sender.sendMessage(message: myMessage)

//Sada sledi komolikacija za bridge patern, koja glasi ovako:
//Stigao nam je dodatni zahtev kojim se trazi verifikovanje poruke pre slanja da bi bili sigurni da su ispunjeni uslovi kanala za slanje

protocol NEWSenderProtocol {
    var message: MessageProtocol? {get set}
    func sendMessage()
    func verifyMessage() // stari SenderProtocol je prosiren za ovu metodu
}

class NEWEmailSender: NEWSenderProtocol { //staru klasu EmailSender bi morali da prosirimo za verifyMessage() metodu i property message
    var message: MessageProtocol?
    func sendMessage() {
        print("Sending through E-Mail:")
        print(" \(message!.messageString)")
    }
    func verifyMessage() {
        print("Verifying E-Mail message")
    }
}

class NEWSMSSender: NEWSenderProtocol { //staru klasu SMSSender bi morali da prosirimo za verifyMessage() metodu i property message
    var message: MessageProtocol?
    func sendMessage() {
        print("Sending through SMS:")
        print(" \(message!.messageString)")
    }
    func verifyMessage() {
        print("Verifying SMS message")
    }
}

var myNEWMessage = PlainTextMessage(messageString: "Plain Text Message")
myNEWMessage.prepareMessage()
var newSender = NEWSMSSender()
newSender.message = myNEWMessage
newSender.verifyMessage()
newSender.sendMessage()

//ovako je lako prosiriti funkcionalnost jer ima malo koda u kom treba izvrsiti refaktorisanje, a sa bridge paternom logiku treba postaviti tako da enkapsulira logiku na jednom mestu, tako da sva prosirenja i zahteve na jednom mestu menjamo
// Primenjen Bridge Pattern
struct MessageingBridge {
    static func sendMessage(message: MessageProtocol, sender: NEWSenderProtocol) {
        var sender = sender
        message.prepareMessage()
        sender.message = message
        sender.verifyMessage()
        sender.sendMessage()
    }
}


// Facade Pattern
// Facade pattern obezbedjuje pojednostavljeni interfejs mnogo vecem i kompleksnijem kodu.
// Ovo nam omogucuje da napravimo nase biblioteke jednostavnijim kao i koriscenje vise APIja u jedan jednostavniji.
// Napravicemo tri APIja HotelBooking, FlightBooking i RentalCarBooks

struct Hotel {
    //Information about hotel room
}

struct Flight {
    //Information about flights
}

struct RentalCar {
    //Information about rental cars
}

struct HotelBooking {
    
    static func getHotelNameForDates(to: NSDate, from: NSDate) -> [Hotel]? {
            let hotels = [Hotel]()
            //logic to get hotels
            return hotels
    }
    
    static func bookHotel(hotel: Hotel) {
        // logic to reserve hotel room
    }
}

struct FlightBooking {
    static func getFlightNameForDates(to: NSDate, from: NSDate) -> [Flight]? {
            let flights = [Flight]()
            //logic to get flights
            return flights
    }
    
    static func bookFlight(flight: Flight) {
        // logic to reserve flight
    }
}

struct RentalCarBooking {
    static func getRentalCarNameForDates(to: NSDate, from: NSDate)
        -> [RentalCar]? {
            let cars = [RentalCar]()
            //logic to get flights
            return cars
    }

    static func bookRentalCar(rentalCar: RentalCar) {
        // logic to reserve rental car
    }
}

// Ova tri APIja je lako lako individualno pozvati u aplikaciji, ali oni ce se naravno zbog zahteva menjati u toku vremena.
// Tako da je bolje da azuriramo FACADE TYPE nego ceo kod, i zato sada implementiramo Facade Pattern

class TravelFacade {
    
    var hotels: [Hotel]?
    var flights: [Flight]?
    var cars: [RentalCar]?
    
    init(to: NSDate, from: NSDate) {
        hotels = HotelBooking.getHotelNameForDates(to: to, from: from)
        flights = FlightBooking.getFlightNameForDates(to: to, from:
            from)
        cars = RentalCarBooking.getRentalCarNameForDates(to: to, from:
            from)
    }
    
    func bookTrip(hotel: Hotel, flight: Flight, rentalCar:
        RentalCar) {
        HotelBooking.bookHotel(hotel: hotel)
        FlightBooking.bookFlight(flight: flight)
        RentalCarBooking.bookRentalCar(rentalCar: rentalCar)
    }
}


// Proxy design pattern
// U proxy paternu, jedan tip podatka je intrfejs za neki tip APIja, i ova wrapper klasa koja je u stvari proxy, moze da dodaje funkcionalnosti objektu, ucini ga dostupnim preko interneta ili ograncic pristup njemu.
// Obicno se ovim paternom resavaju dva problema:
// Prvo je potreba da se napravi apstraktni lejer izmedju APIja i koda. Ovo omogucava promene u APIju bez potrebe da se refaktorise velika kolicina koda.
// Drugo je potreba da se naprave izmene na APIju ali ne postoji kod kojim se to radi, ili je u pitanju neki dependency.

protocol FloorPlanProtocol {
    var bedRooms: Int {get set}
    var utilityRooms: Int {get set}
    var bathRooms: Int {get set}
    var kitchen: Int {get set}
    var livingRooms: Int {get set}
}

struct FloorPlan: FloorPlanProtocol {
    var bedRooms = 0
    var utilityRooms = 0
    var bathRooms = 0
    var kitchen = 0
    var livingRooms = 0
}


class House {
    internal var stories = [FloorPlanProtocol]()
    
    func addStory(floorPlan: FloorPlanProtocol) {
        stories.append(floorPlan)
    }
}


class HouseProxy {
    var house = House()
    func addStory(floorPlan: FloorPlanProtocol) -> Bool {
        if house.stories.count < 3 {
            house.addStory(floorPlan: floorPlan)
            return true
        }
        else {
            return false
        }
    }
}

var ourHouse = HouseProxy()

var basement = FloorPlan(bedRooms: 0, utilityRooms: 1, bathRooms:    1, kitchen: 0, livingRooms: 1)
var firstStory = FloorPlan(bedRooms: 1, utilityRooms: 0,    bathRooms: 2, kitchen: 1, livingRooms: 1)
var secondStory = FloorPlan(bedRooms: 2, utilityRooms: 0,    bathRooms: 1, kitchen: 0, livingRooms: 1)
var additionalStory = FloorPlan(bedRooms: 1, utilityRooms: 0,    bathRooms: 1, kitchen: 1, livingRooms: 1)

print(ourHouse.addStory(floorPlan: basement))
print(ourHouse.addStory(floorPlan: firstStory))
print(ourHouse.addStory(floorPlan: secondStory))
print(ourHouse.addStory(floorPlan: additionalStory))

// Ovaj patern je koristan kada hocemo da dodamo neke funkcionalnosti ili da proverimo error prema odredjenom tipu, ali necemo da menjamo postojeci tip


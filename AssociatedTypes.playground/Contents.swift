//: Playground - noun: a place where people can play

import Foundation

// Associated Type - Generic Protocol

protocol Queue {
    associatedtype QueueType
    mutating func addItem(item: QueueType)
    mutating func getItem() -> QueueType?
    func count() -> Int
}

struct IntQueue: Queue {
    var items = [Int]()
    mutating func addItem(item: Int) {
        items.append(item)
    }
    mutating func getItem() -> Int? {
        if items.count > 0 {
            return items.remove(at: 0)
        }
        else {
            return nil
        }
    }
    func count() -> Int {
        return items.count
    }
}


// Protocol Basic

protocol FullName {
    var firstName: String {get set}
    var lastName: String {get set}
    func getFullName() -> String
}

// nasledjivanje protokola
protocol Person: FullName {
    var age: Int {get set}
}

// implementacija protokola:
// mora se implementirati sve sto nosi pozvani protokol i sve sto nosi nadprotokol pozvanog protokola
struct Student: Person {
    var firstName = ""
    var lastName = ""
    var age = 0
    
    func getFullName() -> String {
        return "(firstName) (lastName)"
    }
}

// @objc protokol
// dozovljava da se primeni optional na property-ju ili metodi
// to znaci da se te opcione metode i property-ji  ne moraju implementirati
// ovi protokoli se ne mogu extendovati na swiftov nacin, jer su to sad protokoli obj-c a ne swifta
@objc protocol Phone {
    var phoneNumber: String {get set}
    @objc optional var emailAddress: String {get set}
    func dialNumber()
    @objc optional func getEmail()
}


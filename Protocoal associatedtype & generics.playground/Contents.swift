import UIKit

class LinkedListReferenceType {
    var value: String
    var next: LinkedListReferenceType?
    
    init(value: String) {
        self.value = value
    }
}

protocol PersonProtocol {
    var firstName: String {get set}
    var lastName: String {get set}
    var birthDate: Date {get set}
    var profession: String {get}
    
    init (firstName: String, lastName: String, birthDate: Date)
}

func updatePerson(person: PersonProtocol) -> PersonProtocol {
    var newPerson: PersonProtocol
    newPerson = person
    return newPerson
}

var personArray = [PersonProtocol]()
var personDict = [String: PersonProtocol]()


let formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd HH:mm"
let someDateTime = formatter.date(from: "2016/10/08 22:31")

protocol QueueProtocol {
    associatedtype QueueType
    mutating func addItem(item: QueueType)
    mutating func getItem() -> QueueType?
    func count() -> Int
}

struct IntQueue: QueueProtocol {
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


class GenericQueue<T>: QueueProtocol {
    var items = [T]()
    
    func addItem(item: T) {
        items.append(item)
    }
    
    func getItem() -> T? {
        if items.count > 0 {
            return items.remove(at: 0)
        } else {
            return nil
        }
    }
    
    func count() -> Int {
        return items.count
    }
}

var intQ2 = GenericQueue<Int>()
intQ2.addItem(item: 2)
intQ2.addItem(item: 4)
print(intQ2.getItem()!)
intQ2.addItem(item: 6)





import UIKit

// Optionals are another example of where generics are used in the Swift language.

enum Optional<T> {
    case None
    case Some(T)
}

//primer ponavljanja funkcije koja je mogla da se odradi upotrebom generic-a

func swapInts (a: inout Int,b: inout Int) {
    let tmp = a
    a = b
    b = tmp
}

func swapDoubles(a: inout Double,b: inout Double) {
    let tmp = a
    a = b
    b = tmp
}

func swapStrings(a: inout String, b: inout String) {
    let tmp = a
    a = b
    b = tmp
}

// a sa generics-om:

func swapGenerics<T>(a: inout T, b: inout T) {
    let tmp = a
    a = b
    b = tmp
}

// nije neophodno da generik bude napisan velikim slovom, moze i rec malim slovima
func swapGeneric<xyz>(a: inout xyz, b: inout xyz) {
    //Statements
}
//upotreba sa Int
var a = 5
var b = 10
swapGeneric(a: &a, b: &b)
print("a:  \(a) b:  \(b)")

//upotreba sa String
var c = "My String 1"
var d = "My String 2"
swapGeneric(a: &c, b: &d)
print("c:  \(c) d:  \(d)")

//kombinacija tipova nija moguca
var e = 5
var f = "My String 1"
// swapGeneric(a: &e, b: &f) /// Cannot convert value of type 'String' to expected argument type 'Int'

//kombinacija tipova je na ovaj nacin moguca
func testGeneric<T,E>(a:T, b:E) {
    print("\(a) \(b)")
}

//*********  Generic Constraints *********//

//ovo ne moze da se uradi jer dize gresku zbog toga sto Swift ne zna koji tip podataka ce biti koriscen

//func genericEqual<T>(a: T, b: T) -> Bool{
//    return a == b
//}

//ali zato primenom protokola Comparable moze
func testGenericComparable<T: Comparable>(a: T, b: T) -> Bool{
    return a >= b
}

class MyClass { }
protocol MyProtocol { }
func testFunction<T: MyClass, E: MyProtocol>(a: T, b: E) { }



//*********  Generic Type *********//

//A generic type is a class, structure, or enumeration that can work with any type, just like Swift arrays and optionals can work with any type

class List<T> { }

//To create an instance of this type, we would need to define the type of items that our list will hold.

var stringList = List<String>()
var intList = List<Int>()
var customList = List<MyProtocol>()

class List2<T> {
    var items = [T]()
    
    func add(item: T) {
        items.append(item)
    }
    
    func getItemAtIndex(index: Int) -> T? {
        if items.count > index {
            return items[index]
        } else {
            return nil
        }
    }
}

var list = List2<String>()
list.add(item: "Hello")
list.add(item: "World")
print(list.getItemAtIndex(index: 1)!)

// When we declare generic types in a protocol, they are known as associated types


//*********  Generic Type *********//

//An associated type declares a placeholder name that can be used instead of a type within a protocol. The actual type to be used is not specified until the protocol is adopted.

protocol MyProtocol2 {
    associatedtype E //ovo je generik u protokolu
    
    var items: [E] {get set}
    mutating func add(item: E)
}

struct MyIntType: MyProtocol {
    var items: [Int] = []
    mutating func add(item: Int) {
        items.append(item)
    }
}

struct MyGenericType<T>: MyProtocol {
    var items: [T] = []
    mutating func add(item: T) {
        items.append(item)
    }
}


//*********  Generics in a protocol-oriented design **********//
protocol Listing {
    associatedtype T
    mutating func add(item: T)
    func length() -> Int
    func get(index: Int) -> T?
}

//implementacija
// This is the proxy design pattern where we use one type to hide the implementation details of another type to control access to it.

struct ArrayList<T>: Listing {
    private var items: [T] = []
    
    mutating func add(item: T) {
        items.append(item)
    }
    func length() -> Int {
        return items.count
    }
    func get(index: Int) -> T? {
        return items[index]
    }
}

var arrayList = ArrayList<Int>()
arrayList.add(item: 1)
arrayList.add(item: 2)
arrayList.add(item: 3)
print("arrayList length: \(arrayList.length())")
print(arrayList.get(index: 1)!)

//   There are two advantages to using a design such as this. The first is that we are hiding the implementation details of our backend storage. This allows us to change the storage type from an array to any other storage mechanism we may need in the future because we are using the interface provided by the List protocol to access the backend storage mechanism.The second advantage we have with this design is we can access the instance of any type that conforms to the List protocol using the same interface.

class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T>: Listing {
    
    var head: LinkedListNode<T>?
    var tail: LinkedListNode<T>?
    
    func add(item: T) {
        let newItem = LinkedListNode(value: item)
        if let lastNode = tail {
            lastNode.next = newItem
            tail = newItem
        } else {
            head = newItem
            tail = newItem
        }
    }
    
    func length() -> Int {
        if var node = head {
            var count = 1
            while case let next? = node.next {
                node = next
                count += 1
            }
            return count
        } else {
            return 0
        }
    }
    
    func get(index: Int) -> T? {
        guard index >= 0 else {
            return nil
        }
        guard head != nil else {
            return nil
        }
        var node = head
        var i = index
        while (i > 0) {
            i -= 1
            if let newNode = node?.next {
                node = newNode
            } else {
                return nil
            }
        }
        return node?.value
    }
}



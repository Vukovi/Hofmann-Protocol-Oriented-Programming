import UIKit

//struct CountdownIterator: IteratorProtocol { //primena Sequence protokola koji zbog & simulira FOR petlju
//    let myValueType: MyValueType
//    var times = 0
//    
//    init(_ myValueType: MyValueType) {
//        self.myValueType = myValueType
//    }
//    
//    mutating func next() -> Int? {
//        let nextNumber = myValueType.grade - times
//        guard nextNumber > 0
//            else { return nil }
//        
//        times += 1
//        return nextNumber
//    }
//}


struct MyValueType: Sequence { //ovaj protokol mi treba zbog koriscenja & u 130. redu u metodi getNewGradeForAssignment(assignment: &newMathAssignment), koji zbog & simulira FOR petlju
    var name: String
    var assignment: String
    var grade: Int //zbog Sequence protokola obavezno jedan Int
    
//    func makeIterator() -> CountdownIterator {
//        return CountdownIterator(self)
//    }
    
//    typealias Iterator = AnyIterator<(element: MyValueType, count: Int)>
    typealias Iterator = AnyIterator<(MyValueType)>
    
    func makeIterator() -> Iterator {
        // 2
        let iterator = self.makeIterator()
        
        // 3
        return AnyIterator {
            return iterator.next()
        }
    }
}

class MyReferenceType {
    var name: String
    var assignment: String
    var grade: Int
    
    init(name: String, assignment: String, grade: Int) {
        self.name = name
        self.assignment = assignment
        self.grade = grade
    }
}

var ref = MyReferenceType(name: "John", assignment: "Math Test1", grade: 90)
var val = MyValueType(name: "Jon", assignment: "Math Test1", grade: 90)


func extraCreditReferenceType(ref: MyReferenceType, extraCredit: Int) {
    ref.grade += extraCredit
}

func extraCreditValueType(val: MyValueType, extraCredit: Int) {
    var val = val
    val.grade += extraCredit
}

// In this code, we created an instance of the MyReferenceType type with a grade of 90. We then used the extraCreditReferenceType() function to add five extra points to the grade.
extraCreditReferenceType(ref: ref, extraCredit:5)
print("Reference: \(ref.name) - \(ref.grade)") // Reference: Jon - 95


//In this code, we created an instance of the MyValueType type with a grade of 90. We then used the extraCreditValueType() function to add five extra points to the grade.
extraCreditValueType(val: val, extraCredit:5)
print("Value: \(val.name) - \(val.grade)") //  Value: Jon - 90
//As we can see, the five extra credit points are missing from our grade in this example. The reason for this is when we pass an instance of a value type to a function, we are actually passing a copy of the original instance.



//Using a value type protects us from making accidental changes to our instances because the instances are scoped to the function or type in which they are created. Value types also protect us from having multiple references to the same instance.

func getGradeForAssignment(assignment: MyReferenceType) {
    // Code to get grade from DB
    // Random code here to illustrate issue
    let num = Int(arc4random_uniform(20) + 80)
    assignment.grade = num
    print("Grade for (assignment.name) is (num)")
}




var mathGrades = [MyReferenceType]()
var students = ["Jon", "Kim", "Kailey", "Kara"]
var mathAssignment = MyReferenceType(name: "", assignment:
    "Math Assignment", grade: 0)

for student in students {
    mathAssignment.name = student
    getGradeForAssignment(assignment: mathAssignment)
    mathGrades.append(mathAssignment)
}
/*
Grade for Jon is 90
Grade for Kim is 84
Grade for Kailey is 99
Grade for Kara is 89
*/

//This appears to look exactly like what we want. However, there is a huge bug in this code. Let's loop through our mathGrades array to see what grades we have in the array itself

for assignment in mathGrades {
    print("(assignment.name): grade (assignment.grade)")
}
/*
 Kara: grade 89
 Kara: grade 89
 Kara: grade 89
 Kara: grade 89
 */

//That is not what we wanted. The reason we see these results is because we created one instance of the MyReferenceType type and then we kept updating that single instance. This means that we kept overwriting the previous name and grade.

//“Apple has provided a way for us to have this behavior with value types “using the inout parameters. An inout parameter allows us to change the value of a value type parameter and to have that change persist after the function call has ended.


func getNewGradeForAssignment(assignment: inout MyValueType) {
    // Code to get grade from DB
    // Random code here to illustrate issue
    let num = Int(arc4random_uniform(20) + 80)
    assignment.grade = num
    print("Grade for \(assignment.name) is \(num)")
}

var newMathGrades = [MyValueType]()
var newStudents = ["Jon", "Kim", "Kailey", "Kara"]
var newMathAssignment = MyValueType(name: "", assignment: "Math Assignment", grade: 0)

for student in newStudents {
    mathAssignment.name = student
    getNewGradeForAssignment(assignment: &newMathAssignment)
    mathGrades.append(mathAssignment)
}

for assignment in newMathGrades {
    print("\(assignment.name): grade \(assignment.grade)")
}
/*
 Grade for Jon is 97
 Grade for Kim is 83
 Grade for Kailey is 87
 Grade for Kara is 85
 Jon: grade 97
 Kim: grade 83
 Kailey: grade 87
 Kara: grade 85
 */

/*
let minionJSON = JSONValue(data)
var minions + [Minion]()
for minionDictionary in minionJSON {   -------> DOES NOT CONFORM TO PROTOCOL SEQUENCE
    minions += Minion(minionDetails: minionDictionary)
}
RESENJE
if let minionArray = minionJSON.array {
    for minionDictionary in minionArray {
        minions += Minion(minionDetails: minionDictionary)
    }
}
*/
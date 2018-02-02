import UIKit

//In Swift, a tuple is a finite, ordered, comma-separated list of elements.
//Tuple is a value type. Tuples are also compound types.

//unnamed tuple
let mathGrade1 = ("Jon", 100)
let (name, score) = mathGrade1
print("\(name) : \(score)")


//named tuple
let mathGrade2 = (name: "Jon", grade: 100)
print("\(mathGrade2.name) : \(mathGrade2.grade)")


//tuples as a return type for a function to return multiple values
func calculateTip(billAmount: Double,tipPercent: Double) ->
    (tipAmount: Double, totalAmount: Double) {
        
        let tip = billAmount * (tipPercent/100)
        let total = billAmount + tip
        return (tipAmount: tip, totalAmount: total)
}

var tip = calculateTip(billAmount:31.98, tipPercent: 20)
print("\(tip.tipAmount) - \(tip.totalAmount)")


typealias myTuple = (tipAmount: Double, totalAmount: Double)

func calculateAnotherTip(billAmount: Double,tipPercent: Double) -> myTuple {

    let tip = billAmount * (tipPercent/100)
    let total = billAmount + tip
    return (tipAmount: tip, totalAmount: total)
    
}
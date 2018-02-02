import UIKit

enum TerrainType {
    case Land
    case Sea
    case Air
}

class Vehicle {
    
    fileprivate var vehicleTypes = [TerrainType]()
    fileprivate var vehicleAttackTypes = [TerrainType]()
    fileprivate var vehicleMovementTypes = [TerrainType]()
    
    fileprivate var landAttackRange = -1
    fileprivate var seaAttackRange = -1
    fileprivate var airAttackRange = -1
    
    fileprivate var hitPoints = 0
    
    //Since the properties are marked as fileprivate, we will need to create some getter methods that will retrieve the values of the properties. We will also create methods to see what types of terrain the vehicle can attack from and move to
    
    func isVehicleType(type: TerrainType) -> Bool {
        return vehicleTypes.contains(type)
    }
    
    func canVehicleAttack(type: TerrainType) -> Bool {
        return vehicleAttackTypes.contains(type)
    }
    
    func canVehicleMove(type: TerrainType) -> Bool {
        return vehicleMovementTypes.contains(type)
    }
    
    func doLandAttack() {}
    func doLandMovement() {}
    
    func doSeaAttack() {}
    func doSeaMovement() {}
    
    func doAirAttack() {}
    func doAirMovement() {}
    
    func takeHit(amount: Int) {
        hitPoints -= amount
    }
    func hitPointsRemaining() -> Int {
        return hitPoints
    }
    func isAlive() -> Bool {
        return hitPoints > 0 ? true : false
    }
}


class Tank: Vehicle {
    
    override init() {
        super.init()
        vehicleTypes = [.Land]
        vehicleAttackTypes = [.Land]
        vehicleMovementTypes = [.Land]
        
        landAttackRange = 5
        
        hitPoints = 68
    }
    
    override func doLandAttack() {
        print("Tank Attack")
    }
    
    override func doLandMovement() {
        print("Tank Move")
    }
}

class Amphibious: Vehicle {
    
    override init() {
        super.init()
        vehicleTypes = [.Land, .Sea]
        vehicleAttackTypes = [.Land, .Sea]
        vehicleMovementTypes = [.Land, .Sea]
        
        landAttackRange = 1
        seaAttackRange = 1
        
        hitPoints = 25
    }
    
    override func doLandAttack() {
        print("Amphibious Land Attack")
    }
    
    override func doLandMovement() {
        print("Amphibious Land Move")
    }
    
    override func doSeaAttack() {
        print("Amphibious Sea Attack")
    }
    
    override func doSeaMovement() {
        print("Amphibious Sea Move")
    }
}

class Transformer: Vehicle {
    
    override init() {
        super.init()
        vehicleTypes = [.Land, .Sea, .Air]
        vehicleAttackTypes = [.Land, .Sea, .Air]
        vehicleMovementTypes = [.Land, .Sea, .Air]
        
        landAttackRange = 7
        seaAttackRange = 10
        airAttackRange = 12
        
        hitPoints = 75
    }
    
    override func doLandAttack() {
        print("Transformer Land Attack")
    }
    override func doLandMovement() {
        print("Transformer Land Move")
    }
    override func doSeaAttack() {
        print("Transformer Sea Attack")
    }
    override func doSeaMovement() {
        print("Transformer Sea Move")
    }
    override func doAirAttack() {
        print("Transformer Air Attack")
    }
    override func doAirMovement() {
        print("Transformer Air Move")
    }
}

var vehicles = [Vehicle]()

var vh1 = Amphibious()
var vh2 = Amphibious()
var vh3 = Tank()
var vh4 = Transformer()

vehicles.append(vh1)
vehicles.append(vh2)
vehicles.append(vh3)
vehicles.append(vh4)

for (index, vehicle) in vehicles.enumerated() {
    if vehicle.isVehicleType(type: .Air) {
        print("Vehicle at \(index) is Air")
        if vehicle.canVehicleAttack(type: .Air) {
            print("---Can do Air attack")
        }
        if vehicle.canVehicleMove(type: .Air) {
            print("---Can do Air movement")
        }
    }
    if vehicle.isVehicleType(type: .Land){
        print("Vehicle at \(index) is Land")
        if vehicle.canVehicleAttack(type: .Land) {
            print("---Can do Land attack")
        }
        if vehicle.canVehicleMove(type: .Land) {
            print("---Can do Land movement")
        }
    }
    if vehicle.isVehicleType(type: .Sea) {
        print("Vehicle at \(index) is Sea")
        if vehicle.canVehicleAttack(type: .Sea) {
            print("---Can do Sea attack")
        }
        if vehicle.canVehicleMove(type: .Sea) {
            print("---Can do Sea movement")
        }
    }
}

// In new design, we use three techniques that make protocol-oriented programming significantly different from object-oriented programming. These techniques are protocol inheritance, protocol composition, and protocol extensions.

protocol VehicleProtocol {
    var hitPoints: Int {get set}
}

extension VehicleProtocol {
    mutating func takeHit(amount: Int) {
        hitPoints -= amount
    }
    func hitPointsRemaining() -> Int {
        return hitPoints
    }
    func isAlive() -> Bool {
        return hitPoints > 0 ? true : false
    }
}
//These three new protocols inherit the requirements from the Vehicle protocol, which also means they inherit the functionality from the Vehicle protocol extension. Another thing to note about these protocols is that they only contain the requirements needed for their particular type of vehicle.

protocol LandVehicleProtocol: VehicleProtocol {
    var landAttack: Bool {get}
    var landMovement: Bool {get}
    var landAttackRange: Int {get}
    
    func doLandAttack()
    func doLandMovement()
}

protocol SeaVehicleProtocol: VehicleProtocol {
    var seaAttack: Bool {get}
    var seaMovement: Bool {get}
    var seaAttackRange: Int {get}
    
    func doSeaAttack()
    func doSeaMovement()
}

protocol AirVehicleProtocol: VehicleProtocol {
    var airAttack: Bool {get}
    var airMovement: Bool {get}
    var airAttackRange: Int {get}
    
    func doAirAttack()
    func doAirMovement()
}

//now we create types that conform to these protocols
//we are able to use the default initializer that the structure provides, and we define the properties as constants; therefore, they can't be changed once they are set. 
//In the Tank type from our object-oriented design, we had to override the initializer and then set the properties within the initializer. The properties in the object-oriented design were also variables, which may be changed once they are set

struct NewTank: LandVehicleProtocol {
    var hitPoints = 68
    let landAttackRange = 5
    let landAttack = true
    let landMovement = true
    func doLandAttack() { print("Tank Attack") }
    func doLandMovement() { print("Tank Move") }
}

struct NewAmphibious: LandVehicleProtocol, SeaVehicleProtocol {
    var hitPoints = 25
    let landAttackRange = 1
    let seaAttackRange = 1
    let landAttack = true
    let landMovement = true
    let seaAttack = true
    let seaMovement = true
    
    func doLandAttack() { print("Amphibious Land Attack") }
    func doLandMovement() { print("Amphibious Land Move") }
    func doSeaAttack() { print("Amphibious Sea Attack") }
    func doSeaMovement() { print("Amphibious Sea Move") }
}

struct NewTransformer: LandVehicleProtocol, SeaVehicleProtocol, AirVehicleProtocol {
    
    var airAttackRange = 12
    var seaAttackRange = 10
    var hitPoints = 75
    let landAttackRange = 7
    let landAttack = true
    let landMovement = true
    let seaAttack = true
    let seaMovement = true
    let airAttack = true
    let airMovement = true
    
    func doLandAttack() { print("Transformer Land Attack") }
    func doLandMovement() { print("Transformer Land Move") }
    func doSeaAttack() { print("Transformer Sea Attack") }
    func doSeaMovement() { print("Transformer Sea Move") }
    func doAirAttack() { print("Transformer Sea Attack") }
    func doAirMovement() { print("Transformer Sea Move") }
}

var vehiclesNew = [VehicleProtocol]()

var vh5 = NewAmphibious()
var vh6 = NewAmphibious()
var vh7 = NewTank()
var vh8 = NewTransformer()

vehiclesNew.append(vh5)
vehiclesNew.append(vh6)
vehiclesNew.append(vh7)
vehiclesNew.append(vh8)

//We use an as? type-casting pattern to see if the instances conform to the various protocols (AirVehicle, LandVehicle, and SeaVehicle protocols)
for (index, vehicle) in vehiclesNew.enumerated() {
    if let Vehicle = vehicle as? AirVehicleProtocol {
        print("Vehicle at \(index) is Air")
    }
    if let Vehicle = vehicle as? LandVehicleProtocol {
        print("Vehicle at \(index) is Land")
    }
    if let Vehicle = vehicle as? SeaVehicleProtocol {
        print("Vehicle at \(index) is Sea")
    }
}

//We want to get one type of vehicle rather than all vehicles
for (index, vehicle) in vehiclesNew.enumerated() where vehicle is LandVehicleProtocol {
    var vh = vehicle as! LandVehicleProtocol
    
    if vh.landAttack {
        print("---Can do Land attack")
    }
    
    if vh.landMovement {
        print("---Can do Land movement")
    }
}







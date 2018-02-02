import UIKit

// U aplikacajama je neophodno razdvojiti cuvanje neophodnih podataka od biznis logike, i zbog toga se koriste
// data access layer-i
// Kada imamo dobar access layer imamo bolje i lakse odrzavanje koda kako se zahtevi u buducnosti budu menjali.
// Npr. da smo resili da nase podatke cuvamo u XML formatiranom fajlu, a zatim ovom fajlu po potrebama pristupamo iz raznih delova aplikacije.
// Ako se u buducnosti odlucimo da umesto cuvanja podataka u XML fajlu, podatke cuvamo u bazi, morali bi da
// refaktorisemo veliku kolicinu koda. Ali ako smo razdvojili biznis logiku od pristupa podacima, onda nam je
// refaktorisanje svedeno samo na layer data access-a


// Zahtevi
// Svi pristupi backend data storage-u treba da se odigra pomocu data helper tipova, a ovi tipovi ce rukovoditi Create, Read, Update i Delete funkcionalnostima backend storage-a
// Kod koji je van okvira ovog data access layer-a ne treba da bude svestan kako se podaci obradjuju i cuvaju.
// Za nas primer treba da napravimo dva tipa, PLAYER (koji ce da sadrzi informacije o igracu) i TEAM (koji treba da sadrzi informacije o timu)
// U nasem primeru podatke cemo cuvati u nizu, ali moramo imati mogucnost da promenimo mehanizam cuvanja podatka bez potrebe da menjamo biznis logiku.


// Dizajn
// Nas DataAccessLayer ce se sastojati od tri layer-a
// Najnizi ce biti Data Helper Layer koji ce se korisiti za rukovodjenje podataka. Cuvace se kao nizovi ali klase moraju biti tako organizovane da se lako moze promeniti tip cuvara podataka.
// Sledeci layer je Data Model Layer. U njemu cemo napraviti nacin kako zelimo da nam izgledaju podaci koje cuvamo. To ce biti neka vrsta privremenog skladista podtaka
// Sledeci nivo ce biti Bridge Layer, koji ce pretvarati poddatke biznis logike u podatke data access layer-a


// Data Model Layer - sluzi nam bukvalno za transfer podataka izmedju layer-a
typealias TeamData = (
    teamId: Int64?,
    city: String?,
    nickName: String?,
    abbreviation: String?
)

typealias PlayerData = (
    playerId: Int64?,
    firstName: String?,
    lastName: String?,
    number: Int?,
    teamId: Int64?,
    position: Positions?
)
// Vazno je da ove tipove ne koristimo u layer-u biznis logike. Imacemo bridge-eve koji ce konvertovati ove podatke u one potrebne biznis logici.

enum Positions: String {
    case Pitcher = "Pitcher"
    case Catcher = "Catcher"
    case FirstBase = "First Base"
    case SecondBase = "Second Base"
    case ThirdBase = "Third Base"
    case Shortstop = "Shortstop"
    case LeftField = "Left Field"
    case CenterField = "Center Field"
    case RightField = "Right field"
    case DesignatedHitter = "Designated Hitter"
}


// Data helper layer - ovim cemo preoveravati moguce greske. I pomocu njega cemo cuvati podatke. Ovo je nivo koji cemo menjati kako se storage podataka bude promenio iz niza u nesto drugo.
// Ovaj layer ce imati tip za svaki tip podatka u Data Model Layer-u
enum DataAccessError: Error {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
}

protocol DataHelperProtocol {
    associatedtype T
    static func insert(_ item: T) throws -> Int64
    static func delete(_ item: T) throws -> Void
    static func findAll() throws -> [T]?
}

class PlayerDataHelper: DataHelperProtocol {
    typealias T = PlayerData
    static var playerData: [T] = []
    
    
    static func insert(_ item: T) throws -> Int64 {
        guard item.firstName != nil && item.lastName != nil && item.number != nil && item.playerId != nil && item.position != nil && item.teamId != nil
            else {
                throw DataAccessError.Nil_In_Data
        }
        playerData.append(item)
        return item.playerId!
    }
    
    
    static func delete (_ item: T) throws -> Void {
        guard let id = item.playerId else {
            throw DataAccessError.Nil_In_Data
        }
        let playerArray = playerData
        for (index, player) in playerArray.enumerated() where player.playerId == id {
            playerData.remove(at: index)
            return
        }
        throw DataAccessError.Delete_Error
    }
    
    
    static func findAll() throws -> [T]? {
        return playerData
    }
    
    
    static func find(_ id: Int64) throws -> T? {
        for player in playerData where player.playerId == id {
            return player
        }
        return nil
    }
    
}

class TeamDataHelper: DataHelperProtocol {
    typealias T = TeamData
    static var teamData: [T] = []
    
    
    static func insert(_ item: T) throws -> Int64 {
        guard item.teamId != nil && item.city != nil && item.nickName != nil && item.abbreviation != nil
            else {
                throw DataAccessError.Nil_In_Data
        }
        teamData.append(item)
        return item.teamId!
    }
    
    
    static func delete (_ item: T) throws -> Void {
        guard let id = item.teamId else {
            throw DataAccessError.Nil_In_Data
        }
        let teamArray = teamData
        for (index, team) in teamArray.enumerated() where team.teamId ==  id {
            teamData.remove(at: index)
            return
        }
        throw DataAccessError.Delete_Error
    }
    
    
    static func findAll() throws -> [T]? {
        return teamData
    }
    
    
    static func find(_ id: Int64) throws -> T? {
        for team in teamData where team.teamId == id {
            return team
        }
        return nil
    }
    
}


//ovo je direktno cuvanje podateke bez bridge layer-a, i to nije u redu zbog eventualne buduce promene mehanizma cuvanja podataka
let bosId = try? TeamDataHelper.insert(
    TeamData(
        teamId: 0,
        city: "Boston",
        nickName: "Red Sox",
        abbreviation: "BOS")
)
print(bosId!)

let ortizId = try? PlayerDataHelper.insert(
    PlayerData(
        playerId: 0,
        firstName: "David",
        lastName: "Ortiz",
        number: 34,
        teamId: bosId,
        position: Positions.DesignatedHitter)
)
print(ortizId!)


// sad cemo koristi i bridge layer


// struktura Team je napravljena da bi reflektovala TeamData tuple koji reprezentuju tim u nasoj bazi
struct Team {
    var teamId: Int64?
    var city: String?
    var nickName:String?
    var abbreviation:String?
    
    init(teamId: Int64?, city: String?, nickName: String?, abbreviation: String?) {
        self.teamId = teamId
        self.city = city
        self.nickName = nickName
        self.abbreviation = abbreviation
    }
}

struct Player {
    var playerId: Int64?
    var firstName: String?
    var lastName: String?
    var number: Int?
    var teamId: Int64? {
        didSet {
            if let t = try? TeamBridge.retrieve(teamId!) {
                team = t
            }
        }
    }
    var position: Positions?
    var team: Team?
    
    init(playerId: Int64?, firstName: String?, lastName: String?, number:    Int?, teamId: Int64?, position: Positions?) {
        self.playerId = playerId
        self.firstName = firstName
        self.lastName = lastName
        self.number = number
        self.teamId = teamId
        self.position = position
        if let id = self.teamId {
            if let t = try? TeamBridge.retrieve(id) {
                team = t
            }
        }
    }
}

struct TeamBridge {
    
    // kada koristimo value types kao modele podataka kao sto je struktura Team,
    // moramo uzeti u obzir da su promene izvrsene na njima u stvari promene samo unutar njih samih,
    // a da bismo ih koristili i van njih, koristimo sluzbenu rec INOUT
    static func save(_ team: inout Team) throws {
        let teamData = toTeamData(team)
        let id = try TeamDataHelper.insert(teamData)
        team.teamId = id
    }
    
    static func delete(_ team:Team) throws {
        let teamData = toTeamData(team)
        try TeamDataHelper.delete(teamData)
    }
    
    static func retrieve(_ id: Int64) throws -> Team? {
        if let t = try TeamDataHelper.find(id) {
            return toTeam(t)
        }
        return nil
    }
    
    static func toTeamData(_ team: Team) -> TeamData {
        return TeamData(teamId: team.teamId , city: team.city,
                        nickName: team.nickName, abbreviation:
            team.abbreviation)
    }
    
    static func toTeam(_ teamData: TeamData) -> Team {
        return Team(teamId: teamData.teamId, city: teamData.city,
                    nickName: teamData.nickName, abbreviation:
            teamData.abbreviation)
    }
}
    

struct PlayerBridge {
    
    static func save(_ player: inout Player) throws {
        let playerData = toPlayerData(player)
        let id = try PlayerDataHelper.insert(playerData)
        player.playerId = id
    }
    
    static func delete(_ player:Player) throws {
        let playerData = toPlayerData(player)
        try PlayerDataHelper.delete(playerData)
    }
    
    static func retrieve(_ id: Int64) throws -> Player? {
        if let p = try PlayerDataHelper.find(id) {
            return toPlayer(p)
        }
        return nil
    }
    
    static func toPlayerData(_ player: Player) -> PlayerData {
        return PlayerData(playerId: player.playerId, firstName:
            player.firstName, lastName: player.lastName,
                              number: player.number, teamId: player.teamId,
                              position: player.position)
    }
    
    static func toPlayer(_ playerData: PlayerData) -> Player {
        return Player(playerId: playerData.playerId, firstName:
            playerData.firstName, lastName: playerData.lastName, number: playerData.number, teamId: playerData.teamId, position: playerData.position)
    }
}





// koriscenje data access layer-a

var bos = Team(teamId: 0, city: "Boston", nickName: "Red Sox", abbreviation: "BOS")
try? TeamBridge.save(&bos)

var ortiz = Player(playerId: 0, firstName: "David", lastName: "Ortiz", number: 34, teamId: bos.teamId, position: Positions.DesignatedHitter)
try? PlayerBridge.save(&ortiz)

if let team = try? TeamBridge.retrieve(0) {
    print("--- \(String(describing: team?.city))")
}

if let player = try? PlayerBridge.retrieve(0) {
    print("---- \(String(describing: player?.firstName)) \(String(describing: player?.lastName)) plays for \(String(describing: player?.team?.city))")
}



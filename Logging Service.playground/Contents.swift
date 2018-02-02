import UIKit

// Moraju postojati visestruki nivoi logovanja. U ovom slucaju to su FATAL, ERROR, DEBUG i INFO.
// Moraju postojati visetruki profili logovanja. U ovom slucaju to su LoggerNull i LoggerConsole.
//        Prvi nece raditi nista sa log porukom,  a drugi ce je stampati u konzoli.
// Korisnik ima mogucnost da doda svoj log profil, tako da moze postaviti poruke u bazu, labelu ili bilo koje drugo mesto.
// Mora postojati mogucnost konfigurisanja framework-a prilikom startovanja aplikacije i koriscenja konfigurisanog tokom life-cycle-a aplikacije.

// Moze se dodati vise log profila jednom nivou logovanja, da bi korisnik imao mogucnost prikazivanja ili cuvanja logovanja na vise profila.


// Dizajn
// Napravicemo dve celine. Logger Profil & Logger.
// Prvi ce da sadrzi tipove koji obavljaju postavljanje log poruka na konzolu ili cuvanje na u storage-u.
// Drugi ce da sadrzi sve tipove sa kojima se srece interfejs. Ovi tipovi odredjuju log nivo poruke, a zatim
// prosledjuju tu poruku odgovarajucem profilu koji objavljuje tu poruku.

// Logger Profil cemo praviti pomocu LoggerProfileProtocol-a, tj primenicemo polimorfizam.
// Ovo radimo ovako da bi neki drugi korinici mogli da koristeci nas fremawork dodaju log profile po potrebi.


protocol LoggerProfileProtocol {
    var loggerProfileId: String {get}
    func writeLog(level: String, message: String)
}

extension LoggerProfileProtocol {
    func getCurrentDateString() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        return dateFormatter.string(from: date)
    }
}



struct LoggerNull: LoggerProfileProtocol {
    let loggerProfileId = "knezevic.vuk.logger.null" //Reverse DNS notation is a naming convention that is commonly used to name components, packages, and other types
    func writeLog(level: String, message: String) {
        // Ne radi nista jer je ovo LoggerNull
    }
}

struct LoggerConsole: LoggerProfileProtocol {
    let loggerProfileId = "knezevic.vuk.logger.console" //Reverse DNS notation is a naming convention that is commonly used to name components, packages, and other types
    func writeLog(level: String, message: String) {
        let now = getCurrentDateString()
        print("\(now): \(level) - \(message)")
    }
}


// definisano je pet nivoa logovanja
enum LogLevels: String {
    case Fatal
    case Error
    case Warn
    case Debug
    case Info
    
    static let allValues = [Fatal, Error, Warn, Debug, Info]
}


// Sad pravimo drugu celinu LoggerProtocol

protocol LoggerProtocol {
    // napravili smo ih static, zbog pamcenja postavljene konfiguracije tokom zivotnog ciklusa aplikacije
    //moglo je da se koristi i singleton pattern, ali je u ovom slucaju ovako jednostavnije
    static var loggers: [LogLevels:[LoggerProfileProtocol]] {get set}
    static func writeLog(logLevel: LogLevels, message: String)
}

extension LoggerProtocol {
    
    // proverava da li log nivo vec ima log profil
    static func logLevelContainsProfile(logLevel: LogLevels, loggerProfile: LoggerProfileProtocol) -> Bool {
        if let logProfiles = loggers[logLevel] {
            for logProfile in logProfiles where
                logProfile.loggerProfileId == loggerProfile.loggerProfileId {
                        return true
            }
        }
        return false
    }
    
    // dodaje log profil log nivou
    static func setLogLevel(logLevel: LogLevels, loggerProfile: LoggerProfileProtocol) {
        if let _ = loggers[logLevel] {
            if !logLevelContainsProfile(logLevel: logLevel, loggerProfile: loggerProfile) {
                loggers[logLevel]?.append(loggerProfile)
            }
        } else {
            var a = [LoggerProfileProtocol]()
            a.append(loggerProfile)
            loggers[logLevel] = a
        }
    }
    
    // dodaje log profil svim log nivoima
    static func addLogProfileToAllLevels(defaultLoggerProfile: LoggerProfileProtocol) {
        for level in LogLevels.allValues {
            setLogLevel(logLevel: level, loggerProfile: defaultLoggerProfile)
        }
    }
    
    // uklanja log profil iz log nivoa ako je on vec definisan za taj nivo
    static func removeLogProfileFromLevel(logLevel: LogLevels, loggerProfile:LoggerProfileProtocol) {
        if var logProfiles = loggers[logLevel] {
            if let index = logProfiles.index(where: {$0.loggerProfileId == loggerProfile.loggerProfileId}) {
                logProfiles.remove(at: index)
            }
            loggers[logLevel] = logProfiles
        }
    }
    
    // uklanja log prifil iz svih log nivoa
    static func removeLogProfileFromAllLevels(loggerProfile:LoggerProfileProtocol) {
        for level in LogLevels.allValues {
            removeLogProfileFromLevel(logLevel: level, loggerProfile: loggerProfile)
        }
    }
    
    // proverava da li postoji bilo kakav log profil konfigurisan za taj log nivo
    static func hasLoggerForLevel(logLevel: LogLevels) -> Bool {
        guard let _ = loggers[logLevel] else {
            return false
        }
        return true
    }
    
}


// ova struktura nam sluzi za konfigurisanje log nivoa u nasoj aplikaciji kao i za logovanje poruka.
struct Logger: LoggerProtocol {
    static var loggers = [LogLevels:[LoggerProfileProtocol]]()
    
    static func writeLog(logLevel: LogLevels, message: String) {
        guard hasLoggerForLevel(logLevel: logLevel) else {
            print("No logger")
            return
        }
        if let logProfiles = loggers[logLevel] {
            for logProfile in logProfiles {
                logProfile.writeLog(level: logLevel.rawValue, message:
                    message)
            }
        }
    }
    
}


// Koristimo ga ovako
Logger.addLogProfileToAllLevels(defaultLoggerProfile: LoggerConsole())
Logger.writeLog(logLevel: LogLevels.Debug, message: "Prva debug poruka")
Logger.setLogLevel(logLevel: LogLevels.Error, loggerProfile: LoggerConsole())
Logger.writeLog(logLevel: LogLevels.Error, message: "Prva error poruka")





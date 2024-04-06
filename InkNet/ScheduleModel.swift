// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let scheduleData = try? JSONDecoder().decode(ScheduleData.self, from: jsonData)

import Foundation

// MARK: - ScheduleData
struct ScheduleData: Codable {
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let regularSchedules: Schedules
    let bankaraSchedules: Schedules
    let xSchedules: Schedules
    let eventSchedules: EventSchedules
    let festSchedules: Schedules
    let coopGroupingSchedule: CoopGroupingSchedule
    let currentFest: JSONNull?
    let currentPlayer: CurrentPlayer
    let vsStages: VsStages

    enum CodingKeys: String, CodingKey {
        case regularSchedules = "regularSchedules"
        case bankaraSchedules = "bankaraSchedules"
        case xSchedules = "xSchedules"
        case eventSchedules = "eventSchedules"
        case festSchedules = "festSchedules"
        case coopGroupingSchedule = "coopGroupingSchedule"
        case currentFest = "currentFest"
        case currentPlayer = "currentPlayer"
        case vsStages = "vsStages"
    }
}

// MARK: - Schedules
struct Schedules: Codable {
    let nodes: [BankaraSchedulesNode]

    enum CodingKeys: String, CodingKey {
        case nodes = "nodes"
    }
}

// MARK: - BankaraSchedulesNode
struct BankaraSchedulesNode: Codable {
    let startTime: Date
    let endTime: Date
    let bankaraMatchSettings: [MatchSetting]?
    let festMatchSettings: JSONNull?
    let regularMatchSetting: MatchSetting?
    let xMatchSetting: MatchSetting?

    enum CodingKeys: String, CodingKey {
        case startTime = "startTime"
        case endTime = "endTime"
        case bankaraMatchSettings = "bankaraMatchSettings"
        case festMatchSettings = "festMatchSettings"
        case regularMatchSetting = "regularMatchSetting"
        case xMatchSetting = "xMatchSetting"
    }
}

// MARK: - MatchSetting
struct MatchSetting: Codable {
    let isVsSetting: IsVsSetting
    let typename: IsVsSetting
    let vsStages: [Stage]
    let vsRule: VsRule
    let bankaraMode: BankaraMode?
    let leagueMatchEvent: LeagueMatchEvent?

    enum CodingKeys: String, CodingKey {
        case isVsSetting = "__isVsSetting"
        case typename = "__typename"
        case vsStages = "vsStages"
        case vsRule = "vsRule"
        case bankaraMode = "bankaraMode"
        case leagueMatchEvent = "leagueMatchEvent"
    }
}

enum BankaraMode: String, Codable {
    case bankaraModeOPEN = "OPEN"
    case challenge = "CHALLENGE"
}

enum IsVsSetting: String, Codable {
    case bankaraMatchSetting = "BankaraMatchSetting"
    case leagueMatchSetting = "LeagueMatchSetting"
    case regularMatchSetting = "RegularMatchSetting"
    case xMatchSetting = "XMatchSetting"
}

// MARK: - LeagueMatchEvent
struct LeagueMatchEvent: Codable {
    let leagueMatchEventID: String
    let name: String
    let desc: String
    let regulationURL: JSONNull?
    let regulation: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case leagueMatchEventID = "leagueMatchEventId"
        case name = "name"
        case desc = "desc"
        case regulationURL = "regulationUrl"
        case regulation = "regulation"
        case id = "id"
    }
}

// MARK: - VsRule
struct VsRule: Codable {
    let name: Name
    let rule: Rule
    let id: ID

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case rule = "rule"
        case id = "id"
    }
}

enum ID: String, Codable {
    case vnNSDWxlLTA = "VnNSdWxlLTA="
    case vnNSDWxlLTE = "VnNSdWxlLTE="
    case vnNSDWxlLTI = "VnNSdWxlLTI="
    case vnNSDWxlLTM = "VnNSdWxlLTM="
    case vnNSDWxlLTQ = "VnNSdWxlLTQ="
}

enum Name: String, Codable {
    case clamBlitz = "Clam Blitz"
    case rainmaker = "Rainmaker"
    case splatZones = "Splat Zones"
    case towerControl = "Tower Control"
    case turfWar = "Turf War"
}

enum Rule: String, Codable {
    case area = "AREA"
    case clam = "CLAM"
    case goal = "GOAL"
    case loft = "LOFT"
    case turfWar = "TURF_WAR"
}

// MARK: - Stage
struct Stage: Codable {
    let vsStageID: Int?
    let name: String
    let image: UserIcon
    let id: String
    let thumbnailImage: UserIcon?

    enum CodingKeys: String, CodingKey {
        case vsStageID = "vsStageId"
        case name = "name"
        case image = "image"
        case id = "id"
        case thumbnailImage = "thumbnailImage"
    }
}

// MARK: - UserIcon
struct UserIcon: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

// MARK: - CoopGroupingSchedule
struct CoopGroupingSchedule: Codable {
    let bannerImage: JSONNull?
    let regularSchedules: RegularSchedules
    let bigRunSchedules: Schedules
    let teamContestSchedules: Schedules

    enum CodingKeys: String, CodingKey {
        case bannerImage = "bannerImage"
        case regularSchedules = "regularSchedules"
        case bigRunSchedules = "bigRunSchedules"
        case teamContestSchedules = "teamContestSchedules"
    }
}

// MARK: - RegularSchedules
struct RegularSchedules: Codable {
    let nodes: [PurpleNode]

    enum CodingKeys: String, CodingKey {
        case nodes = "nodes"
    }
}

// MARK: - PurpleNode
struct PurpleNode: Codable {
    let startTime: Date
    let endTime: Date
    let setting: Setting
    let splatoon3InkKingSalmonidGuess: String

    enum CodingKeys: String, CodingKey {
        case startTime = "startTime"
        case endTime = "endTime"
        case setting = "setting"
        case splatoon3InkKingSalmonidGuess = "__splatoon3ink_king_salmonid_guess"
    }
}

// MARK: - Setting
struct Setting: Codable {
    let typename: String
    let boss: Boss
    let coopStage: Stage
    let isCoopSetting: String
    let weapons: [Weapon]

    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
        case boss = "boss"
        case coopStage = "coopStage"
        case isCoopSetting = "__isCoopSetting"
        case weapons = "weapons"
    }
}

// MARK: - Boss
struct Boss: Codable {
    let name: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
}

// MARK: - Weapon
struct Weapon: Codable {
    let splatoon3InkID: String
    let name: String
    let image: UserIcon

    enum CodingKeys: String, CodingKey {
        case splatoon3InkID = "__splatoon3ink_id"
        case name = "name"
        case image = "image"
    }
}

// MARK: - CurrentPlayer
struct CurrentPlayer: Codable {
    let userIcon: UserIcon

    enum CodingKeys: String, CodingKey {
        case userIcon = "userIcon"
    }
}

// MARK: - EventSchedules
struct EventSchedules: Codable {
    let nodes: [EventSchedulesNode]

    enum CodingKeys: String, CodingKey {
        case nodes = "nodes"
    }
}

// MARK: - EventSchedulesNode
struct EventSchedulesNode: Codable {
    let leagueMatchSetting: MatchSetting
    let timePeriods: [TimePeriod]

    enum CodingKeys: String, CodingKey {
        case leagueMatchSetting = "leagueMatchSetting"
        case timePeriods = "timePeriods"
    }
}

// MARK: - TimePeriod
struct TimePeriod: Codable {
    let startTime: Date
    let endTime: Date

    enum CodingKeys: String, CodingKey {
        case startTime = "startTime"
        case endTime = "endTime"
    }
}

// MARK: - VsStages
struct VsStages: Codable {
    let nodes: [VsStagesNode]

    enum CodingKeys: String, CodingKey {
        case nodes = "nodes"
    }
}

// MARK: - VsStagesNode
struct VsStagesNode: Codable {
    let vsStageID: Int
    let originalImage: UserIcon
    let name: String
    let stats: JSONNull?
    let id: String

    enum CodingKeys: String, CodingKey {
        case vsStageID = "vsStageId"
        case originalImage = "originalImage"
        case name = "name"
        case stats = "stats"
        case id = "id"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

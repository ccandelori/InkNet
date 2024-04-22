//
//  Constants.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/12/24.
//

import Foundation

enum Icons: String {
  case regular
}

enum Dimensions: CGFloat {
  case cornerRadius = 16.0
}

enum ScheduleType {
  case regular([BankaraSchedulesNode])
  case bankara([BankaraSchedulesNode])
  case xRank([BankaraSchedulesNode])
  case event([EventSchedulesNode])
  case fest([BankaraSchedulesNode])
  case coop([PurpleNode])

  var schedules: [Any] {
    switch self {
    case .regular(let nodes): return nodes
    case .bankara(let nodes): return nodes
    case .xRank(let nodes): return nodes
    case .event(let nodes): return nodes
    case .fest(let nodes): return nodes
    case .coop(let nodes): return nodes
    }
  }

  var title: String {
    switch self {
    case .regular: return "Turf War"
    case .bankara: return "Anarchy Battle"
    case .xRank: return "X Rank Battle"
    case .event: return "Event Battle"
    case .fest: return "Splatfest"
    case .coop: return "Salmon Run"
    }
  }
}

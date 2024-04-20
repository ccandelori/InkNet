//
//  GearModel.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/19/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gearData = try? JSONDecoder().decode(GearData.self, from: jsonData)

import Foundation

// MARK: - GearData
struct GearData: Codable {
  let data: GearDataClass

  enum CodingKeys: String, CodingKey {
    case data
  }
}

// MARK: - DataClass
struct GearDataClass: Codable {
  let gesotown: Gesotown

  enum CodingKeys: String, CodingKey {
    case gesotown
  }
}

// MARK: - Gesotown
struct Gesotown: Codable {
  let pickupBrand: PickupBrand
  let limitedGears: [DGear]

  enum CodingKeys: String, CodingKey {
    case pickupBrand
    case limitedGears
  }
}

// MARK: - DGear
struct DGear: Codable {
  let id: String
  let saleEndTime: Date
  let price: Int
  let gear: Gear
  let isAlreadyOrdered: Bool
  let nextGear: NextGearClass?
  let previousGear: NextGearClass?
  let ownedGear: GearNull?

  enum CodingKeys: String, CodingKey {
    case id
    case saleEndTime
    case price
    case gear
    case isAlreadyOrdered
    case nextGear
    case previousGear
    case ownedGear
  }
}

// MARK: - Gear
struct Gear: Codable {
  let splatoon3InkID: String
  let typename: String
  let name: String
  let primaryGearPower: GearPower
  let additionalGearPowers: [GearPower]
  let image: GearImage
  let brand: Brand

  enum CodingKeys: String, CodingKey {
    case splatoon3InkID = "__splatoon3ink_id"
    case typename = "__typename"
    case name = "name"
    case primaryGearPower = "primaryGearPower"
    case additionalGearPowers = "additionalGearPowers"
    case image = "image"
    case brand = "brand"
  }
}

// MARK: - GearPower
struct GearPower: Codable {
  let splatoon3InkID: String
  let name: String
  let image: GearImage

  enum CodingKeys: String, CodingKey {
    case splatoon3InkID = "__splatoon3ink_id"
    case name = "name"
    case image = "image"
  }
}

// MARK: - Image
struct GearImage: Codable {
  let url: String

  enum CodingKeys: String, CodingKey {
    case url
  }
}

// MARK: - Brand
struct Brand: Codable {
  let name: String
  let image: GearImage?
  let id: String
  let usualGearPower: UsualGearPower?

  enum CodingKeys: String, CodingKey {
    case name
    case image
    case id
    case usualGearPower
  }
}

// MARK: - UsualGearPower
struct UsualGearPower: Codable {
  let splatoon3InkID: String
  let name: String
  let desc: String
  let image: GearImage
  let isEmptySlot: Bool

  enum CodingKeys: String, CodingKey {
    case splatoon3InkID = "__splatoon3ink_id"
    case name = "name"
    case desc = "desc"
    case image = "image"
    case isEmptySlot = "isEmptySlot"
  }
}

// MARK: - NextGearClass
struct NextGearClass: Codable {
  let id: String

  enum CodingKeys: String, CodingKey {
    case id
  }
}

// MARK: - PickupBrand
struct PickupBrand: Codable {
  let image: GearImage
  let brand: Brand
  let saleEndTime: Date
  let brandGears: [DGear]
  let nextBrand: Brand

  enum CodingKeys: String, CodingKey {
    case image
    case brand
    case saleEndTime
    case brandGears
    case nextBrand
  }
}

// MARK: - Encode/decode helpers

class GearNull: Codable, Hashable {
  public static func == (lhs: GearNull, rhs: GearNull) -> Bool {
    return true
  }

//  public var hashValue: Int {
//    return 0
//  }

  public func hash(into hasher: inout Hasher) {
    // No-op
  }

  public init() {}

  public required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if !container.decodeNil() {
      throw DecodingError.typeMismatch(
        GearNull.self,
        DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for GearNull"))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encodeNil()
  }
}

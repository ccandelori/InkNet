//
//  SalmonRunModel.swift
//  InkNet
//
//  Created by Cameron Candelori on 4/6/24.
//

import Foundation

// MARK: - SRMonthlyGearResponse
struct SRMonthlyGearResponse: Codable {
    let data: SRData

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - SRData
struct SRData: Codable {
    let coopResult: SRCoopResult

    enum CodingKeys: String, CodingKey {
        case coopResult = "coopResult"
    }
}

// MARK: - SRCoopResult
struct SRCoopResult: Codable {
    let monthlyGear: SRMonthlyGear

    enum CodingKeys: String, CodingKey {
        case monthlyGear = "monthlyGear"
    }
}

// MARK: - SRMonthlyGear
struct SRMonthlyGear: Codable {
    let name: String
    let image: SRImage

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
    }
}

// MARK: - SRImage
struct SRImage: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

//
//  Aircraft.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import Foundation
import Combine

final class Aircraft {
    @Published var aircraftId: String = ""
    @Published var userchecklists: [String] = []
    let id: UUID
    
    init(){
        id = UUID()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        aircraftId = try container.decode(String.self, forKey: .aircraftId)
        userchecklists = try container.decode([String].self, forKey: .userchecklists)
        id = try container.decode(UUID.self, forKey: .id)
    }
}

extension Aircraft: Codable{
    
    enum CodingKeys: CodingKey{
        case aircraftId
        case userchecklists
        case id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(aircraftId, forKey: .aircraftId)
        try container.encode(userchecklists, forKey: .userchecklists)
    }
}

extension Aircraft: Equatable{
    static func == (lhs: Aircraft, rhs: Aircraft) -> Bool {
        lhs.id == rhs.id
    }
}

extension Aircraft: Identifiable{}

extension Aircraft: ObservableObject{}

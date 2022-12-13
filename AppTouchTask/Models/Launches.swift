//
//  Launches.swift
//  AppTouchTask
//
//  Created by Vijay K on 13/12/22.
//

import Foundation

class Launches: Codable {
    let name: String
    let date_local: String
    let rocket: String
    let success: Bool
    let links: Links?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        date_local = try container.decodeIfPresent(String.self, forKey: .date_local) ?? ""
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        rocket = try container.decodeIfPresent(String.self, forKey: .rocket) ?? ""
        links = try container.decodeIfPresent(Links.self, forKey: .links)
    }
}

class Links: Codable {
    let patch: Patch?
    let article: String
    let wikipedia: String
    let youtube_id: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        patch = try container.decodeIfPresent(Patch.self, forKey: .patch)
        article = try container.decodeIfPresent(String.self, forKey: .article) ?? ""
        wikipedia = try container.decodeIfPresent(String.self, forKey: .wikipedia) ?? ""
        youtube_id = try container.decodeIfPresent(String.self, forKey: .youtube_id) ?? ""
    }
}

class Patch: Codable {
    let small, large: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        small = try container.decodeIfPresent(String.self, forKey: .small) ?? ""
        large = try container.decodeIfPresent(String.self, forKey: .large) ?? ""
    }
}

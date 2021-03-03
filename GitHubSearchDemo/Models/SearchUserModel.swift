//
//  SearchUserModel.swift
//  GitHubSearchDemo
//
//  Created by Arthur on 2021/3/3.
//

import Foundation
struct SearchUserResult: Codable{
    
    let total: Int
    let items: [SearchUserItem]
    
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case items = "items"
    }
    
    init(total: Int = 0 ,items: [SearchUserItem] = [SearchUserItem()]) {
        self.total = total
        self.items = items
    }
    
    
}
struct SearchUserItem: Codable{
    
    let username: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileImageUrl = "avatar_url"
    }
    
    init(username: String = "" ,profileImageUrl: String = "") {
        self.username = username
        self.profileImageUrl = profileImageUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileImageUrl = try values.decodeIfPresent(String.self, forKey: .profileImageUrl)
    }
    
}

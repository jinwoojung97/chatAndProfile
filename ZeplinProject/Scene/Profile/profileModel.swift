// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let result: Result
    let status: String
}

// MARK: - Result
struct Result: Codable {
    let member: Member
    let photo: Photo
}

// MARK: - Member
struct Member: Codable {
    
    let chat_name: String
    let mem_age: String
    let mem_sex: String
    let distance: Int?
    let loc: String?
    let l_code: String?
    let chat_conts: String?
    let totLikeCnt: String?

    
}

// MARK: - Photo
struct Photo: Codable {
    
    let photoList: [PhotoList]
    let photoCertCnt: Int
    let defPhoto: String
    let cnt: String

    
}

// MARK: - PhotoList
struct PhotoList: Codable {
    
    let url: String

}


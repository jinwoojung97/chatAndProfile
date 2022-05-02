//
//  StoryListModel.swift
//  ZeplinProject
//
//  Created by inforex on 2021/07/15.
//

import Foundation

// MARK: - StoryList
struct StoryList: Codable {
    let total_page: Int
    let list: [List]
    let current_page: Int
    let status: String

    
}

// MARK: - List
struct List: Codable {
    let send_mem_photo: String?
    let send_mem_no: String
    let send_chat_name: String
    let story_conts: String?
    let ins_date: String
    let read_yn: String
    let bj_id: String
    let reg_no: String
    let send_mem_gender: String
    

}

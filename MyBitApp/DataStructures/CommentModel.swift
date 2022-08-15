//
//  CommentModel.swift
//  MyBitApp
//
//  Created by admin on 08.08.2022.
//

import Foundation

/// Model which contains data about comment
struct CommentModel: Decodable {

//    /// Date when comment was left
//    let date: Date
//
//    /// Name of comment's author
//    let author: String
//
//    /// Text of the comment
//    let text: String
    
    let id: Int16
    let body: String
    let postId: Int16
}

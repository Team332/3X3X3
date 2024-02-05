//
//  Model.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import Foundation

// 모든 단어장
class TotalVocabularyList {
    static let shared = TotalVocabularyList()
    
    private init() {}
    
    var list: [VocabularyList]
}

// 단어장
struct VocabularyList {
    var name: String
    var word: [[String: String]: Bool] // = [["word" : "단어"] : true] -> 정답 여부
    var isCompleted: Bool // 리스트 학습 완료 시 true
}

// 사용자
class User {
    static let shared = User()
    
    private init() {}
    
    var userName: String
    var userLevel: Int
    var userEXP: Int
    var averageScore: Double
    var totalWords: Int
    var wrongAnswerList: [String: String]
}
cgcol

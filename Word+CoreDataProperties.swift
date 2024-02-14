//
//  Word+CoreDataProperties.swift
//  
//
//  Created by 영현 on 2/14/24.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var isCorrect: Bool
    @NSManaged public var meaning: String?
    @NSManaged public var word: String?
    @NSManaged public var vocabularyList: VocabularyList?

}

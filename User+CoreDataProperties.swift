//
//  User+CoreDataProperties.swift
//  
//
//  Created by 영현 on 2/14/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var averageScore: Double
    @NSManaged public var totalWords: Int64
    @NSManaged public var userEXP: Int64
    @NSManaged public var userLevel: Int64
    @NSManaged public var userName: String?
    @NSManaged public var vocabularyList: NSSet?

}

// MARK: Generated accessors for vocabularyList
extension User {

    @objc(addVocabularyListObject:)
    @NSManaged public func addToVocabularyList(_ value: VocabularyList)

    @objc(removeVocabularyListObject:)
    @NSManaged public func removeFromVocabularyList(_ value: VocabularyList)

    @objc(addVocabularyList:)
    @NSManaged public func addToVocabularyList(_ values: NSSet)

    @objc(removeVocabularyList:)
    @NSManaged public func removeFromVocabularyList(_ values: NSSet)

}

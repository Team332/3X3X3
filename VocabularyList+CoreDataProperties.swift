//
//  VocabularyList+CoreDataProperties.swift
//  
//
//  Created by 영현 on 2/14/24.
//
//

import Foundation
import CoreData


extension VocabularyList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabularyList> {
        return NSFetchRequest<VocabularyList>(entityName: "VocabularyList")
    }

    @NSManaged public var isCompleted: Bool
    @NSManaged public var name: String?
    @NSManaged public var totalVocabularyList: TotalVocabularyList?
    @NSManaged public var user: User?
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension VocabularyList {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: Word)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: Word)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

//
//  CalendarViewController.swift
//  3X3X3
//
//  Created by A on 2024/02/06.
//

import Foundation
import UIKit
import CoreData

class CalendarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var correctRate: CGFloat = 0.0
    var correctRates: [CGFloat] = []
    var totalQuestion: Int = 0

    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    private let reuseIdentifier = "Cell"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.team332.withAlphaComponent(0.5)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.layer.cornerRadius = 15
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedCorrectRate = UserDefaults.standard.value(forKey: "CorrectRate") as? CGFloat {
                    correctRate = savedCorrectRate
                }
        if let savedCorrectRates = UserDefaults.standard.array(forKey: "CorrectRates") as? [CGFloat] {
                correctRates = savedCorrectRates
            }
        updateRate()
    }
    
    func updateRate(){
        guard let context = persistentContainer?.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                let wordsCount = try context.count(for: fetchRequest)
                totalQuestion = wordsCount
                let incorrectWordCount = result.filter { !($0.value(forKey: "isCorrect") as? Bool ?? true) }.count
                let correctWordCount = totalQuestion - incorrectWordCount
                
                correctRate = CGFloat(correctWordCount) / CGFloat(totalQuestion)
                correctRates.append(correctRate)
                print(correctRates)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        UserDefaults.standard.set(correctRates, forKey: "CorrectRates")

        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 90
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarCell
        
        cell.textLabel.text = "\(indexPath.item + 1)"
        
        if correctRates.count - 1 >= indexPath.item, correctRates[indexPath.item] >= 0.6 {
                    cell.backgroundColor = .check
                    cell.textLabel.text = "✔️"
                } else {
                    cell.backgroundColor = .team332
                }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7
        return CGSize(width: width, height: width)
    }
}

class CalendarCell: UICollectionViewCell {
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        textLabel.frame = contentView.bounds
        
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

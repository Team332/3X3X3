//
//  CalendarViewController.swift
//  3X3X3
//
//  Created by A on 2024/02/06.
//

import Foundation
import UIKit

class CalendarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"
    var correctRates: [CGFloat] {
        UserDefaults.standard.object(forKey: "CorrectRates") as! [CGFloat]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.team332.withAlphaComponent(0.5)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.layer.cornerRadius = 15
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 90
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarCell
        
        cell.textLabel.text = "\(indexPath.item + 1)"
        
        // 날짜 & 정답률 60
//        if indexPath.item + 1 == today && correctRate >= 0.6 {
        if correctRates.count - 1 >= indexPath.item && correctRates[indexPath.item] >= 0.6 {
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

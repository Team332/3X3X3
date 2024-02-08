//
//  ProfileViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit
import CoreData

var persistentContainer: NSPersistentContainer? {
    (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
}

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUi()
        
        updateExperience()
        let calendarVC = CalendarViewController(collectionViewLayout: UICollectionViewFlowLayout())
        addChild(calendarVC)
        view.addSubview(calendarVC.view)
        
        calendarVC.collectionView.snp.makeConstraints{ make in
            make.top.equalTo(expStack.snp.bottom).offset(5)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(self.view.snp.bottom).offset(-90)
        }
    }
    
    func updateExperience() {
        guard let context = persistentContainer?.viewContext else {return}
        
        let total = User(context: context)
        
        total.totalWords = 332
        
        let expPercentage = min(Double(total.totalWords % 100) / 100.0, 1.0)
        expBar.setProgress(Float(expPercentage), animated: true)
        
        totalWordsLabel.text = "\(total.totalWords) 개"
        
        let level = total.totalWords / 100
        rankLabel.text = "\(level) 등급"
        
        let percentage = Int(expPercentage * 100)
        expPercentLabel.text = "\(percentage) / 100"
        expLabelText.text = "\(percentage)%"
    }
    
    let samsamImage: UIImageView = {
        let samsamImage = UIImageView()
        samsamImage.translatesAutoresizingMaskIntoConstraints = false
        samsamImage.contentMode = .scaleAspectFit
        guard let image = UIImage(named: "332") else { return UIImageView() }
        samsamImage.image = image
        return samsamImage
    }()
    
    let totalWordsLabel: UILabel = {
        let totalWordsLabel = UILabel()
//        totalWordsLabel.text = "9999"
        totalWordsLabel.font = UIFont.systemFont(ofSize: 17)
        return totalWordsLabel
    }()
    
    let averageScoreLabel: UILabel = {
        let averageScoreLabel = UILabel()
        averageScoreLabel.text = "9"
        averageScoreLabel.font = UIFont.systemFont(ofSize: 17)
        return averageScoreLabel
    }()
    
    let rankLabel: UILabel = {
        let rankLabel = UILabel()
//        rankLabel.text = "99"
        rankLabel.font = UIFont.systemFont(ofSize: 17)
        return rankLabel
    }()
    
    let expLabelText: UILabel = {
        let expLabelText = UILabel()
//        expLabelText.text = "88"
        expLabelText.font = UIFont.systemFont(ofSize: 17)
        return expLabelText
    }()
    
    let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "총단어수 :"
        totalLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return totalLabel
    }()
    
    let averageLabel: UILabel = {
        let averageLabel = UILabel()
        averageLabel.text = "평균점수 :"
        averageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return averageLabel
    }()
    
    let tierLabel: UILabel = {
        let tierLabel = UILabel()
        tierLabel.text = "등       급 :"
        tierLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return tierLabel
    }()
    
    let expLabel: UILabel = {
        let expLabel = UILabel()
        expLabel.text = "경  험  치 :"
        expLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return expLabel
    }()
    
    let expBar: UIProgressView = {
        let expBar = UIProgressView()
        expBar.trackTintColor = .clear
        expBar.progressTintColor = .exp
        expBar.setProgress(0.94, animated: true)
        return expBar
    }()
    
    let expFullBar: UIProgressView = {
        let expFullBar = UIProgressView()
        expFullBar.trackTintColor = .black
        return expFullBar
    }()
    
    let expPercentLabel: UILabel = {
        let expPercentLabel = UILabel()
        expPercentLabel.textAlignment = .right
        expPercentLabel.font = UIFont.systemFont(ofSize: 12)
        return expPercentLabel
    }()
    
    let expStack: UIStackView = {
        let expStack = UIStackView()
        expStack.axis = .vertical
        expStack.spacing = 3
        return expStack
    }()
    
    let scoreLabelStack: UIStackView = {
        let scoreLabelStack = UIStackView()
        scoreLabelStack.axis = .horizontal
        scoreLabelStack.spacing = 10
        scoreLabelStack.layer.cornerRadius = 15
        scoreLabelStack.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 40)
        scoreLabelStack.isLayoutMarginsRelativeArrangement = true
        scoreLabelStack.layer.masksToBounds = true
        scoreLabelStack.backgroundColor = UIColor.team332.withAlphaComponent(0.8)
        return scoreLabelStack
    }()
    
    let labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 30
        return labelStack
    }()
    
    let scoreStack: UIStackView = {
        let scoreStack = UIStackView()
        scoreStack.axis = .vertical
        scoreStack.spacing = 30
        return scoreStack
    }()
    
    func setUi() {
        view.addSubview(samsamImage)
        view.addSubview(scoreLabelStack)
        view.addSubview(expStack)
        
        scoreLabelStack.addArrangedSubview(labelStack)
        scoreLabelStack.addArrangedSubview(scoreStack)
        
        labelStack.addArrangedSubview(totalLabel)
        labelStack.addArrangedSubview(averageLabel)
        labelStack.addArrangedSubview(tierLabel)
        labelStack.addArrangedSubview(expLabel)
        
        scoreStack.addArrangedSubview(totalWordsLabel)
        scoreStack.addArrangedSubview(averageScoreLabel)
        scoreStack.addArrangedSubview(rankLabel)
        scoreStack.addArrangedSubview(expLabelText)
        
        expStack.addArrangedSubview(expBar)
        expStack.addArrangedSubview(expFullBar)
        expStack.addArrangedSubview(expPercentLabel)
        
        scoreLabelStack.snp.makeConstraints{ make in
            make.top.equalTo(90)
            make.left.equalTo(15)
        }
        
        expStack.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(40)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        samsamImage.snp.makeConstraints{ make in
            make.top.equalTo(80)
            make.right.equalTo(-35)
        }
    }
}

//
//  ProfileViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit
import CoreData

class ProfileViewController: UIViewController {
    private lazy var totalQuestion: Int = 0
    
    var correctRate: CGFloat = 0.0

    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateExperience()

        setUi()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateExperience()
    }
    
    func updateExperience() {
        guard let context = persistentContainer?.viewContext else {return}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                let wordsCount = try context.count(for: fetchRequest)
                totalQuestion = wordsCount
                let incorrectWordCount = result.filter { !($0.value(forKey: "isCorrect") as? Bool ?? true) }.count
                let correctWordCount = totalQuestion - incorrectWordCount
                
                correctRate = CGFloat(correctWordCount) / CGFloat(totalQuestion)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        lazy var user = User(context: context)
                
        lazy var expPercentage = min(Double(totalQuestion % 100) / 100.0, 1.0)
        expBar.setProgress(Float(expPercentage), animated: true)
        
        user.totalWords = Int64(totalQuestion)
        totalWordsLabel.text = "\(user.totalWords) 개"
        print(correctRate)
        
        user.userLevel = Int64(totalQuestion / 10)
        rankLabel.text = "\(user.userLevel) 급"
        
        user.userEXP = Int64(expPercentage * 100)
        expPercentLabel.text = "\(user.userEXP) / 100"
        expLabelText.text = "\(user.userEXP)%"
        
        user.averageScore = correctRate * 100
        averageScoreLabel.text = String(format: "%.1f점", user.averageScore)
    }
    
    private lazy var samStack: UIStackView = {
        let samStack = UIStackView()
        samStack.axis = .vertical
        samStack.spacing = 40
        return samStack
    }()
    
    private lazy var samsamImage: UIImageView = {
        let samsamImage = UIImageView()
        samsamImage.translatesAutoresizingMaskIntoConstraints = false
        samsamImage.contentMode = .scaleAspectFit
        guard let image = UIImage(named: "332") else { return UIImageView() }
        samsamImage.image = image
        return samsamImage
    }()
    
    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.text = "삼사미"
        userName.font = UIFont.boldSystemFont(ofSize: 22)
        userName.layer.cornerRadius = 10
        userName.layoutMargins = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40)
        userName.layer.masksToBounds = true
        userName.backgroundColor = UIColor.team332.withAlphaComponent(0.8)
        userName.textAlignment = .center
        return userName
    }()
    
    private lazy var totalWordsLabel: UILabel = {
        let totalWordsLabel = UILabel()
        totalWordsLabel.font = UIFont.systemFont(ofSize: 17)
        return totalWordsLabel
    }()
    
    private lazy var averageScoreLabel: UILabel = {
        let averageScoreLabel = UILabel()
        averageScoreLabel.font = UIFont.systemFont(ofSize: 17)
        return averageScoreLabel
    }()
    
    private lazy var rankLabel: UILabel = {
        let rankLabel = UILabel()
        rankLabel.font = UIFont.systemFont(ofSize: 17)
        return rankLabel
    }()
    
    private lazy var expLabelText: UILabel = {
        let expLabelText = UILabel()
        expLabelText.font = UIFont.systemFont(ofSize: 17)
        return expLabelText
    }()
    
    private lazy var totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "총단어수 :"
        totalLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return totalLabel
    }()
    
    private lazy var averageLabel: UILabel = {
        let averageLabel = UILabel()
        averageLabel.text = "평균점수 :"
        averageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return averageLabel
    }()
    
    private lazy var tierLabel: UILabel = {
        let tierLabel = UILabel()
        tierLabel.text = "등       급 :"
        tierLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return tierLabel
    }()
    
    private lazy var expLabel: UILabel = {
        let expLabel = UILabel()
        expLabel.text = "경  험  치 :"
        expLabel.font = UIFont.boldSystemFont(ofSize: 17)
        return expLabel
    }()
    
    private lazy var expBar: UIProgressView = {
        let expBar = UIProgressView()
        expBar.trackTintColor = .clear
        expBar.progressTintColor = .exp
        expBar.setProgress(0.94, animated: true)
        return expBar
    }()
    
    private lazy var expFullBar: UIProgressView = {
        let expFullBar = UIProgressView()
        expFullBar.trackTintColor = .black
        return expFullBar
    }()
    
    private lazy var expPercentLabel: UILabel = {
        let expPercentLabel = UILabel()
        expPercentLabel.textAlignment = .right
        expPercentLabel.font = UIFont.systemFont(ofSize: 12)
        return expPercentLabel
    }()
    
    private lazy var expStack: UIStackView = {
        let expStack = UIStackView()
        expStack.axis = .vertical
        expStack.spacing = 3
        return expStack
    }()
    
    private lazy var scoreLabelStack: UIStackView = {
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
    
    private lazy var labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 30
        return labelStack
    }()
    
    private lazy var scoreStack: UIStackView = {
        let scoreStack = UIStackView()
        scoreStack.axis = .vertical
        scoreStack.spacing = 30
        return scoreStack
    }()
    
    func setUi() {
        view.addSubview(samStack)
        view.addSubview(scoreLabelStack)
        view.addSubview(expStack)
        
        samStack.addArrangedSubview(samsamImage)
        samStack.addArrangedSubview(userName)
        
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
        
        samStack.snp.makeConstraints{ make in
            make.top.equalTo(90)
            make.right.equalTo(-35)
        }
    }
}

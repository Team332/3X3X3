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
//    let testResultVC = TestResultViewController()
    private lazy var totalQuestion: Int = 0
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var correctRates: [CGFloat] {
        if let cor = UserDefaults.standard.object(forKey: "CorrectRates") {
            return cor as! [CGFloat]
        } else {
            return [0]
        }
//        UserDefaults.standard.object(forKey: "CorrectRates") as! [CGFloat]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUi()
        
//        updateExperience()
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
            let wordsCount = try context.count(for: fetchRequest)
            totalQuestion = wordsCount
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        lazy var total = User(context: context)
        
//        total.totalWords = 332
        
        lazy var expPercentage = min(Double(totalQuestion % 100) / 100.0, 1.0)
        expBar.setProgress(Float(expPercentage), animated: true)
        
        totalWordsLabel.text = "\(totalQuestion) 개"
        print("총 단어 수: \(totalQuestion)")
        
        lazy var level = totalQuestion / 100
        rankLabel.text = "\(level) 등급"
        
        lazy var percentage = Int(expPercentage * 100)
        expPercentLabel.text = "\(percentage) / 100"
        expLabelText.text = "\(percentage)%"
        
        lazy var average = correctRates.isEmpty ? 0 : correctRates.reduce(0, +) / CGFloat(correctRates.count)
        lazy var averageString = Int(average * 100)
        averageScoreLabel.text = "\(averageString) 점"
    }
    
    private lazy var samsamImage: UIImageView = {
        let samsamImage = UIImageView()
        samsamImage.translatesAutoresizingMaskIntoConstraints = false
        samsamImage.contentMode = .scaleAspectFit
        guard let image = UIImage(named: "332") else { return UIImageView() }
        samsamImage.image = image
        return samsamImage
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

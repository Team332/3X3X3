//
//  TestResultViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit
import CoreData

class TestResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    var vocabularyListName: String?
    var totalQuestion: Int = 0
    var correctRate: CGFloat = 0.0
    var correctRates: [CGFloat] = []
    var incorrectWords: [NSManagedObject] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupData()
        createCircle()
        setupUI()
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    


// MARK: - Data Setup

    private func setupData() {
        setupIncorrectWord()

        fetchVocabularyList()

        calculateCorrectRate()
        saveCorrectRateToUserDefaults()
    }

    private func fetchVocabularyList() {
        guard let context = persistentContainer?.viewContext else {
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VocabularyList")

        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {

            }
        } catch let error as NSError {
            print("Could not fetch VocabularyList. \(error), \(error.userInfo)")
        }
    }

    private func saveCorrectRateToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(correctRate, forKey: "CorrectRate")
    }
    
//    private func createWord(entity: NSEntityDescription, word: String, meaning: String, isCorrect: Bool, context: NSManagedObjectContext) -> NSManagedObject {
//        let wordObject = NSManagedObject(entity: entity, insertInto: context)
//        wordObject.setValue(word, forKey: "word")
//        wordObject.setValue(meaning, forKey: "meaning")
//        wordObject.setValue(isCorrect, forKey: "isCorrect")
//        
//        return wordObject
//    }

    // 틀린 단어 필터링(collectionView)
    private func setupIncorrectWord() {
        guard let context = persistentContainer?.viewContext else {
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "vocabularyList.name == %@ AND isCorrect == false", vocabularyListName ?? "")

        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {
                incorrectWords = result
                collectionView.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    // 정답률 계산
    private func calculateCorrectRate() {
        guard let context = persistentContainer?.viewContext else {
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "vocabularyList.name == %@", vocabularyListName ?? "")

        do {
            if let result = try context.fetch(fetchRequest) as? [NSManagedObject] {
                totalQuestion = result.count

                let incorrectWordCount = result.filter { !($0.value(forKey: "isCorrect") as? Bool ?? true) }.count
                let correctWordCount = totalQuestion - incorrectWordCount

                correctRate = CGFloat(correctWordCount) / CGFloat(totalQuestion)
                correctRates.append(correctRate)
                print(correctRates)
            }
        } catch let error as NSError {
            print("불러올 수 없습니다. \(error), \(error.userInfo)")
        }
    }


    
    // MARK: - Circle
    
    func createCircle() {
        let circleRadius: CGFloat = 75
        let circleLineWidth: CGFloat = 15.0
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
        }
        
        // 원 경로
        let circularPath = UIBezierPath(
            arcCenter: containerView.center,
            radius: circleRadius,
            startAngle: -CGFloat.pi / 2,                                // 시작 각도(12시)
            endAngle: 2 * CGFloat.pi * correctRate - CGFloat.pi / 2,    // 종료 각도(정답률에 따라)
            clockwise: true                                             // 시계 방향으로 그릴지 여부
        )
        
        // 정답률 테두리
        let borderLine = CAShapeLayer()
        borderLine.path = circularPath.cgPath
        borderLine.strokeColor = UIColor(red: 0xDB/255.0, green: 0xC5/255.0, blue: 0xFF/255.0, alpha: 1.0).cgColor
        borderLine.lineWidth = circleLineWidth
        borderLine.fillColor = UIColor.clear.cgColor
        borderLine.lineCap = CAShapeLayerLineCap.round
        
        containerView.layer.addSublayer(borderLine)
        
        // 정답률 label
        let correctLabel = UILabel()
        correctLabel.text = "\(Int(correctRate * 100))%" // 정확도를 백분율로 변환
        correctLabel.font = UIFont.systemFont(ofSize: 30)
        correctLabel.textColor = UIColor.black
        containerView.addSubview(correctLabel)
        
        correctLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        // 테두리 animate
        let animation = CABasicAnimation(keyPath: "strokeEnd")  // 효과의 끝 지점을 애니메이션화하는 데 사용
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.0    // 지속시간
        borderLine.add(animation, forKey: "progressAnimation")
    }
    
    
    // MARK: - UI Setup
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xDB/255.0, green: 0xC5/255.0, blue: 0xFF/255.0, alpha: 1.0)
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    private let backBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("돌아가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(red: 0xAA/255.0, green: 0xD5/255.0, blue: 0xF4/255.0, alpha: 1.0).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
        return button
    }()
    
    private let studyBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더 공부하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor(red: 0xFE/255.0, green: 0xAC/255.0, blue: 0xAC/255.0, alpha: 1.0).cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(studyBtnTap), for: .touchUpInside)
        return button
    }()
    
    // 정답률에 따른 메시지
    private var resultMessage: String {
        if correctRate >= 0 && correctRate < 0.4 {
            return "한 발짝 더 나가봐요! 걱정 마세요,\n 실력은 오늘도 업그레이드 중이에요."
        } else if correctRate >= 0.4 && correctRate < 0.7 {
            return "이렇게 쉬운 걸 다 맞을 줄 알았는데,\n 실망이야~"
        } else if correctRate >= 0.7 && correctRate < 0.9 {
            return "와, 대단해요! 여기서 뭐하는 사람이에요? \n 미래의 퀴즈 마스터?"
        } else if correctRate >= 0.9 && correctRate < 1 {
            return "와우, 대단해요! 정말 신기해요.\n 세상에 나와서 퀴즈 대회를 개최하면 안 될까요?"
        } else {
            return "정말 대단해, 우주 최고의 퀴즈 고수! \n 이제 뭐든 할 수 있을 거예요."
        }
    }
    
    private func setupUI() {
        view.addSubview(messageLabel)
        view.addSubview(coverView)
        view.addSubview(backBtn)
        view.addSubview(studyBtn)
        coverView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        messageLabel.text = resultMessage
    }
    
    // MARK: - Constraint
    
    private func setupConstraint() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(270)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        messageLabel.numberOfLines = 0
        
        coverView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(200)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom).offset(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(studyBtn.snp.leading).offset(-30)
        }
        
        studyBtn.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.top)
            make.bottom.equalTo(backBtn.snp.bottom)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(backBtn.snp.width)
        }
    }
    
    
    // MARK: CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incorrectWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 15
        
        // 틀린 단어 표시
        let wordLabel = UILabel()
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 18)
        cell.contentView.addSubview(wordLabel)
        
        let word = incorrectWords[indexPath.item].value(forKey: "word") as? String ?? ""
        let meaning = incorrectWords[indexPath.item].value(forKey: "meaning") as? String ?? ""
        
        
        wordLabel.text = "\(word)       \(meaning)"
        
        wordLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return cell
    }
    
    // MARK: - CollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 80)
    }
    
    // MARK: - Button Action
    
    @objc private func backBtnTap() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func studyBtnTap() {
        navigationController?.popToViewController(StudyViewController(), animated: true)
    }
}


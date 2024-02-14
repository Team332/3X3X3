//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//


// 해야되는 것
// 1. VocabularyList 안에 Word 로 접근하는 방법 알아내기
// 2. 데이터들 싹다 코어데이터로 옮겨버리기 (user, vobularyList, totalVocabularyList 싸그리 다)
// 3. 단어 문제 하나 풀 때 마다 15초 기준으로 시계 똑딱똑딱하기
// 4. TestResultViewController.completionHandler 만들어서 list name 넘겨주기

import UIKit
import SnapKit
import CoreData

class TestViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    let listName: String = SharedData.shared.enteredCategory!
    var vocaList: [WordCard] = []
    var copiedList: [WordCard]?
    
    //MARK: UI settings
    let quizStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = -15
        stack.alignment = .leading
        return stack
    }()
    
    let quizLabel: UILabel = {
        let label = UILabel()
        label.text = "Quiz"
        label.font = .systemFont(ofSize: 20)
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.backgroundColor = .team332
        label.layer.cornerRadius = 15
        return label
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .light332
        label.text = ""
        label.font = .systemFont(ofSize: 30)
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        return label
    }()
    
    lazy var meaningTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "정답을 입력하세요"
        field.borderStyle = .roundedRect
        field.backgroundColor = .light332
        field.textAlignment = .center
        return field
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("제출하기", for: .normal)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("시험 중단하기", for: .normal)
        button.addTarget(self, action: #selector(stopTest), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .white
        setStackView()
        addViews()
        setConstraint()
        
//        createSampleData()
//        print(getListByName(name: "My Vocabulary"))
        getListByName(name: listName)
//        print(vocaList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wordLabel.text = vocaList[0].word
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setStackView() {
        [quizLabel, wordLabel].map {
            self.quizStack.addArrangedSubview($0)
        }
    }
    
    private func addViews() {
        view.addSubview(quizStack)
        view.addSubview(meaningTextField)
        view.addSubview(submitButton)
        view.addSubview(stopButton)
    }
    
    private func setConstraint() {
        quizLabel.snp.makeConstraints({ make in
            make.height.equalTo(60)
            make.width.equalTo(80)
            //            make.leading.equalTo(wordLabel).offset(20)
        })
        wordLabel.snp.makeConstraints({ make in
            make.width.equalTo(self.view).multipliedBy(0.8)
            make.height.equalTo(self.view).multipliedBy(0.2)
        })
        quizStack.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
        })
        meaningTextField.snp.makeConstraints({ make in
            make.width.equalTo(self.view).multipliedBy(0.6)
            make.height.equalTo(self.view).multipliedBy(0.15)
            make.top.equalTo(quizStack.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        })
        submitButton.snp.makeConstraints({ make in
            make.height.equalTo(self.view).multipliedBy(0.05)
            make.width.equalTo(self.view).multipliedBy(0.4)
            make.top.equalTo(meaningTextField.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
        })
        stopButton.snp.makeConstraints({ make in
            make.height.equalTo(self.view).multipliedBy(0.05)
            //            make.width.equalTo(self.view).multipliedBy(0.4)
            make.centerX.equalTo(self.view)
            make.top.equalTo(submitButton.snp.bottom).offset(30)
        })
    }
    
    // MARK: Dummy Data
    func createSampleData() {
        if let context = persistentContainer?.viewContext {
            
            // VocabularyList 생성
            let vocabularyList = VocabularyList(context: context)
            vocabularyList.name = "My Vocabulary"
            
            // Word 생성 및 관계 설정
            let word1 = Word(context: context)
            word1.word = "Apple"
            word1.meaning = "A fruit."
            //            word1.vocabularyList = vocabularyList
            
            let word2 = Word(context: context)
            word2.word = "Car"
            word2.meaning = "A vehicle."
            //            word2.vocabularyList = vocabularyList
            
            let wordSet: NSSet = [word1, word2]
            vocabularyList.words = wordSet
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // 시험끝날 때, isCompleted 변수 바꾸는 데 쓸거임
    private func getListByName(name: String) {
        guard let context = persistentContainer?.viewContext else { return }
        
        let fetchRequest: NSFetchRequest<VocabularyList> = VocabularyList.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let lists = try context.fetch(fetchRequest)
            if let list = lists.first {
                iterateThroughWords(for: list)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func fetchWords(for vocabularyList: VocabularyList) -> [Word]? {
        // VocabularyList에 연결된 Word들을 가져오기 위한 fetchRequest 생성
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        // VocabularyList와의 관계를 통해 Word를 필터링
        fetchRequest.predicate = NSPredicate(format: "vocabularyList == %@ AND isCorrect == false", vocabularyList)
        
        do {
            // CoreData에서 Word들을 가져옴
            let words = try persistentContainer?.viewContext.fetch(fetchRequest)
            // 가져온 Word들을 반환
            return words
        } catch {
            print("Error fetching words: \(error)")
            return nil
        }
    }
    
    func iterateThroughWords(for vocabularyList: VocabularyList) {
        if let words = fetchWords(for: vocabularyList) {
            for word in words {
                self.vocaList.append(WordCard(word: String(word.word ?? ""), meaning: String(word.meaning ?? ""), isCorrect: word.isCorrect))
                print("Name: \(word.word), Definition: \(word.meaning)")
            }
        }
        print(vocaList)
    }
    
    //MARK: Button Actions
    @objc func submit() {
        var wordList = vocaList
        for i in 0..<wordList.count {
            if wordLabel.text == wordList[i].word {
                // 제출버튼 누르면, 텍스트필드 값이랑 저장된 Meaning 값이랑 비교해서 맞췄으면 true값을 준다.
                wordList[i].isCorrect = (meaningTextField.text == wordList[i].meaning) ? true : false
                
                print(wordList[i].isCorrect)
                self.copiedList = wordList // 여기서 self.copiedList값 갱신
                if i == wordList.count - 1 {
                    let finishAlert = UIAlertController(title: "마지막 단어입니다! 제출하고 시험 결과로 넘어가시겠습니까?", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "제출", style: .default, handler: { action in
                        self.applyChangesToCoreData()
//                        self.present(TestResultViewController(), animated: true)
                        self.navigationController?.pushViewController(TestResultViewController(), animated: true)
                        return// 시험 결과 뷰로 넘어가는 코드
                    })
                    let denyAction = UIAlertAction(title: "취소", style: .cancel)
                    finishAlert.addAction(okAction)
                    finishAlert.addAction(denyAction)
                    present(finishAlert, animated: true)
                    return
                }
                printNextWord()
                break
            }
        }
    }
    
    func printNextWord() {
        var wordList = vocaList
        for i in 0..<wordList.count {
            if wordList[i].word == wordLabel.text {
                wordLabel.text = wordList[i + 1].word
                meaningTextField.text = ""
                return
            }
        }
    }
    
    @objc func stopTest() {
        let stopAlert = UIAlertController(title: "정말 시험을 중단하시겠습니까?", message: "지금까지 본 시험의 결과는 저장되지 않아요!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "중단", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
//            self.performSegue(withIdentifier: "segueToVocabularyListView", sender: nil)
        })
        let noAction = UIAlertAction(title: "계속하기", style: .default)
        stopAlert.addAction(okAction)
        stopAlert.addAction(noAction)
        present(stopAlert, animated: true)
    }
    
    func applyChangesToCoreData() {
        guard let list = copiedList else { return }
        guard let context = persistentContainer?.viewContext else { return }
        
        
        for thing in list {
            let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "word == %@", thing.word)
            
            do {
                let results = try context.fetch(fetchRequest)
                if let word = results.first {
                    word.isCorrect = thing.isCorrect
                    try context.save()
                } else {
                    print("Word not found")
                }
            } catch {
                print("Error = \(error)")
            }
        }
    }
    
    
}

//MARK: Dismiss Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

struct WordCard {
    var word: String
    var meaning: String
    var isCorrect: Bool
}

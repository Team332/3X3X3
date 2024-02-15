//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//


import UIKit
import SnapKit
import CoreData

class TestViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
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
    
        if let name = SharedData.shared.enteredCategory {
            getListByName(name: name)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if vocaList.isEmpty {
            let cantAccessAlert = UIAlertController(title: "시험 볼 단어가 없어요!", message: "이미 모든 단어를 다 알고 있어요!\n 처음 화면으로 이동할게요!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) {_ in
                self.navigationController?.popToRootViewController(animated: true)
            }
            cantAccessAlert.addAction(okAction)
            present(cantAccessAlert, animated: true)
        } else {
            self.wordLabel.text = vocaList[0].word
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vocaList = []
        print(#function)
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
            make.centerX.equalTo(self.view)
            make.top.equalTo(submitButton.snp.bottom).offset(30)
        })
    }
    
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
        for i in 0..<vocaList.count {
                    if wordLabel.text == vocaList[i].word {
                        // 제출버튼 누르면, 텍스트필드 값이랑 저장된 Meaning 값이랑 비교해서 맞췄으면 true값을 준다.
                        vocaList[i].isCorrect = (meaningTextField.text == vocaList[i].meaning) ? true : false
        
                        print(vocaList[i].isCorrect)
                        
                if i == vocaList.count - 1 {
                    let finishAlert = UIAlertController(title: "마지막 단어입니다! 제출하고 시험 결과로 넘어가시겠습니까?", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "제출", style: .default, handler: { action in
                        self.applyChangesToCoreData()
                        self.navigationController?.pushViewController(TestResultViewController(), animated: true)
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
        for i in 0..<vocaList.count {
            if vocaList[i].word == wordLabel.text {
                wordLabel.text = vocaList[i + 1].word
                meaningTextField.text = ""
                return
            }
        }
    }
    
    @objc func stopTest() {
        let stopAlert = UIAlertController(title: "정말 시험을 중단하시겠습니까?", message: "지금까지 본 시험의 결과는 저장되지 않아요!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "중단", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        let noAction = UIAlertAction(title: "계속하기", style: .default)
        stopAlert.addAction(okAction)
        stopAlert.addAction(noAction)
        present(stopAlert, animated: true)
    }
    
    func applyChangesToCoreData() {
        let list = vocaList

        guard let context = persistentContainer?.viewContext else { return }
        
        for thing in list {
            let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "word == %@", thing.word)
            
            // 단어장 내부에 Word entity의 isCorrect 값이 모두 true인 경우에만
            do {
                let results = try context.fetch(fetchRequest)
                if let word = results.first {
                    word.isCorrect = thing.isCorrect
                    print(word.isCorrect)
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

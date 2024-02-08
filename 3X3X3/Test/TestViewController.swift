//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//


// 해야되는 것
// 1. 시험 중단하고 돌아가기 -> 그 동안 시험 본 결과들 싹다 무효처리하고 공부하는 페이지로 돌아가도록 만들기
// 2. 데이터들 싹다 코어데이터로 옮겨버리기 (user, vobularyList, totalVocabularyList 싸그리 다)
// 3. 단어 문제 하나 풀 때 마다 15초 기준으로 시계 똑딱똑딱하기

import UIKit
import SnapKit

class TestViewController: UIViewController {
    let total = TotalVocabularyList.shared
    var copiedList: VocabularyList?
    var count: Int = 0
    
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
        
        generateDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setCopiedList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wordLabel.text = copiedList?.word[0].word
    }
    
    // MARK: UI Settings
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
    
    // MARK: For Test
    func generateDummyData() {
        let list = VocabularyList(name: "Dummy", word: [Word(word: "One", meaning: "1", isCorrect: false), Word(word: "Two", meaning: "2", isCorrect: false), Word(word: "Three", meaning: "3", isCorrect: false), Word(word: "Four", meaning: "4", isCorrect: false)], isCompleted: false)
        
        total.list?.append(list)
        self.copiedList = list
    }
    
//    func setCopiedList() {
//        if let list = total.list {
//            for l in list {
//                if l.name == "Dummy" {
//                    copiedList = l
//                }
//            }
//        }
//    }
    
    
    @objc func submit() {
        if var wordList = copiedList {
            for i in 0..<wordList.word.count {
                if wordLabel.text == wordList.word[i].word {
                    // 제출버튼 누르면, 텍스트필드 값이랑 저장된 Meaning 값이랑 비교해서 맞췄으면 true값을 준다.
                    wordList.word[i].isCorrect = (meaningTextField.text == wordList.word[i].meaning) ? true : false
                    
                    print(wordList.word[i].isCorrect)
                    self.copiedList = wordList // 여기서 self.copiedList값 갱신
                    if i == wordList.word.count - 1 {
                        let finishAlert = UIAlertController(title: "마지막 단어입니다! 제출하고 시험 결과로 넘어가시겠습니까?", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "제출", style: .default, handler: { action in
                            self.present(TestResultViewController(), animated: true) // 이 부분 performSegue로 바꾸기
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
        } else { print("Error: Wrong Reference")}
    }
    
    // 다음 단어 보여주는 함수, 마지막 단어일 때 제출하기 누르면 Alert 띄워서 마지막 단어임을 알리고, 시험 결과 페이지로 넘어간다고 알려주는 기능까지 추가하면 될 듯
    func printNextWord() {
        if let wordList = copiedList?.word {
            for i in 0..<wordList.count {
                if wordList[i].word == wordLabel.text {
                    wordLabel.text = wordList[i + 1].word
                    meaningTextField.text = ""
                    return
                }
            }
        } else { print("Error: Wrong Reference")}
    }
    
    @objc func stopTest() {
        let stopAlert = UIAlertController(title: "정말 시험을 중단하시겠습니까?", message: "지금까지 본 시험의 결과는 저장되지 않아요!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "중단", style: .default, handler: { action in
            self.performSegue(withIdentifier: "segueToVocabularyListView", sender: nil)
        })
        let noAction = UIAlertAction(title: "계속하기", style: .default)
        stopAlert.addAction(okAction)
        stopAlert.addAction(noAction)
        present(stopAlert, animated: true)
    }
    
    func segueToTestResultView() {
        
    }
    
    func segueToVocabularyListView() {
        
    }
    
    func testCheck() {
        print(self.copiedList)
    }
}


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

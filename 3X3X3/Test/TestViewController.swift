//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
//    let total = TotalVocabularyList.shared
//    var copiedList: [VocabularyList]?
    
    let quizStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = -15
        stack.alignment = .leading
        return stack
    }()
    
    let quizLabel: UILabel = {
        let label = UILabel()
        label.text = "QUIZ"
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
        label.text = "문제"
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        view.backgroundColor = .white
        setStackView()
        addViews()
        setConstraint()
        
//        generateDummyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        copiedList = total.list
//        guard copiedList == nil else {
//            for list in copiedList {
//                if list.name == "Dummy" {
//                    
//                }
//            }
//        }
        
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
    }
    
    private func setConstraint() {
        quizLabel.snp.makeConstraints({ make in
            make.height.equalTo(60)
            make.width.equalTo(80)
            make.leading.equalTo(wordLabel).offset(20)
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
    }
    
    // MARK: For Test
//    func generateDummyData() {
//        var list = VocabularyList(name: "Dummy", word: [Word(word: "One", meaning: "1", isCorrect: false), Word(word: "Two", meaning: "2", isCorrect: false), Word(word: "Three", meaning: "3", isCorrect: false), Word(word: "Four", meaning: "4", isCorrect: false)], isCompleted: false)
//        
//        total.list?.append(list)
//    }
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

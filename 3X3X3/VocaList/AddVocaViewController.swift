//
//  AddVocaViewController.swift
//  3X3X3
//
//  Created by 최유리 on 2/7/24.
//

import UIKit
import SnapKit

class AddVocaViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TotalVocabularyList.shared.list?[0].name
        label.textColor = UIColor(named: "Team332Color")
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        
        return label
    }()
    
    private var vocaStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        
        let wordText = UITextField()
        wordText.borderStyle = .roundedRect
        wordText.clearButtonMode = .always
        wordText.placeholder = "단어를 입력하세요"
        wordText.font = .systemFont(ofSize: 18, weight: .heavy)
        wordText.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.height.equalTo(70)
        }
        
        let meaningText = UITextField()
        meaningText.borderStyle = .roundedRect
        meaningText.clearButtonMode = .always
        meaningText.placeholder = "뜻을 입력하세요"
        meaningText.font = .systemFont(ofSize: 18, weight: .heavy)
        meaningText.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.height.equalTo(70)
        }
        
        stackView.addArrangedSubview(wordText)
        stackView.addArrangedSubview(meaningText)
        
        return stackView
    }()
    
    private var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "Team332Color")
        button.layer.cornerRadius = 8
        button.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.height.equalTo(50)
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(vocaStack)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(tappedSubmitButton), for: .touchUpInside)
        
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(30)
            $0.centerX.equalTo(view)
        }
        
        vocaStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(50)
            $0.centerX.equalTo(view)
        }
        
        submitButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(vocaStack.snp.bottom).offset(30)
        }
    }
    
    @objc func tappedSubmitButton() {
        guard var totalVocabularyList = TotalVocabularyList.shared.list else {
            // If the list is nil, create a new array
            TotalVocabularyList.shared.list = [VocabularyList]()
            return
        }
        
        // Get the entered word and meaning from the text fields
        guard let wordText = (vocaStack.arrangedSubviews[0] as? UITextField)?.text,
              let meaningText = (vocaStack.arrangedSubviews[1] as? UITextField)?.text else {
            // Handle the case where the text fields are not found
            return
        }
        
        // Create a new Word instance
        let newWord = Word(word: wordText, meaning: meaningText, isCorrect: false)
        
        // Create a new VocabularyList instance
        let newVocabularyList = VocabularyList(name: "", word: [newWord], isCompleted: false)
        
        // Add the new VocabularyList to the totalVocabularyList
        totalVocabularyList.append(newVocabularyList)
        
        // Update the list property of TotalVocabularyList
        TotalVocabularyList.shared.list = totalVocabularyList
        
        // Optionally, you can print the updated list
        print(TotalVocabularyList.shared.list ?? [])
        
        // 추가 후 텍스트필드 비우고 커서 없애기
        (vocaStack.arrangedSubviews[0] as? UITextField)?.text = ""
        (vocaStack.arrangedSubviews[1] as? UITextField)?.text = ""
        (vocaStack.arrangedSubviews[0] as? UITextField)?.resignFirstResponder()
        (vocaStack.arrangedSubviews[1] as? UITextField)?.resignFirstResponder()
    }
}

extension AddVocaViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }
}

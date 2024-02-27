//
//  AddVocaViewController.swift
//  3X3X3
//
//  Created by 최유리 on 2/7/24.
//

import UIKit
import SnapKit
import CoreData

class AddVocaViewController: UIViewController {
    
    var vocaDataSource: [NSManagedObject] = []
    var indexPath: IndexPath?
    
    var vocaTitle: UILabel = {
        let label = UILabel()
        if let category = SharedData.shared.enteredCategory {
            label.text = "\(category)"
        }
        label.textColor =  UIColor(named: "Team332Color")
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
        button.backgroundColor =  UIColor(named: "Team332Color")
        button.layer.cornerRadius = 8
        button.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.height.equalTo(50)
        }
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocaDataSource = CoreDataManager.shared.readVoca()
        self.hideKeyboardWhenTappedAround()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(vocaTitle)
        view.addSubview(vocaStack)
        view.addSubview(submitButton)
        
        submitButton.addTarget(self, action: #selector(tappedSubmitButton), for: .touchUpInside)
        
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        vocaTitle.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).inset(30)
            $0.centerX.equalTo(view)
        }
        
        vocaStack.snp.makeConstraints {
            $0.top.equalTo(vocaTitle.snp.bottom).offset(50)
            $0.centerX.equalTo(view)
        }
        
        submitButton.snp.makeConstraints {
            $0.centerX.equalTo(view)
            $0.top.equalTo(vocaStack.snp.bottom).offset(30)
        }
    }
    
    @objc func tappedSubmitButton() {
        // 단어,뜻 저장
        guard let wordText = (vocaStack.arrangedSubviews[0] as? UITextField)?.text,
              let meaningText = (vocaStack.arrangedSubviews[1] as? UITextField)?.text
        else { return }
        
        CoreDataManager.shared.createVoca(word: wordText, meaning: meaningText)
        self.vocaDataSource = CoreDataManager.shared.readVoca()
        
        // 추가 후 텍스트필드 비우고 커서 없애기
        (vocaStack.arrangedSubviews[0] as? UITextField)?.text = ""
        (vocaStack.arrangedSubviews[1] as? UITextField)?.text = ""
        (vocaStack.arrangedSubviews[0] as? UITextField)?.resignFirstResponder()
        (vocaStack.arrangedSubviews[1] as? UITextField)?.resignFirstResponder()
    }
}


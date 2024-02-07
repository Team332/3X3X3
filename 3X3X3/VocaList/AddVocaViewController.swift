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
        label.text = "Business"
        label.textColor = UIColor(named: "Team332Color")
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
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
        
        let submitButton = UIButton()
        submitButton.setTitle("추가", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = UIColor(named: "Team332Color")
        submitButton.layer.cornerRadius = 8
        submitButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        submitButton.addTarget(submitButton.self, action: #selector(tappedSubmitButton), for: .touchUpInside)
        
        stackView.addArrangedSubview(wordText)
        stackView.addArrangedSubview(meaningText)
        stackView.addArrangedSubview(submitButton)
        
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(vocaStack)
        
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
    }
    
    @objc func tappedSubmitButton() {
        
    }
}

//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    
    let quizLabel: UILabel = {
        let label = UILabel()
        label.text = "QUIZ"
        label.font = .systemFont(ofSize: 14)
        label.layer.cornerRadius = 10
        label.textAlignment = .center
        label.backgroundColor = .systemPink
        return label
    }()

    let questionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .team332
        label.text = "문제"
        label.font = .systemFont(ofSize: 30)
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addViews()
        setConstraint()
    }
    
    private func addViews() {
        view.addSubview(questionLabel)
        view.addSubview(quizLabel)
    }
    
    private func setConstraint() {
        questionLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        quizLabel.snp.makeConstraints{ make in
            make.leading.equalTo(questionLabel.snp.leading)
            make.bottom.equalTo(questionLabel.snp.top).offset(5)
            make.width.equalTo(questionLabel).multipliedBy(0.2)
            make.height.equalTo(questionLabel).multipliedBy(0.2)
        }
    }
}

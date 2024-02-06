//
//  TestViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {

    let questionLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .team332
        view.frame = CGRect(x: 0.0, y: 0.0, width: 300, height: 300)
        view.text = "문제"
        view.font = .systemFont(ofSize: 30)
        view.layer.masksToBounds = true
        view.numberOfLines = 0
        view.layer.cornerRadius = 20
        view.textAlignment = .center
//        view.snp.makeConstraints{make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(50)
//        }
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addViews()
    }
    
    private func addViews() {
        view.addSubview(questionLabel)
    }
}

//
//  StudyViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

#Preview{
    StudyViewController()
}

class StudyViewController: UIViewController {
    
    var label2 = UILabel()
    var isLabel2Clicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백그라운드 색상을 하얀색으로 설정
        view.backgroundColor = .white
        
        // '단어장 이름' 라벨
        let titleLabel = UILabel()
        titleLabel.text = "단어장 이름"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        
        // 단어장 그림
        let noteImageView = UIImageView()
        noteImageView.image = UIImage(named: "yellowNote")
        
        // 단어 앞면 라벨
        let label1 = UILabel()
        label1.text = "영어단어"
        label1.textAlignment = .center
        label1.font = UIFont.systemFont(ofSize: 24)
        label1.numberOfLines = 4
        label1.lineBreakMode = .byTruncatingTail
        
        // 단어 뒷면 라벨
        label2.text = " "
        label2.textAlignment = .center
        label2.font = UIFont.systemFont(ofSize: 24)
        label2.numberOfLines = 4
        label2.lineBreakMode = .byTruncatingTail
        
        // gotIt 버튼
        let gotItButton = UIButton(type: .system)
        gotItButton.setTitle("알겠당", for: .normal)
        gotItButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        gotItButton.backgroundColor = UIColor(red: 170/255, green: 213/255, blue: 244/255, alpha: 1.0)
        gotItButton.layer.cornerRadius = 10
        gotItButton.layer.shadowColor = UIColor.black.cgColor
        gotItButton.layer.shadowOpacity = 0.5
        gotItButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // IDK 버튼
        let idkButton = UIButton(type: .system)
        idkButton.setTitle("모르겠당", for: .normal)
        idkButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        idkButton.backgroundColor = UIColor(red: 254/255, green: 172/255, blue: 172/255, alpha: 1.0)
        idkButton.layer.cornerRadius = 10
        idkButton.layer.shadowColor = UIColor.black.cgColor
        idkButton.layer.shadowOpacity = 0.5
        idkButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // 수평으로 배치할 스택뷰 생성
        let buttonStackView = UIStackView(arrangedSubviews: [gotItButton, idkButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 30
        buttonStackView.distribution = .fillEqually
        
        // 작은 삼삼이 그림
        let samsamImageView = UIImageView()
        samsamImageView.image = UIImage(named: "small33")
        
        // 뷰에 서브뷰로 추가
        view.addSubview(titleLabel)
        view.addSubview(noteImageView)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(buttonStackView)
        view.addSubview(samsamImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        noteImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(320)
        }
        label1.snp.makeConstraints { make in
            make.top.equalTo(noteImageView.snp.top).offset(25)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(noteImageView.snp.height).dividedBy(2) // 높이를 imageView의 절반으로 설정
        }
        
        label2.snp.makeConstraints { make in
            make.bottom.equalTo(noteImageView.snp.bottom).offset(0)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(noteImageView.snp.height).dividedBy(2) // 높이를 imageView의 절반으로 설정
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(noteImageView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        
        samsamImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
        
        // label2 클릭 이벤트 핸들러 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(label2Tapped))
        label2.isUserInteractionEnabled = true // 사용자 상호작용 허용
        label2.addGestureRecognizer(tapGesture)
    }
    
    // label2 클릭 이벤트 처리
    @objc func label2Tapped() {
        if !isLabel2Clicked {
            // 클릭된 상태로 변경하고 텍스트 업데이트
            isLabel2Clicked = true
            label2.text = "한글 뜻" // 여기에 실제 한글 뜻을 설정해주세요
            print("label2가 클릭되었습니다.")
        }
    }
}
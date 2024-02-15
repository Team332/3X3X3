//
//  StudyFinishedViewController.swift
//  3X3X3
//
//  Created by t2023-m0028 on 2/5/24.
//

import UIKit
import SnapKit


class FinishedViewController: UIViewController {
    
    let listName = SharedData.shared.enteredCategory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 백그라운드 색상을 하얀색으로 설정
        view.backgroundColor = .white
        
        // '단어장 이름' 라벨
        let titleLabel = UILabel()
        titleLabel.text = listName
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        
        // 큰 삼삼이 그림
        let bigSamsamImageView = UIImageView()
        bigSamsamImageView.image = UIImage(named: "big33")
        
        // 삼삼이 말풍선
        let samsamTalkinglabel = UILabel()
        samsamTalkinglabel.text = "공부하느라 고생했어!\n 이제 시험을 한번 볼까?"
        samsamTalkinglabel.backgroundColor = UIColor(red: 237/255, green: 226/255, blue: 255/255, alpha: 1.0)
        samsamTalkinglabel.textColor = .black
        samsamTalkinglabel.textAlignment = .center
        samsamTalkinglabel.font = UIFont.systemFont(ofSize: 20)
        samsamTalkinglabel.layer.cornerRadius = 10
        samsamTalkinglabel.clipsToBounds = true
        samsamTalkinglabel.numberOfLines = 0
        
        // 시험 준비 완료 버튼
        let readyForTestButton = UIButton(type: .system)
        readyForTestButton.setTitle("까짓거 만점 맞아줄게!\n 시험 도전!", for: .normal)
        readyForTestButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        readyForTestButton.titleLabel?.numberOfLines = 2
        readyForTestButton.titleLabel?.lineBreakMode = .byWordWrapping
        readyForTestButton.titleLabel?.textAlignment = .center
        readyForTestButton.backgroundColor = UIColor(red: 170/255, green: 213/255, blue: 244/255, alpha: 1.0)
        readyForTestButton.layer.cornerRadius = 10
        readyForTestButton.layer.shadowColor = UIColor.black.cgColor
        readyForTestButton.layer.shadowOpacity = 0.5
        readyForTestButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        readyForTestButton.addTarget(self, action: #selector(readyForTestButtonTapped), for: .touchUpInside)
        
        // 다시 공부 버튼
        let backToStudyButton = UIButton(type: .system)
        backToStudyButton.setTitle("아직 자신이 없는걸..\n 더 공부하고 올게..", for: .normal)
        backToStudyButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        backToStudyButton.titleLabel?.numberOfLines = 2
        backToStudyButton.titleLabel?.lineBreakMode = .byWordWrapping
        backToStudyButton.titleLabel?.textAlignment = .center
        backToStudyButton.backgroundColor = UIColor(red: 254/255, green: 172/255, blue: 172/255, alpha: 1.0)
        backToStudyButton.layer.cornerRadius = 10
        backToStudyButton.layer.shadowColor = UIColor.black.cgColor
        backToStudyButton.layer.shadowOpacity = 0.5
        backToStudyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        backToStudyButton.addTarget(self, action: #selector(backToStudyButtonTapped), for: .touchUpInside)
        
        // 수평으로 배치할 스택뷰 생성
        let buttonStackView = UIStackView(arrangedSubviews: [readyForTestButton, backToStudyButton])
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 30
        buttonStackView.distribution = .fillEqually
        
        // 작은 삼삼이 그림
        let samsamImageView = UIImageView()
        samsamImageView.image = UIImage(named: "small33")
        
        // 뷰에 서브뷰로 추가
        view.addSubview(titleLabel)
        view.addSubview(bigSamsamImageView)
        view.addSubview(samsamTalkinglabel)
        view.addSubview(buttonStackView)
        view.addSubview(samsamImageView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        bigSamsamImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(220)
        }
        samsamTalkinglabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(bigSamsamImageView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(250)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(samsamTalkinglabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(160)
        }
        
        samsamImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-60)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(100)
        }
    }
    
    // 시험 준비 완료 버튼이 클릭되었을 때 실행되는 함수
    @objc func readyForTestButtonTapped() {
        let testViewController = TestViewController()
        
        // navigationController가 있을 경우 push를 사용하여 뷰 컨트롤러 전환
        navigationController?.pushViewController(testViewController, animated: true)
        // 모달 전환 시 트랜지션 스타일을 .fullScreen으로 설정
        //testViewController.modalPresentationStyle = .fullScreen
        // 모달 전환 시 슬라이딩 애니메이션 비활성화
        //testViewController.modalTransitionStyle = .crossDissolve
        // navigationController가 없을 경우 present를 사용하여 모달로 뷰 컨트롤러 전환
        //        present(testViewController, animated: true, completion: nil)
    }
    
    // 더 공부하기 버튼이 클릭되었을 때 실행되는 함수
    @objc func backToStudyButtonTapped() {
        // 네비게이션 컨트롤러가 존재하는지 확인
        guard let navigationController = navigationController else {
            // 네비게이션 컨트롤러가 존재하지 않는다면, 모달로 VocaListViewController를 표시하고 현재 뷰 컨트롤러를 닫음
            let vocaListVC = VocaListViewController()
            present(vocaListVC, animated: true, completion: nil)
            return
        }
        
        // 네비게이션 스택에 루트 뷰 컨트롤러가 있는지 확인
        guard let rootViewController = navigationController.viewControllers.first else {
            // 루트 뷰 컨트롤러가 존재하지 않는다면, 아무 작업도 수행하지 않고 함수 종료
            return
        }
        
        // 루트 뷰 컨트롤러로 이동
        navigationController.popToViewController(rootViewController, animated: true)
    }
}

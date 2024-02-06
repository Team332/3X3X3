//
//  TestResultViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class TestResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var incorrectWords: [String] = ["Word1", "Word2", "Word3", "Word4", "Word5", "Word6"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        createCircle()
        setupUI()
        setupConstraints()
    }

    // MARK: - Circle
    func createCircle() {
        let correctRate: CGFloat = 0.7
        let circleRadius: CGFloat = 75
        let circleLineWidth: CGFloat = 15.0

        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(150)
        }

        // 원 경로
        let circularPath = UIBezierPath(
            arcCenter: containerView.center,
            radius: circleRadius,
            startAngle: -CGFloat.pi / 2,                                // 시작 각도(12시)
            endAngle: 2 * CGFloat.pi * correctRate - CGFloat.pi / 2,    // 종료 각도(정답률에 따라)
            clockwise: true                                             // 시계 방향으로 그릴지 여부
        )

        // 정답률 테두리
        let borderLine = CAShapeLayer()
        borderLine.path = circularPath.cgPath
        //borderLine.strokeColor = UIColor.blue.cgColor
        borderLine.strokeColor = UIColor(red: 0xDB/255.0, green: 0xC5/255.0, blue: 0xFF/255.0, alpha: 1.0).cgColor
        borderLine.lineWidth = circleLineWidth
        borderLine.fillColor = UIColor.clear.cgColor
        borderLine.lineCap = CAShapeLayerLineCap.round

        containerView.layer.addSublayer(borderLine)

        // 정답률 label
        let correctLabel = UILabel()
        correctLabel.text = "\(Int(correctRate * 100))%" // 정확도를 백분율로 변환
        correctLabel.font = UIFont.systemFont(ofSize: 30)
        correctLabel.textColor = UIColor.black
        containerView.addSubview(correctLabel)

        correctLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        // 테두리 animate
        let animation = CABasicAnimation(keyPath: "strokeEnd")  // 효과의 끝 지점을 애니메이션화하는 데 사용
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2.0    // 지속시간
        borderLine.add(animation, forKey: "progressAnimation")
    }

    // MARK: - View

    // 메세지
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "이렇게 쉬운 걸 다 풀 줄 알았는데,\n 실망이야~"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let roundedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xDB/255.0, green: 0xC5/255.0, blue: 0xFF/255.0, alpha: 1.0)
        view.layer.cornerRadius = 20
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    // MARK: - setupUI

    private func setupUI() {
        view.addSubview(messageLabel)
        view.addSubview(roundedView)
        roundedView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - setupConstraints

    private func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(270)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        messageLabel.numberOfLines = 0

        roundedView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(200)
        }

        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }


    // MARK: CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incorrectWords.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 15

        // 틀린 단어 표시
        let wordLabel = UILabel()
        wordLabel.text = incorrectWords[indexPath.item]
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 16)
        cell.contentView.addSubview(wordLabel)

        wordLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return cell
    }

    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 60)
    }
}


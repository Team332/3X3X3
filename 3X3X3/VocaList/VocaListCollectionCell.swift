//
//  VocaListCollectionCell.swift
//  3X3X3
//
//  Created by 최유리 on 2/7/24.
//

import UIKit
import SnapKit

protocol VocaListCollectionCellDelegate: AnyObject {
    func didTapStudyButton()
    func didTapAddVocaButton()
}

class VocaListCollectionCell: UICollectionViewCell {
    static var identifier = "VocaCell"
    
    weak var delegate: VocaListCollectionCellDelegate?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        
        return label
    }()
    
    private var studyButton: UIButton = {
        let button = UIButton()
        button.setTitle("공부하기", for: .normal)
        button.setTitleColor(UIColor(named: "Team332Color"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        return button
    }()
    
    private var addVocaButton: UIButton = {
        let button = UIButton()
        button.setTitle("단어 추가", for: .normal)
        button.setTitleColor(UIColor(named: "Team332Color"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(studyButton)
        contentView.addSubview(addVocaButton)
        
        studyButton.addTarget(self, action: #selector(tappedStudyButton), for: .touchUpInside)
        addVocaButton.addTarget(self, action: #selector(tappedAddVocaButton), for: .touchUpInside)
        
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.left.equalTo(contentView.snp.left).inset(10)
        }
        
        studyButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.right.equalTo(contentView.snp.right).offset(-10)
        }

        addVocaButton.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
            $0.right.equalTo(contentView.snp.right).offset(-10)
        }
    }
    
    @objc func tappedStudyButton() {
        delegate?.didTapStudyButton()
    }
    
    @objc func tappedAddVocaButton() {
        delegate?.didTapAddVocaButton()
    }
}

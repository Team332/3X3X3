//
//  ProfileViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        view.addSubview(labelStack)
        view.addSubview(scoreStack)
        view.addSubview(expBar)
        view.addSubview(expFullBar)

        setUi()
    }
    
    let totalWordsLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "9999"
        totalLabel.font = UIFont.systemFont(ofSize: 17)
        return totalLabel
    }()
    
    let averageScoreLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "9"
        totalLabel.font = UIFont.systemFont(ofSize: 17)
        return totalLabel
    }()
    
    let rankLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "99"
        totalLabel.font = UIFont.systemFont(ofSize: 17)
        return totalLabel
    }()
    
    let expLabelText: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "88"
        totalLabel.font = UIFont.systemFont(ofSize: 17)
        return totalLabel
    }()
    
    let scoreStack: UIStackView = {
        let scoreStack = UIStackView()
        scoreStack.axis = .vertical
        scoreStack.spacing = 30
        return scoreStack
    }()
    
    
    let totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.text = "총단어수 :"
        totalLabel.font = UIFont.systemFont(ofSize: 17)
        return totalLabel
    }()
    
    let averageLabel: UILabel = {
        let averageLabel = UILabel()
        averageLabel.text = "평균점수 :"
        averageLabel.font = UIFont.systemFont(ofSize: 17)
        return averageLabel
    }()
    
    let tierLabel: UILabel = {
        let tierLabel = UILabel()
        tierLabel.text = "등       급 :"
        tierLabel.font = UIFont.systemFont(ofSize: 17)
        return tierLabel
    }()
    
    let expLabel: UILabel = {
        let expLabel = UILabel()
        expLabel.text = "경  험  치 :"
        expLabel.font = UIFont.systemFont(ofSize: 17)
        return expLabel
    }()
    
    let expBar: UIProgressView = {
       let expBar = UIProgressView()
        expBar.trackTintColor = .clear
        expBar.progressTintColor = UIColor(named: "Color")
        expBar.setProgress(0.88, animated: true)
        return expBar
    }()
    
    let expFullBar: UIProgressView = {
       let expBar = UIProgressView()
        expBar.trackTintColor = .black
//        expBar.setProgress(0.88, animated: true)
        return expBar
    }()
    
    let labelStack: UIStackView = {
        let labelStack = UIStackView()
        labelStack.axis = .vertical
        labelStack.spacing = 30
        return labelStack
    }()
    
    func setUi(){
        labelStack.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.left.equalTo(30)
        }
        scoreStack.snp.makeConstraints { make in
            make.top.equalTo(150)
            make.left.equalTo(120)
        }
        labelStack.addArrangedSubview(totalLabel)
        labelStack.addArrangedSubview(averageLabel)
        labelStack.addArrangedSubview(tierLabel)
        labelStack.addArrangedSubview(expLabel)
        
        scoreStack.addArrangedSubview(totalWordsLabel)
        scoreStack.addArrangedSubview(averageScoreLabel)
        scoreStack.addArrangedSubview(rankLabel)
        scoreStack.addArrangedSubview(expLabelText)
        
        expBar.snp.makeConstraints { make in
            make.top.equalTo(labelStack.snp.bottom).offset(40)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
        }
        
        expFullBar.snp.makeConstraints { make in
            make.top.equalTo(expBar.snp.bottom).offset(5)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

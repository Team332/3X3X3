//
//  VocaListViewController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit
import SnapKit

class VocaListViewController: UIViewController, VocaListCollectionCellDelegate {
    
    var vocaCategories: [VocabularyList] = TotalVocabularyList.shared.list ?? []
    
    private var categoryStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        
        let categoryTitle = UILabel()
        categoryTitle.text = "무엇을 공부해볼까요?"
        categoryTitle.textColor = .darkGray
        categoryTitle.font = .systemFont(ofSize: 22, weight: .bold)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StudyIcon")
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(25)
        }
        
        stackView.addArrangedSubview(categoryTitle)
        stackView.addArrangedSubview(imageView)
        
        return stackView
    }()
    
    
    private var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("+ 단어장 추가하기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        
        return button
    }()
    
    private var vocaCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vocaCollectionView.dataSource = self
        vocaCollectionView.delegate = self
        vocaCollectionView.register(VocaListCollectionCell.self, forCellWithReuseIdentifier: VocaListCollectionCell.identifier)
        addCategoryButton.addTarget(self, action: #selector(tappedAddCategoryButton), for: .touchUpInside)
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(categoryStack)
        view.addSubview(addCategoryButton)
        view.addSubview(vocaCollectionView)
        
        setAutoLayout()
    }
    
    private func setAutoLayout() {
        categoryStack.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        addCategoryButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.top.equalTo(categoryStack.snp.bottom).offset(20)
        }
        
        vocaCollectionView.snp.makeConstraints {
            $0.top.equalTo(addCategoryButton.snp.bottom).offset(14)
            $0.left.equalTo(view.snp.left).inset(17)
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(view.snp.bottom).inset(70)
        }
    }
    
    @objc func tappedAddCategoryButton() {
        let alert = UIAlertController(title: "단어장 추가", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "단어의 카테고리를 입력하세요."
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "추가", style: .default, handler: { _ in
            if let category = alert.textFields?[0].text, !category.isEmpty {
                let addCategory = VocabularyList(name: category, word: [], isCompleted: false)
                self.vocaCategories.append(addCategory)
                self.vocaCollectionView.reloadData()
                
                TotalVocabularyList.shared.list = self.vocaCategories
            }
            
            print(TotalVocabularyList.shared.list ?? [])
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension VocaListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vocaCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocaListCollectionCell.identifier, for: indexPath) as? VocaListCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        cell.backgroundColor = UIColor(named: "Team332Color")
        cell.titleLabel.text = vocaCategories[indexPath.item].name
        cell.layer.cornerRadius = 6
        
        return cell
    }
    
    // MARK: - 왜 안 돼
    func didTapStudyButton() {
//        let goStudyView = StudyViewController()
//        let navigationController = UINavigationController(rootViewController: self)
//        navigationController.pushViewController(goStudyView, animated: true)
//        present(navigationController, animated: true, completion: nil)
        let goStudyView = StudyViewController()
        self.navigationController?.pushViewController(goStudyView, animated: true)
    }
    
    func didTapAddVocaButton() {
        let goAddVocaView = AddVocaViewController()
        goAddVocaView.modalPresentationStyle = .automatic
        present(goAddVocaView, animated: true)
    }
    
}

extension VocaListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = (collectionView.frame.height) / 6
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

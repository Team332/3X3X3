//
//  TabBarController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var vocaVC: VocaListViewController {
        let vocaTab = VocaListViewController()
        let vocaTabItem = UITabBarItem(title: "Vocabulary", image: UIImage(named: "BookIcon")?.resized(to: CGSize(width: 20.0, height: 20.0)), tag: 0)
        vocaTab.tabBarItem = vocaTabItem
        return vocaTab
    }
    
    var studyVC: StudyViewController {
        let studyTab = StudyViewController()
        let studyTabItem = UITabBarItem(title: "Study", image: UIImage(named: "StudyIcon")?.resized(to: CGSize(width: 20.0, height: 20.0)), tag: 1)
        studyTab.tabBarItem = studyTabItem
        return studyTab
    }
    
    var testVC: TestViewController {
        let testTab = TestViewController()
        let testTabItem = UITabBarItem(title: "Test", image: UIImage(named: "TestIcon")?.resized(to: CGSize(width: 20.0, height: 20.0)), tag: 2)
        testTab.tabBarItem = testTabItem
        return testTab
    }
    
    var testResultVC: TestResultViewController {
        let testResultTab = TestResultViewController()
        let testResultTabItem = UITabBarItem(title: "TestResult", image: UIImage(named: "TestResultIcon")?.resized(to: CGSize(width: 20.0, height: 20.0)), tag: 3)
        testResultTab.tabBarItem = testResultTabItem
        return testResultTab
    }
    
    var profileVC: ProfileViewController {
        let profileTab =  ProfileViewController()
        let profileTabItem = UITabBarItem(title: "Profile", image: UIImage(named: "ProfileIcon")?.resized(to: CGSize(width: 20.0, height: 20.0)), tag: 4)
        profileTab.tabBarItem = profileTabItem
        return profileTab
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.backgroundColor = .team332
        self.viewControllers = [vocaVC, studyVC, testVC, testResultVC, profileVC]
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

//MARK: Resize Image Object
extension UIImage {
    public func resized(to target: CGSize) -> UIImage {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let new = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}


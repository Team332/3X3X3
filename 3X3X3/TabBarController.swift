//
//  TabBarController.swift
//  3X3X3
//
//  Created by 영현 on 2/5/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UINavigationControllerDelegate {

    let vocaListViewController = VocaListViewController()

    var mainVC: UINavigationController {
        let naviTab = UINavigationController(rootViewController: vocaListViewController)
        let naviTabItem = UITabBarItem(title: "단어장", image: UIImage(named: "StudyIcon")?.resized(to: CGSize(width: 28, height: 28)), tag: 0)
        naviTab.tabBarItem = naviTabItem
        return naviTab
    }

    var profileVC: ProfileViewController {
        let profileTab =  ProfileViewController()
        let profileTabItem = UITabBarItem(title: "프로필", image: UIImage(named: "ProfileIcon")?.resized(to: CGSize(width: 28, height: 28)), tag: 1)
        profileTab.tabBarItem = profileTabItem
        return profileTab
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        vocaListViewController.navigationController?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewControllers = [mainVC, profileVC]

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white

            self.tabBar.standardAppearance = appearance
            //self.tabBar.scrollEdgeAppearance = .none
            self.tabBar.scrollEdgeAppearance = appearance
        }
        self.tabBar.tintColor = .systemPurple.withAlphaComponent(0.8)
    }

    // MARK: - UINavigationControllerDelegate

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 해당 탭을 선택할 때마다 애니메이션 적용
        if viewController is ProfileViewController {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType(rawValue: "pageCurl")
            transition.subtype = CATransitionSubtype.fromBottom
            self.view.layer.add(transition, forKey: kCATransition)
        }
        return true
    }
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


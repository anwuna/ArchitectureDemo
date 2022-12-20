//
//  TabbarController.swift
//  ArchitectureDemo
//
//  Created by Chibundu Anwuna on 2022-12-09.
//

import UIKit
import Characters
import Favorites
import Events

public final class TabBarController: UITabBarController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tabBar.tintColor = .red
        viewControllers = [
            createNavigationController(for: CharacterListViewController(), title: "Characters", image: UIImage(systemName: "house")),
            createNavigationController(for: EventsViewController(), title: "Events", image: UIImage(systemName: "menucard.fill")),
            createNavigationController(for: FavoritesViewController(), title: "Favorites", image: UIImage(systemName: "star"))
        ]
    }

    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navigationController
    }
}

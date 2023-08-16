//
//  MainCoordinator.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 14.08.2023.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func showViewController<T: UIViewController & Storyboarded & CoordinatedFriend>(_ viewControllerType: T.Type, for friend: Friend) {
        var vc = viewControllerType.instantiate()
        vc.coordinator = self
        vc.friend = friend
        navigationController.pushViewController(vc, animated: true)
    }

//    func showConfigure(for friend: Friend) {
//        let vc = FriendViewController.instantiate()
//        vc.coordinator = self
//        vc.friend = friend
//        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func showTimeZoneViewController(for friend: Friend) {
//        let vc = TimeZoneViewController.instantiate()
//        vc.coordinator = self
//        vc.friend = friend
//        navigationController.pushViewController(vc, animated: true)
//    }

    func update(friend: Friend) {
        guard let vc = navigationController.viewControllers.first as? ViewController else {
            return
        }

        vc.update(friend: friend)
    }

    func loadData<T: Decodable>(forKey key: String) -> T? {
        let defaults = UserDefaults.standard
        guard let saveData = defaults.data(forKey: key) else { return nil }

        let decoder = JSONDecoder()
        guard let savedData = try? decoder.decode(T.self, from: saveData) else { return nil }

        return savedData
    }

    func saveData<T: Encodable>(_ data: T, forKey key: String, errorMessage: String) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        guard let saveData = try? encoder.encode(data) else {
            fatalError(errorMessage)
        }

        defaults.set(saveData, forKey: key)
    }


}

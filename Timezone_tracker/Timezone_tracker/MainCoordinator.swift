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

    }
}

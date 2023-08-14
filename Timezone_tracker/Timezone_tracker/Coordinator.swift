//
//  Coordinator.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 14.08.2023.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

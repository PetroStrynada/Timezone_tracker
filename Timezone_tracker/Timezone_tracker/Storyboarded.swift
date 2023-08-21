//
//  Storyboarded.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 14.08.2023.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static var storyboardName: String {
        .init(describing: self)
    }

    static func instantiate() -> Self {
        //we named storyboard classes the same identifier their class. We can use that to find view controllers in the storyboards
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self))
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate storyboard with name: \(storyboardName)")
        }
        return viewController
    }
}

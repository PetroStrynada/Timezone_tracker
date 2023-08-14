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
    static func instantiate() -> Self {
        //we named storyboard classes the same identifier their class. We can use that to find view controllers n the storyboards
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

//
//  CoordinatedFriend.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 16.08.2023.
//

import Foundation

protocol CoordinatedFriend {
    var coordinator: MainCoordinator? { get set }
    var friend: Friend! { get set }
}

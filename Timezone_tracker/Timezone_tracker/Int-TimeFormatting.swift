//
//  Int-TimeFormatting.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 09.08.2023.
//

import Foundation

extension Int {
    func timeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(self)) ?? "0"

        if formattedString == "0" {
            return "GMT"
        } else {
            if formattedString.hasPrefix("-") {
                return "GMT\(formattedString)"
            } else {
                return "GMT+\(formattedString)"
            }
        }


    }
}

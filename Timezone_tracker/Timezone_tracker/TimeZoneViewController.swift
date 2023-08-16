//
//  TimeZoneViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 14.08.2023.
//

import UIKit

class TimeZoneViewController: UITableViewController, Storyboarded, CoordinatedFriend {
    weak var coordinator: MainCoordinator?
    var friend: Friend!

    var timeZones = [TimeZone]()
    var selectedTimeZone = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let identifiers = TimeZone.knownTimeZoneIdentifiers

        for identifier in identifiers {
            if let timeZone = TimeZone(identifier: identifier) {
                timeZones.append(timeZone)
            }
        }

        let now = Date()

        timeZones.sort {
            let ourDifference = $0.secondsFromGMT(for: now)
            let otherDifference = $1.secondsFromGMT(for: now)

            if ourDifference == otherDifference {
                return $0.identifier > $1.identifier
            } else {
                return ourDifference < otherDifference
            }
        }

        selectedTimeZone = timeZones.firstIndex(of: friend.timeZone) ?? 0
    }

    //Потрібно оновити таймзону друга після того як вʼю зникне
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.update(friend: friend)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select time zone"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZone2", for: indexPath)
        let timeZone = timeZones[indexPath.row]
        var content = cell.defaultContentConfiguration()

        content.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")

        let timeDifference = timeZone.secondsFromGMT(for: Date())
        content.secondaryText = timeDifference.timeString()

        cell.contentConfiguration = content

        if indexPath.row == selectedTimeZone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTimeZoneAlert(at: indexPath)
    }

    func changeTimeZoneAlert(at indexPath: IndexPath) {
        let timeZone = timeZones[indexPath.row]
        let regionZone = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
        let timeDifference = timeZone.secondsFromGMT(for: Date())

        let ac = UIAlertController(title: "Change the time zone?", message: "\(regionZone)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.selectRow(at: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    func selectRow(at indexPath: IndexPath) {

        for cell in tableView.visibleCells {
            //unchecking cells
            cell.accessoryType = .none
        }

        selectedTimeZone = indexPath.row
        friend.timeZone = timeZones[indexPath.row]

        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark

        //for gray flash. storyboard -> selection -> default
        //tableView.deselectRow(at: indexPath, animated: true)

        tableView.reloadData()
    }
}

//
//  FriendViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class FriendViewController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var friend: Friend!

    var timeZones = [TimeZone]()
    var selectedTimeZone = 0

    var nameEditionCell: TextTableViewCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextTableViewCell
    }

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.update(friend: friend)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        friend.name = sender.text ?? ""
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name your friend"
        } else if section == 1 {
            return "Current time zone"
        } else {
            return "Select their time zone"
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return timeZones.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as? TextTableViewCell else {
                fatalError("Couldn't get a text table view cell.")
            }

            cell.textField.text = friend.name
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTimeZone", for: indexPath)
            let currentTimeZone = friend.timeZone
            var content = cell.defaultContentConfiguration()

            content.text = currentTimeZone.identifier.replacingOccurrences(of: "_", with: " ")

            let timeDifference = currentTimeZone.secondsFromGMT(for: Date())
            content.secondaryText = timeDifference.timeString()

            cell.contentConfiguration = content

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZone", for: indexPath)
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
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            startEditingName()
        } else if indexPath.section == 1 {
            return
        } else {
            changeTimeZoneAlert(at: indexPath)
        }
    }

    func startEditingName() {
        nameEditionCell?.textField.becomeFirstResponder()
    }

    func changeTimeZoneAlert(at indexPath: IndexPath) {
        let timeZone = timeZones[indexPath.row]
        let zoneRegion = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
        let timeDifference = timeZone.secondsFromGMT(for: Date())

        let ac = UIAlertController(title: "Change the time zone?", message: "\(zoneRegion)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.selectRow(at: indexPath)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }

    func selectRow(at indexPath: IndexPath) {
        nameEditionCell?.textField.resignFirstResponder()

        for cell in tableView.visibleCells {
            //unchecking cells
            cell.accessoryType = .none
        }

        selectedTimeZone = indexPath.row
        friend.timeZone = timeZones[indexPath.row]

        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark

        //for gray flash
        //tableView.deselectRow(at: indexPath, animated: true)

        tableView.reloadData()
    }


}

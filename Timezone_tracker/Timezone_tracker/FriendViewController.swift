//
//  FriendViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class FriendViewController: UITableViewController {
    weak var delegate: ViewController?
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

    @IBAction func nameChanged(_ sender: UITextField) {
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return timeZones.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name your friend"
        } else {
            return "Select their time zone"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as? TextTableViewCell else {
                fatalError("Couldn't get a text table view cell.")
            }

            cell.textField.text = friend.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZone", for: indexPath)
            let timeZone = timeZones[indexPath.row]
            var content = cell.defaultContentConfiguration()

            content.text = timeZone.identifier

            let timeDifference = timeZone.secondsFromGMT(for: Date())
            //content.secondaryText = String(timeDifference)
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
        } else {
            selectRow(at: indexPath)
        }
    }

    func startEditingName() {
        nameEditionCell?.textField.becomeFirstResponder()
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

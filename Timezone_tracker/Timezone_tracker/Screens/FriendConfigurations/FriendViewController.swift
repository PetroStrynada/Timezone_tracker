//
//  FriendViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class FriendViewController: UITableViewController, Storyboarded, CoordinatedFriend {
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
        coordinator?.updateViewController(friend: friend)
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        friend.name = sender.text ?? ""
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name"
        } else {
            return "Current time zone"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTimeZone", for: indexPath)
            let currentTimeZone = friend.timeZone
            var content = cell.defaultContentConfiguration()

            content.text = currentTimeZone.identifier.replacingOccurrences(of: "_", with: " ")

            let timeDifference = currentTimeZone.secondsFromGMT(for: Date())
            content.secondaryText = timeDifference.timeString()

            cell.contentConfiguration = content

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            startEditingName()
        } else {
            coordinator?.showViewController(TimeZoneViewController.self, for: friend)
        }
    }

    func startEditingName() {
        nameEditionCell?.textField.becomeFirstResponder()
    }

    func upDateFriendViewController(updateFriend: Friend) {

        friend.timeZone = updateFriend.timeZone
        tableView.reloadData()
        //coordinator?.saveData(friends, forKey: "Friends", errorMessage: "Unable to encode friends data.")
    }

    func selectRow(at indexPath: IndexPath) {

        nameEditionCell?.textField.resignFirstResponder()
        tableView.reloadData()
    }
}

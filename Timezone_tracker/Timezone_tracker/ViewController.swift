//
//  ViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class ViewController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var friends = [Friend]()
    var selectedFriend: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the cell class or nib here
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        if let savedFriends: [Friend] = coordinator?.loadData(forKey: "Friends") {
            friends = savedFriends
        }

        title = "Friend Zone"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]

        // Configure the cell style to "Right Detail"
        cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")

        // Chevron at right side
        cell.accessoryType = .disclosureIndicator

        // Step 1: Create a custom content configuration
        var content = cell.defaultContentConfiguration()

        // Step 2.1: Set the primary text in the content configuration
        content.text = friend.name

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short

        // Step 2.2: Set the secondary text in the content configuration
        //content.secondaryText = friend.timeZone.identifier
        content.secondaryText = dateFormatter.string(from: Date())

        // Step 3: Apply the custom configuration to the cell
        cell.contentConfiguration = content

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteFriend(at: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func deleteFriend(at indexPath: IndexPath) {
        friends.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        coordinator?.saveData(friends, forKey: "Friends", errorMessage: "Unable to encode friends data.")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = indexPath.row
        coordinator?.showViewController(FriendViewController.self, for: friends[indexPath.row])
    }

    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        coordinator?.saveData(friends, forKey: "Friends", errorMessage: "Unable to encode friends data.")

        selectedFriend = friends.count - 1
        coordinator?.showViewController(FriendViewController.self, for: friend)
    }

    func updateViewController(friend: Friend) {
        guard let selectedFriend = selectedFriend else { return }

        friends[selectedFriend] = friend
        tableView.reloadData()
        coordinator?.saveData(friends, forKey: "Friends", errorMessage: "Unable to encode friends data.")
    }


}


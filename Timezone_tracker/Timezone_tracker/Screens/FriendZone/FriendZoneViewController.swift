//
//  ViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class FriendZoneViewController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var friends = [Friend]()
    var selectedFriend: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        loadFriends()
        setupTableView()
    }

    private func setupNavigationBar() {
        title = "Friend Zone"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    private func loadFriends() {
        if let savedFriends: [Friend] = coordinator?.loadData(forKey: "Friends") {
            friends = savedFriends
        }
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendZone")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FriendZone", for: indexPath)
        let friend = friends[indexPath.row]

        cell = UITableViewCell(style: .value1, reuseIdentifier: "FriendZone")
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()

        content.text = friend.name

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short

        content.secondaryText = dateFormatter.string(from: Date())

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


}


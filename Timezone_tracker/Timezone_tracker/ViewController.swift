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

        loadData()

        title = "Friend Zone"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]

        // Step 1: Create a custom content configuration
        var content = cell.defaultContentConfiguration()

        // Step 2: Set the primary text in the content configuration
        content.text = friend.name

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short

        // Step 2: Set the secondary text in the content configuration
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
        saveData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = indexPath.row
        coordinator?.configure(friend: friends[indexPath.row])
    }

    func loadData() {
        let defaults = UserDefaults.standard
        guard let saveData = defaults.data(forKey: "Friends") else { return }

        let decoder = JSONDecoder()
        guard let saveFriends = try? decoder.decode([Friend].self, from: saveData) else { return }

        friends = saveFriends
    }

    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        guard let saveData = try? encoder.encode(friends) else {
            fatalError("Unable to encode friends data.")
        }

        defaults.set(saveData, forKey: "Friends")

    }

    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()

        selectedFriend = friends.count - 1
        coordinator?.configure(friend: friend)
    }

    func updateFriend(friend: Friend) {
        guard let selectedFriend = selectedFriend else { return }

        friends[selectedFriend] = friend
        tableView.reloadData()
        saveData()
    }


}


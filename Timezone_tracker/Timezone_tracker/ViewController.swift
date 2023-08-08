//
//  ViewController.swift
//  Timezone_tracker
//
//  Created by Petro Strynada on 08.08.2023.
//

import UIKit

class ViewController: UITableViewController {

    var friends = [Friend]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        title = "Friend zone"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]

//        cell.textLabel?.text = friend.name
//        cell.detailTextLabel?.text = friend.timeZone.identifier

        // Step 1: Create a custom content configuration
        var content = cell.defaultContentConfiguration()

        // Step 2: Set the primary and secondary text in the content configuration
        content.text = friend.name
        content.secondaryText = friend.timeZone.identifier

        // Step 3: Apply the custom configuration to the cell
        cell.contentConfiguration = content

        return cell
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
    }

}


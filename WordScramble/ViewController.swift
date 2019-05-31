//
//  ViewController.swift
//  WordScramble
//
//  Created by Juan Francisco Dorado Torres on 5/31/19.
//  Copyright © 2019 Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

  // MARK: - Public Properties

  var allWords = [String]()
  var usedWords = [String]()

  // MARK: - View cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Look for the file
    if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
      // Read the content of file
      if let startWords = try? String(contentsOfFile: startWordsPath) {
        allWords = startWords.components(separatedBy: "\n")
      }
    } else {
      allWords = ["silkworm"]
    }

    startGame()
  }

  // MARK: - Public Methods

  func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }
}

// MARK: - Table View Delegates

extension ViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
}


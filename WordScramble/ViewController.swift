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

    // NavigationBar
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

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

  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()

    let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action) in
      let answer = ac.textFields![0]
      self.submit(answer: answer.text!)
    }

    ac.addAction(submitAction)
    present(ac, animated: true)
  }

  func submit(answer: String) {
    let lowerAnswer = answer.lowercased()

    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          usedWords.insert(answer, at: 0)

          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
        }
      }
    }
  }

  func isPossible(word: String) -> Bool {
    return true
  }

  func isOriginal(word: String) -> Bool {
    return true
  }

  func isReal(word: String) -> Bool {
    return true
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


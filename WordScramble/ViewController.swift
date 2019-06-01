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

    let errorTitle: String
    let errorMessage: String

    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          usedWords.insert(answer, at: 0)

          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          return
        } else {
          errorTitle = "Word not recognised"
          errorMessage = "You can't just make them up, you know!"
        }
      } else {
        errorTitle = "Word used already"
        errorMessage = "Be more original!"
      }
    } else {
      errorTitle = "Word not possible"
      errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
    }

    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }

  func isPossible(word: String) -> Bool {
    var tempWord = title!.lowercased()

    for letter in word {
      // Get the position where the letter was found parsing to 'String' instead of 'Character'
      if let pos = tempWord.range(of: String(letter)) {
        tempWord.remove(at: pos.lowerBound) // Removes the letter from the tempWord : 'lowerBound' gives the index
      } else {
        return false
      }
    }

    return true
  }

  func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
  }

  func isReal(word: String) -> Bool {
    // Create the chcker for texts, 'UITextChecker' is designed to spot spelling errors
    let checker = UITextChecker()
    // Create the range of the string we are going to check
    let range = NSMakeRange(0, word.utf16.count)
    // Get the 'NSRange'type for our word in 'English' language
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    // Return our compare
    return misspelledRange.location == NSNotFound
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


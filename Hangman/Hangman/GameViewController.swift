//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var startOver: UIButton!
    var numberOfIncorrectEntries: Int = 0
    var numberOfCorrectEntries: Int = 0
    var hangmanWordUserSees: [Character]!
    var wrongGuesses: [Character] = []
    var alreadySeenIndicesForRepeatedLetters: [Int] = []
    var gameWasWon = false
    var gameIsOver = false

    var phrase: String!
    
    @IBOutlet weak var hangmanWord: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var wrongGuessesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameWasWon = false
        gameIsOver = false
        startOver.enabled = false
        //addTargetsForAllButtons()
        numberOfIncorrectEntries = 0
        numberOfCorrectEntries = 0
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        
        convertAllSpacesInPhraseToNewLines()
        hangmanWordUserSees = [Character](count: phrase.characters.count + 2*(phrase.characters.count - 1), repeatedValue: "-")
        addSpacesInBetweenUnderscoresInHangmanWordUserSees()
        
        hangmanWord.text = toString(hangmanWordUserSees)
        hangmanWord.lineBreakMode = .ByCharWrapping;
        hangmanWord.numberOfLines = 0
        
        wrongGuesses = []
        alreadySeenIndicesForRepeatedLetters = []
        wrongGuessesLabel.lineBreakMode = .ByCharWrapping
        wrongGuessesLabel.numberOfLines = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertAllSpacesInPhraseToNewLines() {
        phrase = phrase.stringByReplacingOccurrencesOfString(" ", withString: "\n")
    }
    
    func numberOfSpacesInPhrase() ->Int {
        var count = 0
        for char in phrase.characters {
            if (char == "\n") {
                count += 1
            }
        }
        return count
    }
    
    func toString(charArray: [Character]) ->String {
        var string = ""
        for char in charArray {
            string.append(char)
        }
        return string
    }
    
    func addSpacesInBetweenUnderscoresInHangmanWordUserSees() {
        var index = 1
        while (index < hangmanWordUserSees.count) {
            if (phrase[phrase.startIndex.advancedBy((index - 1)/3)] == "\n") {
                hangmanWordUserSees[index - 1] = " "
            }
            hangmanWordUserSees[index] = " "
            hangmanWordUserSees[index + 1] = " "
            index += 3
        }
    }
    
    func checkIfCharIsInPhraseReturnIndexIfExists(char: String) ->Int {
        for (var i = 0; i < phrase.characters.count; i++) {
            if (char.characters.first == phrase[phrase.startIndex.advancedBy(i)] && !alreadySeenIndicesForRepeatedLetters.contains(i)){
                alreadySeenIndicesForRepeatedLetters.append(i)
                return i
            }
        }
        return -1
    }
    
    func incorrectEntryAddAnotherBodyPart(labelstr: String) {
        numberOfIncorrectEntries += 1
        if (numberOfIncorrectEntries >= 7) {
            gameOver()
        } else {
            hangmanImage.image = UIImage(named: "hangman\(numberOfIncorrectEntries+1).gif")
            wrongGuesses.append(labelstr.characters.first!)
            wrongGuesses.append(" ")
            wrongGuessesLabel.text = toString(wrongGuesses)
            if (numberOfIncorrectEntries == 6) {
                gameOver()
            }
        }
    }

    func correctEntrySoMakeTheLetterAppear(labelstr: String, index: Int) {
        let phraseCount = phrase.characters.count - numberOfSpacesInPhrase()
        numberOfCorrectEntries += 1
        if (numberOfCorrectEntries == phraseCount) {
            gameWon()
        }
        hangmanWordUserSees[index*3] = phrase[phrase.startIndex.advancedBy(index)]
        hangmanWord.text = toString(hangmanWordUserSees)
        
    }
    
    @IBAction func checkLetter(button: UIButton) {
        let letter =  button.titleLabel?.text
        let index = checkIfCharIsInPhraseReturnIndexIfExists(letter!)
        if (!gameWasWon && !gameIsOver) {
            if (index == -1) {
                if (!wrongGuesses.contains((letter?.characters.first)!)) {
                    incorrectEntryAddAnotherBodyPart(letter!)
                }
            } else {
                correctEntrySoMakeTheLetterAppear(letter!, index: index)
            }
        } else if (gameWasWon) {
            startOverButtonWinner()
        } else {
            startOverButtonLoser()
        }
    }
    
    func gameWon() {
        gameWasWon = true
        startOverButtonWinner()
    }
    
    func gameOver() {
        gameIsOver = true
        startOverButtonLoser()
    }
    
    func startOverButtonWinner() {
        let alert = UIAlertController(title: "YOU WON!", message: "Click to Start Over!", preferredStyle: .Alert)
        let StartOverAction = UIAlertAction(title: "StartOver", style: UIAlertActionStyle.Default, handler: {
            (_)in
            self.performSegueWithIdentifier("unwindToStart", sender: self)
        })
        
        alert.addAction(StartOverAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func startOverButtonLoser() {
        let alert = UIAlertController(title: "Game Over!", message: "Click to Start Over!", preferredStyle: .Alert)
        let StartOverAction = UIAlertAction(title: "StartOver", style: UIAlertActionStyle.Default, handler: {
            (_)in
            
            self.performSegueWithIdentifier("unwindToStart", sender: self)
        })
        
        alert.addAction(StartOverAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

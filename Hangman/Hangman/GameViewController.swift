//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    var numberOfIncorrectEntries = 0
    var hangmanWordUserSees: [Character]!
    var wrongGuesses: [Character] = []
    
    var numberOfCorrectEntries = 0
    var phrase: String!
    
    @IBOutlet weak var hangmanWord: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var wrongGuessesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        convertAllSpacesInPhraseToNewLines()
        hangmanWordUserSees = [Character](count: phrase.characters.count + 2*(phrase.characters.count - 1), repeatedValue: "-")
        addSpacesInBetweenUnderscoresInHangmanWordUserSees()
        
        hangmanWord.text = toString(hangmanWordUserSees)
        hangmanWord.lineBreakMode = .ByCharWrapping;
        hangmanWord.numberOfLines = 0
        
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
            hangmanWordUserSees[index] = " "
            hangmanWordUserSees[index + 1] = " "
            index += 3
        }
    }
    
    @IBAction func incorrectEntryAddAnotherBodyPart() {
        numberOfIncorrectEntries += 1
        if (numberOfIncorrectEntries >= 7) {
            gameOver()
        } else {
            hangmanImage.image = UIImage(named: "hangman\(numberOfIncorrectEntries+1).gif")
            wrongGuesses.append("w")
            wrongGuessesLabel.text = toString(wrongGuesses)
        }
    }

    @IBAction func correctEntrySoMakeTheLetterAppear() {
        let index = numberOfCorrectEntries
        numberOfCorrectEntries += 1
        if (numberOfCorrectEntries*3 == hangmanWordUserSees.count + 2) {
            hangmanWordUserSees[hangmanWordUserSees.count - 1] = phrase[phrase.startIndex.advancedBy(index)]
            hangmanWord.text = toString(hangmanWordUserSees)
        } else if (numberOfCorrectEntries*3 >= hangmanWordUserSees.count) {
            gameWon()
        } else {
            hangmanWordUserSees[index*3] = phrase[phrase.startIndex.advancedBy(index)]
            hangmanWord.text = toString(hangmanWordUserSees)
        }
    }
    
    func gameWon() {
    
    }
    
    func gameOver() {
    
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  GuessViewController.swift
//  imushroom
//
//  Created by etudiant-02 on 04/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class GuessViewController: UIViewController {
    
    @IBOutlet var questionLabel : UILabel!
    @IBOutlet var yesButton : UIButton!
    @IBOutlet var noButton : UIButton!
    @IBOutlet var retryButton : UIButton!
    
    var firstPanelQuestions : CardListIterator!
    var secondPanelQuestions : CardListIterator!
    var questions : CardListIterator!
    var firstQuestion : Bool!
    
    
    
    @IBAction func restart()
    {
        initGame()
    }
    
    @IBAction func buttonPressed(sender: UIButton)
    {
        if firstQuestion == true
        {
            firstQuestion = false
            if sender.tag == 1
            {
                questions = firstPanelQuestions
            }
            else
            {
                questions = secondPanelQuestions
            }
            displayQuestion()
        }
        else
        {
            // yes
            if sender.tag == 1
            {
                questionLabel.text = questions.current().answer
                endGame()
            }
            else
            {
                questions.next()
                displayQuestion()
            }
        }
    }
    
    func endGame()
    {
        yesButton.hidden = true
        noButton.hidden = true
        retryButton.hidden = false
    }
    
    func initGame()
    {
        retryButton.hidden = true
        yesButton.hidden = false
        noButton.hidden = false
        firstQuestion = true
        
        var cardList = CardList()
        cardList.addCard(Card(question: "Est-ce-que le champignon vit dans la forêt ?", answer: "Armanite"))
        cardList.addCard(Card(question: "Est-ce-que le champignon a un chapeau ?", answer: "Argarite"))
        cardList.addCard(Card(question: nil, answer: "Caprin"))
        firstPanelQuestions = CardListIterator(cardList: cardList)
        
        cardList = CardList()
        cardList.addCard(Card(question: "Est-ce-que le champignon a des tubes ?", answer: "Cèpe"))
        cardList.addCard(Card(question: "Est-ce-que le champignon a un chapeau ?", answer: "Pied bleu"))
        cardList.addCard(Card(question: nil, answer: "Girolle"))
        secondPanelQuestions = CardListIterator(cardList: cardList)

        
        questionLabel.text = "Est-ce-que le champignon a un anneau ?"
    }
    
    func displayQuestion()
    {
        if questions.current().question != nil
        {
            questionLabel.text = questions.current().question
        }
        else
        {
            questionLabel.text = questions.current().answer
            endGame()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

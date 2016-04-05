//
//  Model.swift
//  imushroom
//
//  Created by etudiant-02 on 04/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation


class Card
{
    var question : String?
    
    var answer : String?
    
    init (question : String?, answer : String?)
    {
        self.question = question
        self.answer = answer
    }
}

class CardList
{
    var cards = [Card]()
    
    func getCard(index : Int) -> Card?
    {
        if index < self.cards.count
        {
            return self.cards[index]
        }
        
        return nil
    }
    
    func addCard (card : Card)
    {
        self.cards.append(card)
    }
}

class CardListIterator
{
    var currentCard = 0
    
    var cardList : CardList
    
    func current() -> Card
    {
        return self.cardList.getCard(self.currentCard)!
    }
    
    func next()
    {
        self.currentCard += 1
    }
    
    init (cardList : CardList)
    {
        self.cardList = cardList
    }
}
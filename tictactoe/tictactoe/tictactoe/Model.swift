//
//  Model.swift
//  tictactoe
//
//  Created by etudiant-02 on 01/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation
import UIKit

class Game
{
    var nbColumns : Int
    
    var lineWidth : CGFloat = 5
    
    let leftMargin : CGFloat = 30
    let topMargin : CGFloat = 150
    
    var gridPlayer = [[Int]]()
    
    var end : Bool = false
    
    /**
     Size of grid
     Taille de l'écran moins les 2 marges (left et right)
     - returns: CGFloat
    */
    var gridSize : CGFloat {
        return realScreenWidth() - (2 * self.leftMargin)
    }
    
    /**
     Column width
     - returns: CGFloat
    */
    var columnWidth : CGFloat {
        return self.gridSize / CGFloat(self.nbColumns)
    }
    
    func detectWin() -> Int
    {
        return 1
    }
    
    func detectFull() -> Bool
    {
        for indexi in 0..<self.nbColumns
        {
            for indexj in 0..<self.nbColumns
            {
                if self.gridPlayer[indexi][indexj] == 0
                {
                    return false
                }
            }
        }
        
        return true
    }
    
    init (nbColumns : Int) {
        self.nbColumns = nbColumns
        self.end = false
        
        for _ in 0..<self.nbColumns
        {
            let oneLine = Array(count: self.nbColumns, repeatedValue: 0)
            self.gridPlayer.append(oneLine)
        }
    }
}


struct Move
{
    var i : Int
    var j : Int
}
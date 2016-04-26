//
//  Model.swift
//  tictactoe
//
//  Created by nicolas on 28/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation
import UIKit

struct Move {
    var i : Int
    var j : Int
}

class Game {
    var nbColumns : Int
    var leftMargin : CGFloat = 30
    var topMargin : CGFloat = 100
    var lineWidth : CGFloat = 5
    
    var grid = [[Int]]()
    var moves = [Move]() //tableau des coups joués

    var gridSize : CGFloat {
        return realScreenWidth() - 2 * self.leftMargin
    }
    
    var columnWidth : CGFloat {
        return self.gridSize / CGFloat(self.nbColumns)
    }
    
    var nbToAlign : Int {
        return (self.nbColumns < 4) ? self.nbColumns : self.nbColumns - 1
    }
    
    init(nbColumns : Int) {
        self.nbColumns = nbColumns
        
        // initialisation de la grille
        /*
        for _ in 0..<self.nbColumns {
            let oneLine = Array(count : self.nbColumns, repeatedValue:0)
            self.grid.append(oneLine)
        }
        */
        self.grid = Array(count: self.nbColumns, repeatedValue : Array(count: self.nbColumns, repeatedValue: 0))
        
        if self.nbColumns > 6 {
            lineWidth = 3
        }
    }
    
    var detectGameOver : Bool {
        return moves.count == nbColumns * nbColumns - 1
    }
    
    // calcul pour savoir si quelqu'un a gagné
    
    // ne fonctionne que pour nbColumns = 3
    /*
    func simpleDetectWin (player : Int) -> Bool {
        var win = false
        
        // première diagonale
        if grid[0][0] == player && grid[1][1] == player && grid[2][2] == player {
            win = true
        }
        // deuxième diagonale
        if grid[2][0] == player && grid[1][1] == player && grid[0][2] == player {
            win = true
        }
        
        for index in 0...2 {
            // ligne verticale
            if grid[0][index] == player && grid[1][index] == player && grid[2][index] == player {
                win = true
            }
            
            // ligne horizontale
            if grid[index][0] == 0 && grid[index][1] == player && grid[index][2] == player {
                win = true
            }
        }
        
        return win
    }*/
    
    var detectWin : Bool {
        var output = false
        
        func inGrid(i: Int, j:Int)->Bool {
            return (i >= 0) && (j >= 0) && (i<nbColumns) && (j<nbColumns)
        }
        
        func detectHorizontalLine(i : Int, j : Int)->Bool {
            let player = grid[i][j]
            if player != 0 {
                var resultat = true
                for index in i+1..<i+nbToAlign {
                    if (index < nbColumns) && (grid[index][j] != player) {
                        resultat = false
                        break
                    }
                }
                return resultat
            } else {
                return false
            }
        }
        
        func detectVerticalLine(i : Int, j : Int)->Bool {
            let player = grid[i][j]
            if player != 0 {
                var resultat = true
                for index in j+1..<j+nbToAlign {
                    if (index < nbColumns) && (grid[i][index] != player) {
                        resultat = false
                        break
                    }
                }
                return resultat
            } else {
                return false
            }
        }
        
        func detectDiagonalUp(i : Int, j : Int)->Bool {
            let player = grid[i][j]
            if player != 0 && inGrid(i + nbToAlign - 1, j: j - nbToAlign + 1) {
                var resultat = true
                
                for index in 1..<nbToAlign {
                    //diagonal up
                    if player != grid[i+index][j-index] {
                        resultat = false
                        break
                    }
                }
                return resultat
            } else {
                return false
            }
        }
        
        func detectDiagonalDown(i : Int, j : Int)->Bool {
            let player = grid[i][j]
            if player != 0 && inGrid(i + nbToAlign - 1, j: j + nbToAlign - 1) {
                var resultat = true
                
                for index in 1..<nbToAlign {
                    
                    if player != grid[i+index][j+index] {
                        resultat = false
                        break
                    }
                }
                return resultat
            } else {
                return false
            }
        }
        
        for indexi in 0..<(nbColumns - nbToAlign + 1) {
            for indexj in 0..<nbColumns {
                if detectHorizontalLine(indexi, j: indexj) || detectDiagonalUp(indexi, j: indexj) || detectDiagonalDown(indexi, j: indexj) {
                    output = true
                    break //sort de la boucle
                }
            }
        }
        
        for indexj in 0..<(nbColumns - nbToAlign + 1) {
            for indexi in 0..<nbColumns {
                if detectVerticalLine(indexi, j: indexj) {
                    output = true
                    break //sort de la boucle
                }
            }
        }
        
        return output
    }
}


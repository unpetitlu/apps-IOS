//
//  MainViewController.swift
//  tableview
//
//  Created by etudiant-02 on 07/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var myTableView : UITableView!
    
    var movies = [Movie]()
    
    func initMovies()
    {
        movies.append(Movie(title: "Mad Men", genre: "Drama", description: "In 1960s New York, alpha male Don Draper struggles to stay on top of the heap in the high-pressure world of Madison Avenue advertising firms. Aside from being one of the top ad men in the business, Don is also a family man, the father of young children.", image: UIImage(named: "madmen")!))
        
        movies.append(Movie(title: "Game of Thrones", genre: "Fantasy", description: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and the icy horrors beyond.", image: UIImage(named: "gameofthrones")!))
        
        movies.append(Movie(title: "Curb Your Enthusiasm", genre: "Comedy", description: "The unscripted Curb Your Enthusiasm brings the off-kilter comic vision of Larry David, who plays himself in a parallel universe in which he can't seem to do anything right, and, by his standards, neither can anyone else.", image: UIImage(named: "curb")!))
        
        movies.append(Movie(title: "Scandal", genre: "Drama", description: "A former media relations consultant to the President, Olivia Pope (Kerry Washington) dedicates her life to protecting and defending the public images of our nation's elite. After leaving the White House, the power consultant opened her own firm, hoping to start a new chapter -- both professionally and personally -- but she can't seem to completely cut ties with her past. Slowly it becomes apparent that her staff, who specialize in fixing the lives of other people, can't quite fix the ones closest at hand -- their own.", image: UIImage(named: "scandal")!))
        
        movies.append(Movie(title: "House of Cards", genre: "Drama", description: "Ruthless and cunning, Congressman Francis Underwood and his wife Claire stop at nothing to conquer everything. This wicked political drama penetrates the shadowy world of greed, sex and corruption in modern D.C.", image: UIImage(named: "houseofcards")!))
        
        movies.append(Movie(title: "The Walking Dead", genre: "Horror", description: "The world we knew is gone. An epidemic of apocalyptic proportions has swept the globe causing the dead to rise and feed on the living. In a matter of months society has crumbled. In a world ruled by the dead, we are forced to finally start living. Based on a comic book series of the same name by Robert Kirkman, this AMC project focuses on the world after a zombie apocalypse. The series follows a police officer, Rick Grimes, who wakes up from a coma to find the world ravaged with zombies. Looking for his family, he and a group of survivors attempt to battle against the zombies in order to stay alive.", image: UIImage(named: "walkingdead")!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMovies()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - TableView
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        // Retourner le nombre de ligne dans la section
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // la variable indexpath.row indique la ligne selectionnée
        // on accède aux IBOutlet de la cellule avec par exemple : cell.name =
        //cell
        cell.myImage.image = movies[indexPath.row].image
        cell.titleLabel.text = movies[indexPath.row].title
        cell.genreLabel.text = movies[indexPath.row].genre
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Change size cell for iphone or ipad
    }
    */
}
// MARK: -
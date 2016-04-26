//
//  ViewController.swift
//  tableview
//
//  Created by nicolas on 06/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var myTableView : UITableView!
    var refreshControl: UIRefreshControl!

    var movies : [Movie]!
    
    @IBAction func addSerieButtonPressed() {
        
        //création d'un UIAlertController
        let alertController = UIAlertController(title: "Ajouter une série ?"
            , message: "C'est gratuit" , preferredStyle: .Alert)
        
        // Action si OK
        let acceptAction = UIAlertAction(title:  "OK", style: .Default) { _ in
            print("ajout d'une série")
            self.movies.insert(Movie(title: "Nouvelle série", genre: "Comedy", description: "Une série ajoutée ensuite", image: UIImage(named:"walkingdead")!), atIndex: 0)
            self.myTableView.reloadData()
        }
        
        // Action si Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {_ in
            print("ajout annulé")
        }
        
        // On ajoute les actions à l'objet
        alertController.addAction(cancelAction)
        alertController.addAction(acceptAction)
        
        self.presentViewController(alertController, animated: false, completion: nil)
    }
    

    // mise à jour de la TableView après un Pull to refresh
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        print("refresh")

        initMovies()
        
        myTableView.reloadData()
        
        self.refreshControl.endRefreshing()

    }
    
    func initMovies () {
        movies = [Movie]()
        
        movies.append(Movie(title: "Mad Men", genre: "Drama", description: "In 1960s New York, alpha male Don Draper struggles to stay on top of the heap in the high-pressure world of Madison Avenue advertising firms. Aside from being one of the top ad men in the business, Don is also a family man, the father of young children.", image: UIImage(named: "madmen")!))
        
        movies.append(Movie(title: "Game of Thrones", genre: "Fantasy", description: "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and the icy horrors beyond.", image: UIImage(named: "gameofthrones")!))
        
        movies.append(Movie(title: "Curb Your Enthusiasm", genre: "Comedy", description: "The unscripted Curb Your Enthusiasm brings the off-kilter comic vision of Larry David, who plays himself in a parallel universe in which he can't seem to do anything right, and, by his standards, neither can anyone else.", image: UIImage(named: "curb")!))
        
        movies.append(Movie(title: "Scandal", genre: "Drama", description: "A former media relations consultant to the President, Olivia Pope (Kerry Washington) dedicates her life to protecting and defending the public images of our nation's elite. After leaving the White House, the power consultant opened her own firm, hoping to start a new chapter -- both professionally and personally -- but she can't seem to completely cut ties with her past. Slowly it becomes apparent that her staff, who specialize in fixing the lives of other people, can't quite fix the ones closest at hand -- their own.", image: UIImage(named: "scandal")!))
        
        movies.append(Movie(title: "House of Cards", genre: "Drama", description: "Ruthless and cunning, Congressman Francis Underwood and his wife Claire stop at nothing to conquer everything. This wicked political drama penetrates the shadowy world of greed, sex and corruption in modern D.C.", image: UIImage(named: "houseofcards")!))
        
        movies.append(Movie(title: "The Walking Dead", genre: "Horror", description: "The world we knew is gone. An epidemic of apocalyptic proportions has swept the globe causing the dead to rise and feed on the living. In a matter of months society has crumbled. In a world ruled by the dead, we are forced to finally start living. Based on a comic book series of the same name by Robert Kirkman, this AMC project focuses on the world after a zombie apocalypse. The series follows a police officer, Rick Grimes, who wakes up from a coma to find the world ravaged with zombies. Looking for his family, he and a group of survivors attempt to battle against the zombies in order to stay alive.", image: UIImage(named: "walkingdead")!))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "todetail")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: DetailViewController =  segue.destinationViewController as! DetailViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.movie = movies[myTableView.indexPathForSelectedRow!.row]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initMovies()
        myTableView.reloadData()
        
        self.refreshControl = UIRefreshControl()
        
        let attribute = [NSForegroundColorAttributeName: UIColor.redColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Glisser pour rafraichir", attributes: attribute)
        
      //  self.refreshControl.attributedTitle.attr
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.myTableView.addSubview(self.refreshControl) // not required when using UITableViewController
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        
        if isIpad() {
            cell.imageWidthConstraint.constant = 300
            cell.imageHeightConstraint.constant = 168            
        }
        
        cell.titleLabel.text = self.movies[indexPath.row].title
        cell.myImageView.image = self.movies[indexPath.row].image
        cell.genreLabel.text = self.movies[indexPath.row].genre
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // on peut utiliser la variable suivantes si nécessaire
        //let mySelectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        
        performSegueWithIdentifier("todetail", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /*  code classique pour effacer une ligne. j'ai mis à la place le code dans editActionsForRowAtIndexPath
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    */
    
    
    // modification à la main de la hauteur des cellules
    // cette valeur override la valeur définie dans Interface Builder
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isIpad() {
            return 200
        } else {
            return 110
        }
    }
    
    // créé 3 boutons custom quand l'utilisateur slide une ligne de la tableview vers la gauche
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // more
        let more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        // favorite
        let favorite = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        // delete. Noter le .Desctructive dans le style qui donne automatiquement la couleur rouge
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            self.movies.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        }
        return [delete, favorite, more]
    }
}

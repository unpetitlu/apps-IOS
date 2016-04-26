//
//  PageViewController.swift
//  myvelib
//
//  Created by etudiant-02 on 13/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//
import UIKit

class PagerViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages = [UIViewController]()
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let currentIndex = pages.indexOf(viewController)!
        if (currentIndex == 0) {
            return nil
        } else {
            return pages[currentIndex-1]
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.indexOf(viewController)!
        if (currentIndex == pages.count-1) {
            return nil
        }else {
            return pages[currentIndex+1]
        }
    }
    
    /* LES DEUX FONCTIONS CI-DESSOUS PERMETTENT D'AVOIR DES BULLETS */
    /*
     func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
     return pages.count
     }
     
     func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
     return 0
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let p0 : MainViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("page"))! as! MainViewController
        p0.indexPage = .Work
        let p1 : MainViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("page"))! as! MainViewController
        p1.indexPage = .Home
        let p2 : MainViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("page"))! as! MainViewController
        p2.indexPage = .Geoloc

        pages = [p0, p1, p2]
        
        setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
}

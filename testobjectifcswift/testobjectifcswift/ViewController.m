//
//  ViewController.m
//  testobjectifcswift
//
//  Created by etudiant-02 on 21/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (int) plusThree:(int) myNumber {
    return myNumber + 3;
}

- (void) displayPlusTwog:(int) myNumber {
    int resultat = myNumber + 2;
    NSLog(@"le resultat est %d", resultat);
}

// bool correspond au return
// age qui est un int correspond à la valeur d'entrée
- (bool) estMajeur:(int) age {
    return age >= 18;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    int resultat = [self plusThree:5];
    
    NSLog(@"le resultat est %d", resultat);
    
    [self displayPlusTwog:1];
    
    
    NSLog(@"%d", [self estMajeur:20]);
    
    NSLog(@"%d", [self estMajeur:16]);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

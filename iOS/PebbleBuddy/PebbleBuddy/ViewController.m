//
//  ViewController.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/20/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lblShadow.layer.cornerRadius = self.lblShadow.frame.size.width/2;
    self.lblShadow.clipsToBounds = YES;
    self.outletNext.layer.cornerRadius = self.outletNext.frame.size.width/2;
    self.outletNext.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

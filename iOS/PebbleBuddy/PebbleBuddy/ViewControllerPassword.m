//
//  ViewControllerPasswordViewController.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ViewControllerPassword.h"

@interface ViewControllerPassword ()

@end

@implementation ViewControllerPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblShadow.layer.cornerRadius = self.lblShadow.frame.size.width/2;
    self.lblShadow.clipsToBounds = YES;
    self.outletLogin.layer.cornerRadius = self.outletLogin.frame.size.width/2;
    self.outletLogin.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewControllerPasswordViewController.h
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AppMessageKey) {
    KeyButtonUp = 0,
    KeyButtonDown
};

@interface ViewControllerPassword : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *outletLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblShadow;

@end

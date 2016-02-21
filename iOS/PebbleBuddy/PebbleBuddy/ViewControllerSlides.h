//
//  ViewControllerSlides.h
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerSlides : UIViewController
- (IBAction)btnBack:(UIButton *)sender;
- (IBAction)btnNext:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblSlideNum;
@property (weak, nonatomic) IBOutlet UITextView *tfNote;
@property (weak, nonatomic) IBOutlet UIImageView *imgSlide;
@property (weak, nonatomic) IBOutlet UIButton *outletBack;
@property (weak, nonatomic) IBOutlet UIButton *outletNext;
@property (weak, nonatomic) IBOutlet UILabel *lblShadow;
@property (weak, nonatomic) IBOutlet UILabel *lblShadowBack;

@end

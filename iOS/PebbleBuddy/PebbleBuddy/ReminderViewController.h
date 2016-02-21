//
//  ReminderViewController.h
//  PebbleBuddy
//
//  Created by Natalia García on 2/20/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *ViewTimePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pckTime;
@property (weak, nonatomic) IBOutlet UIView *ViewReminders;
- (IBAction)btnNewReminder:(UIButton *)sender;
- (IBAction)btnDone:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tvReminders;
@property (weak, nonatomic) IBOutlet UIButton *outletAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblShadow;


@end

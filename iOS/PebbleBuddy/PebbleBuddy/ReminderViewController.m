//
//  ReminderViewController.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/20/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ReminderViewController.h"
#import "TableViewCellReminders.h"
#import "AppDelegate.h"

@interface ReminderViewController ()
@property NSMutableArray *RemindersList;
@property NSMutableArray *MinuteList;
@property NSMutableArray *HourList;
@end
AppDelegate *nmainDelegate;
@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nmainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.lblShadow.layer.cornerRadius = self.lblShadow.frame.size.width/2;
    self.lblShadow.clipsToBounds = YES;
    
    self.outletAdd.layer.cornerRadius = self.outletAdd.frame.size.width/2;
    self.outletAdd.clipsToBounds = YES;
    [[self ViewTimePicker] setHidden: YES];
    _MinuteList = [[NSMutableArray alloc] init];
    _HourList = [[NSMutableArray alloc] init];
    _RemindersList = [[NSMutableArray alloc] init];
    NSString *num;
    for(int i = 0; i < 60; i++) {
        if(i < 10) {
            num = [NSString stringWithFormat:@"0%d", i];
        }
        else {
            num = [NSString stringWithFormat:@"%d", i];
        }
        [_MinuteList addObject:num];
    }
    
    for(int i = 0; i <= 10; i++) {
        if(i < 10) {
            num = [NSString stringWithFormat:@"0%d", i];
        }
        else {
            num = [NSString stringWithFormat:@"%d", i];
        }
        [_HourList addObject:num];
    }
    // Do any additional setup after loading the view, typically from a nib.
    self.pckTime.dataSource = self;
    self.pckTime.delegate = self;
    self.pckTime.showsSelectionIndicator = YES;
    if(nmainDelegate.sharedReminders.count > 0) {
        [[self ViewReminders] setHidden: NO];
    }
    else {
        [[self ViewReminders] setHidden: YES];
    }
    [_RemindersList addObjectsFromArray:[nmainDelegate.sharedReminders allValues]];
    self.tvReminders.dataSource = self;
    self.tvReminders.delegate = self;
    [[self tvReminders] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.RemindersList.count;
}

- (TableViewCellReminders *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *object = [_RemindersList objectAtIndex:[indexPath row]];
    TableViewCellReminders *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lblTime.text = object;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// Return row count for each of the components
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_HourList count];
    }
    else {
        return [_MinuteList count];
    }
}

// The number of rows of data
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
            return [_HourList objectAtIndex:row];
    }
    else if (component == 1) {
            return [_MinuteList objectAtIndex:row];
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnNewReminder:(UIButton *)sender {
    [[self ViewTimePicker] setHidden: NO];
    
}

- (IBAction)btnDone:(UIButton *)sender {
    if([[self pckTime] selectedRowInComponent:1] != 0 || [[self pckTime] selectedRowInComponent:0] != 0) {
        int hour = [[self pckTime] selectedRowInComponent:0];
        int minute = [[self pckTime] selectedRowInComponent:1];
        NSString *str = [NSString stringWithFormat:@"%02d:%02d",hour, minute];
        [_RemindersList addObject:str];
        [nmainDelegate.sharedReminders addEntriesFromDictionary:@{[NSString stringWithFormat: @"reminder %lu", (unsigned long)[_RemindersList count]]: str}];
        self.tvReminders.dataSource = self;
        self.tvReminders.delegate = self;
        [[self tvReminders] reloadData];
    }
    if([_RemindersList count] > 0) {
        [[self ViewReminders] setHidden: NO];
    }
    [[self ViewTimePicker] setHidden: YES];
}
@end

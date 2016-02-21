//
//  ViewControllerMenu.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ViewControllerMenu.h"
#import "AppDelegate.h"

@interface ViewControllerMenu ()

@end
AppDelegate *mainDelegate2;
@implementation ViewControllerMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mainDelegate2 = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)btnPresent:(UIButton *)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"SlideNum.json"];
    NSMutableDictionary *jsonData = [[NSMutableDictionary alloc] initWithDictionary:mainDelegate2.sharedReminders];
    [jsonData addEntriesFromDictionary:mainDelegate2.sharedNotes];
    NSString *str = [[NSString alloc] initWithString:[self dictToJson:jsonData]];
    [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString *)dictToJson:(NSDictionary *)dict
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return  [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
}


@end

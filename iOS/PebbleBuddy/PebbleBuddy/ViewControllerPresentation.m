//
//  ViewControllerPresentation.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ViewControllerPresentation.h"
#import "PebbleKit/PebbleKit.h"
@import PebbleKit;

typedef NS_ENUM(NSUInteger, AppMessageKey) {
    KeyButtonUp = 0,
    KeyButtonDown
};

@interface ViewControllerPresentation () <PBPebbleCentralDelegate>
@property (weak, nonatomic) PBPebbleCentral *central;
@property (weak, nonatomic) PBWatch *watch;
@end
NSString *npath;
int nmaxPages;
int npageNum = 1;
NSNumber *otherPageNum;
NSURL *nurl;

@implementation ViewControllerPresentation

- (void)viewDidLoad {
    [super viewDidLoad];
    npath = [[NSBundle mainBundle] pathForResource:@"Slide 1" ofType:@"pdf"];
    nurl = [NSURL fileURLWithPath:npath];
    self.imgSlide.image = [self drawPDFfromURL:nurl];
    self.lblSlideNum.text = [NSString stringWithFormat:@"Slide %i", npageNum];
    self.central = [PBPebbleCentral defaultCentral];
    self.central.delegate = self;
    //localhost con json
    self.central.appUUID = [[NSUUID alloc] initWithUUIDString:@"3783cff2-5a14-477d-baee-b77bd423d079"];
    [self.central run];
    otherPageNum = [[NSNumber alloc] init];
    // Do any additional setup after loading the view.
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidDisconnect:(PBWatch *)watch {
    // Only remove reference if it was the current active watch
    if (self.watch == watch) {
        self.watch = nil;
        NSLog(@"Watch disconnected");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *) drawPDFfromURL:(NSURL *)url {
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)url);
    CGPDFPageRef page = CGPDFDocumentGetPage(document, npageNum);
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    UIGraphicsBeginImageContextWithOptions(pageRect.size, true, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawPDFPage(context, page);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    nmaxPages = CGPDFDocumentGetNumberOfPages(document);
    return img;
}

-(void)next {
    if(npageNum != nmaxPages) {
        npageNum++;
        self.imgSlide.image = [self drawPDFfromURL:nurl];
        self.lblSlideNum.text = [NSString stringWithFormat:@"Slide %i", npageNum];
    }
}

-(void)back {
    if(npageNum != 1) {
        npageNum--;
        self.imgSlide.image = [self drawPDFfromURL:(nurl)];
        self.lblSlideNum.text = [NSString stringWithFormat: @"Slide %i", npageNum];
    }
}

- (IBAction)btnBack:(UIButton *)sender {
    if(npageNum != 1) {
        npageNum--;
        self.imgSlide.image = [self drawPDFfromURL:(nurl)];
        self.lblSlideNum.text = [NSString stringWithFormat: @"Slide %i", npageNum];
    }
}

- (IBAction)btnNext:(UIButton *)sender {
    if(npageNum != nmaxPages) {
        npageNum++;
        self.imgSlide.image = [self drawPDFfromURL:nurl];
        self.lblSlideNum.text = [NSString stringWithFormat:@"Slide %i", npageNum];
    }
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew {
//    if (self.watch) {
//        return;
//    }
    self.watch = watch;
    NSLog(@"Watch connected!");
    
    // Keep a weak reference to self to prevent it staying around forever
    __weak typeof(self) welf = self;
    
    // Sign up for AppMessage
    
//    [self.watch appMessagesAddReceiveUpdateHandler:^BOOL(PBWatch *watch, NSDictionary *update) {
//        __strong typeof(welf) sself = welf;
//        if (!sself) {
//            // self has been destroyed
//            return NO;
//        }
//        
//        // Process incoming messages
//        if (update[@(KeyButtonUp)]) {
//            // Up button was pressed!
//            NSLog(@"UP");
//            [self next];
//        }
//        
//        if (update[@(KeyButtonDown)]) {
//            // Down button pressed!
//            NSLog(@"DOWN");
//            [self back];
//        }
//        
////        // Get the size of the main view and update the current page offset
////        CGSize windowSize = CGSizeMake(sself.view.frame.size.width, sself.view.frame.size.height);
////        [sself.scrollView setContentOffset:CGPointMake(sself.currentPage * windowSize.width, 0) animated:YES];
//        
//        return YES;
//    }];
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

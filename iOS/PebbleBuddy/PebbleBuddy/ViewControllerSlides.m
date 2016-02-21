//
//  ViewControllerSlides.m
//  PebbleBuddy
//
//  Created by Natalia García on 2/21/16.
//  Copyright © 2016 HackITC. All rights reserved.
//

#import "ViewControllerSlides.h"
#import "ViewControllerMenu.h"
#import "AppDelegate.h"

@interface ViewControllerSlides ()
@end
NSString *path;
int maxPages;
int pageNum = 1;
CGFloat pageHeight;
NSURL *url;
NSMutableDictionary *notesDictionary;
AppDelegate *mainDelegate;
@implementation ViewControllerSlides

- (void)viewDidLoad {
    [super viewDidLoad];
    mainDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //slide 1 = nombre de presentacion TIENE QUE SER PDF
    path = [[NSBundle mainBundle] pathForResource:@"Slide 1" ofType:@"pdf"];
    url = [NSURL fileURLWithPath:path];
    self.imgSlide.image = [self drawPDFfromURL:url];
    self.lblSlideNum.text = [NSString stringWithFormat:@"Slide %i", pageNum];
    
    self.outletBack.layer.cornerRadius = self.outletBack.frame.size.width/2;
    self.outletBack.clipsToBounds = YES;
    
    self.outletNext.layer.cornerRadius = self.outletNext.frame.size.width/2;
    self.outletNext.clipsToBounds = YES;
    
    self.lblShadow.layer.cornerRadius = self.lblShadow.frame.size.width/2;
    self.lblShadow.clipsToBounds = YES;
    
    self.lblShadowBack.layer.cornerRadius = self.lblShadowBack.frame.size.width/2;
    self.lblShadowBack.clipsToBounds = YES;
    notesDictionary = [[NSMutableDictionary alloc] init];
    
    self.tfNote.delegate = self;
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(UIImage *) drawPDFfromURL:(NSURL *)url {
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)url);
    CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNum);
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    UIGraphicsBeginImageContextWithOptions(pageRect.size, true, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawPDFPage(context, page);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    maxPages = CGPDFDocumentGetNumberOfPages(document);
    return img;
}

-(void) changeDisplayedNote {
    //self.tfNote.text = notesDictionary[[NSString stringWithFormat:@"page %i",pageNum]];
    self.tfNote.text = mainDelegate.sharedNotes[[NSString stringWithFormat:@"page %i",pageNum]];
}

-(void) saveNote {
    if(self.tfNote.text != nil) {
        [notesDictionary setObject:self.tfNote.text forKey:[NSString stringWithFormat:@"page %i",pageNum]];
        [mainDelegate.sharedNotes addEntriesFromDictionary:notesDictionary];
        //notesDictionary[pageNum] = self.tfNote.text;
    }
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
        if ([[segue identifier] isEqualToString:@"showMenu"]) {
            ViewControllerMenu *menuView  = [segue destinationViewController];
            [mainDelegate.sharedDictionary addEntriesFromDictionary:notesDictionary];
        }
    
}*/

- (IBAction)btnBack:(UIButton *)sender {
    if(pageNum != 1) {
        [self saveNote];
        pageNum--;
        self.imgSlide.image = [self drawPDFfromURL:(url)];
        self.lblSlideNum.text = [NSString stringWithFormat: @"Slide %i", pageNum];
        [self changeDisplayedNote ];
    }
}

- (IBAction)btnNext:(UIButton *)sender {
    if(pageNum != maxPages) {
        [self saveNote];
        pageNum++;
        self.imgSlide.image = [self drawPDFfromURL:url];
        self.lblSlideNum.text = [NSString stringWithFormat:@"Slide %i", pageNum];
        [self changeDisplayedNote ];
    }
}

#define kOFFSET_FOR_KEYBOARD 200.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.tfNote])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)quitaTeclado {
    [self.tfNote resignFirstResponder];
}

@end


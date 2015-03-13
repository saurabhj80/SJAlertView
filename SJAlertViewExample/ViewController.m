//
//  ViewController.m
//  SJAlertViewExample
//
//  Created by Saurabh Jain on 3/12/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <SJAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *alert1;
@property (weak, nonatomic) IBOutlet UIButton *alert2;

@end

@implementation ViewController

#pragma mark -
#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customization
    
    self.alert = [[SJAlertView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100, CGRectGetMidY(self.view.bounds) - 50, 200, 100)];
    self.alert.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    [self.alert setTitle:@"Please Try Again"];
    [self.alert setMessage:@"Hello. Please enter a licence plate number"];
    
    [self.alert setTitleColor:[UIColor whiteColor]];
    [self.alert setMessageColor:[UIColor whiteColor]];
    
    [self.alert setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
    
    [self.view addSubview:self.alert];
    
    self.alert.delegate = self;
}

#pragma mark -
#pragma mark - IBActions

- (IBAction)showAlert:(UIButton *)sender
{
    [self.alert setPresentationStyle:SJAlertViewPresenatationStyleDefault];
    [self.alert presentAlert:YES];
    
    [self enableButtons:NO];
}

- (IBAction)showAlert2:(UIButton *)sender
{
    [self.alert setPresentationStyle:SJAlertViewPresenatationStyleSnap];
    [self.alert presentAlert:YES];
    
    [self enableButtons:NO];
}

- (void) enableButtons:(BOOL)enable
{
    self.alert1.enabled = enable;
    self.alert2.enabled = enable;
}

#pragma mark -
#pragma mark - SJAlertView Delegate

-(void)alertWillDisAppear
{
    [self enableButtons:YES];
}

@end

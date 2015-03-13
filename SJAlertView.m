//
//  SJAlertView.m
//  SJAlertViewExample
//
//  Created by Saurabh Jain on 3/12/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

#import "SJAlertView.h"

@interface SJAlertView()

/**
 *  Title Label
 */
@property (strong, nonatomic) UILabel* titleLabel;

/**
 *  Message Label
 */
@property (strong, nonatomic) UILabel* messageLabel;

/**
 *  Cancel Button
 */
@property (strong, nonatomic) UIButton* cancel;

/**
 *  Animator Object
 */
@property (strong, nonatomic) UIDynamicAnimator* animator;

/**
 *  Different Behaviours
 */
@property (strong, nonatomic) UISnapBehavior* snap;
@property (strong, nonatomic) UIPushBehavior* push;

/**
 *  Frame of the alert view
 */
@property (nonatomic) CGRect frame1;

@end

@implementation SJAlertView

#define cancelStringTitle "Ok"

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame1 = frame;
        [self setUp];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButton:(NSString *)cancelTitle
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        [self setUp];
        
        self.title = title;
        self.message = message;
    }
    
    return self;
}

- (void) setUp
{
    self.alpha = 0;
    
    self.clipsToBounds = YES;
    
    self.title = nil;
    self.message = nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    
    self.style = SJAlertViewPresenatationStyleDefault;
    
    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 24)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    // Message Label
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.titleLabel.bounds.size.height + 16, self.bounds.size.width - 16, 24)];
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    [self addSubview:self.messageLabel];
    
    [self addCancelButton:@cancelStringTitle];
}

#pragma mark - 
#pragma mark - Cancel Button

- (void) addCancelButton:(NSString*)str
{
    self.cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
    [self setCancelButtonTitle:str forState:UIControlStateNormal];
    [self.cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancel.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.cancel];
}

- (void)dismiss
{
    if (self.style == SJAlertViewPresenatationStyleDefault) {
        
        if ([self.delegate respondsToSelector:@selector(alertWillDisAppear)]) {
            [self.delegate alertWillDisAppear];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if ([self.delegate respondsToSelector:@selector(alertDidDisAppear)]) {
                [self.delegate alertDidDisAppear];
            }
        }];
    }
    
    else if (self.style == SJAlertViewPresenatationStyleSnap ) {
        
        [self.animator removeBehavior:self.snap];
        
        self.push = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
        self.push.magnitude = 1;
        self.push.pushDirection = CGVectorMake(50, 0);
        
        if ([self.delegate respondsToSelector:@selector(alertWillDisAppear)]) {
            [self.delegate alertWillDisAppear];
        }
        
        [self.animator addBehavior:self.push];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            while (CGRectContainsRect(self.superview.frame, self.frame));
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.animator removeAllBehaviors];
                self.alpha = NO;
                self.frame = self.frame1;
                
                if ([self.delegate respondsToSelector:@selector(alertDidDisAppear)]) {
                    [self.delegate alertDidDisAppear];
                }
            });
            
        });
    }
    
}

- (void)setCancelButtonTitle:(NSString*)title forState:(UIControlState)state
{
    if (self.cancel) {
        [self.cancel setTitle:title forState:state];
    }
}

- (void)setCancelButtonColor:(UIColor*)color forState:(UIControlState)state
{
    if (self.cancel) {
        [self.cancel setTitleColor:color forState:state];
    }
}

#pragma mark -
#pragma mark - Setters

-(void)setTitle:(NSString *)title
{
    _title = title;
    if (_title) {
        self.titleLabel.text = _title;
        [self setConstrantsOnLabel:self.titleLabel];
        [self setMessageFrame];
    }
}

-(void)setMessage:(NSString *)message
{
    _message = message;
    if (_message) {
        self.messageLabel.text = _message;
        [self setConstrantsOnLabel:self.messageLabel];
    }
}

- (void) setConstrantsOnLabel:(UILabel*)label
{
    CGSize maximumLabelSize = CGSizeMake(self.bounds.size.width, FLT_MAX);
    
    CGRect expectedLabelSize = [label.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil];
    
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.size.height;
    label.frame = newFrame;
}

- (void)setTitleColor:(UIColor*)color
{
    if (self.titleLabel) {
        self.titleLabel.textColor = color;
    }
}
- (void)setTitleFont:(UIFont*)font;
{
    if (self.titleLabel) {
        self.titleLabel.font = font;
        [self setConstrantsOnLabel:self.titleLabel];
        [self setMessageFrame];
    }
}

- (void)setMessageColor:(UIColor*)color;
{
    if (self.messageLabel) {
        self.messageLabel.textColor = color;
    }
}
- (void)setMessageFont:(UIFont*)font;
{
    if (self.messageLabel) {
        self.messageLabel.font = font;
        [self setConstrantsOnLabel:self.messageLabel];
    }
}

- (void) setMessageFrame
{
    self.messageLabel.frame = CGRectMake(8, self.titleLabel.bounds.size.height + 16, self.bounds.size.width - 16, 24);
}

#pragma mark -
#pragma mark - Presentation

- (void) presentAlert:(BOOL)yes
{
    CGFloat present = yes ? 1 : 0;
    
    if (present) {
        if ([self.delegate respondsToSelector:@selector(alertWillShow)]) {
            [self.delegate alertWillShow];
        }
    }
    
    if (self.style == SJAlertViewPresenatationStyleDefault) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = present;
        }];
    }
    else if (self.style == SJAlertViewPresenatationStyleSnap) {
                
        CGRect frame = self.frame;
        frame.origin.y = -500;
        self.frame = frame;
        
        self.alpha = 1;
        
        self.snap = [[UISnapBehavior alloc] initWithItem:self snapToPoint:CGPointMake(CGRectGetMidX(self.superview.frame), CGRectGetMidY(self.superview.frame))];
        self.snap.damping = 0.65;
        
        [self.animator addBehavior:self.snap];
    }
    
}

-(BOOL)isPresented
{
    return self.alpha ? 1 : 0;
}

- (void)setPresentationStyle:(SJAlertViewPresenatationStyle)style {
    
    self.style = style;
    
    if (!self.animator) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    }

}

@end

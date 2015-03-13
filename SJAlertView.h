//
//  SJAlertView.h
//  SJAlertViewExample
//
//  Created by Saurabh Jain on 3/12/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Delegation
 */
@protocol SJAlertViewDelegate <NSObject>

@optional
- (void)alertWillShow;
- (void)alertWillDisAppear;
- (void)alertDidDisAppear;

@end

/**
 *  Diiferent Presentation Style
 */
typedef NS_ENUM(NSInteger, SJAlertViewPresenatationStyle){
    /**
     *  Default
     */
    SJAlertViewPresenatationStyleDefault = 0,
    /**
     *  Snap Behavior
     */
    SJAlertViewPresenatationStyleSnap,
    /**
     *  Drop Behavior
     */
    SJAlertViewPresenatationStyleDrop
};

@interface SJAlertView : UIView <UIDynamicItem>

+ (instancetype)new __attribute__
((unavailable("+[new] not available, use init")));

- (instancetype)init __attribute__
((unavailable("-[init] not available, use other init method")));

/**
 *  Init
 *
 *  @param title       Title displayed on top of the message
 *  @param message     Message Acoompanying the title
 *  @param cancelTitle Title of the cancel button
 *
 *  @return instance of the alert
 */
- (instancetype)initWithTitle:(NSString*)title andMessage:(NSString*)message andCancelButton:(NSString*)cancelTitle;

- (void)presentAlert:(BOOL)yes;

/**
 *  Check whether the Alert is presented or not
 *
 *  @return Bool
 */
- (BOOL)isPresented;

/**
 *  Set the color of the title
 *
 *  @param color - Pass in a UIColor
 */
- (void)setTitleColor:(UIColor*)color;

/**
 *  Set the font of the title
 *
 *  @param font - Pass in a UIFont
 */
- (void)setTitleFont:(UIFont*)font;

/**
 *  Set the Color of the Message
 *
 *  @param color - UIColor
 */
- (void)setMessageColor:(UIColor*)color;

/**
 *  Set the font of the Message
 *
 *  @param font - UIFont
 */
- (void)setMessageFont:(UIFont*)font;

/**
 *  Set the presentation style - Defaults to SJAlertPresentationStyleDefault
 *
 *  @param style - SJAlertPresentationStyle(Enum)
 */
- (void)setPresentationStyle:(SJAlertViewPresenatationStyle)style;

/**
 *  Cancel Button - Title
 *
 *  @param title NSString
 *  @param state UIControlState
 */
- (void)setCancelButtonTitle:(NSString*)title forState:(UIControlState)state;

/**
 *  Cancel Button - Color
 *
 *  @param title UiColor
 *  @param state UIControlState
 */
- (void)setCancelButtonColor:(UIColor*)color forState:(UIControlState)state;

/**
 *  Property - Title
 */
@property (strong, nonatomic) NSString* title;

/**
 *  Property - Message
 */
@property (strong, nonatomic) NSString* message;

/**
 *  Presentation Style
 */
@property (nonatomic) SJAlertViewPresenatationStyle style;

/**
 *  Property - Delegate
 */
@property (weak, nonatomic) id<SJAlertViewDelegate> delegate;

@end

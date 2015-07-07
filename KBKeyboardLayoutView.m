//
//  KBKeyboardLayoutView.m
//  ALPlayground
//
//  Created by John Parron on 7/7/15.
//  Copyright (c) 2015 John Parron. All rights reserved.
//

#import "KBKeyboardLayoutView.h"

@interface KBKeyboardLayoutView ()

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

@end

@implementation KBKeyboardLayoutView

- (void)dealloc {
    
    //Stop observing notifications to prevent firing an exception
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    //Enable auto layout on the view
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Disable view interaction and visibility
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Instance Methods

- (BOOL)constrainToViewController:(UIViewController *)viewController {
    
    //Ensure the view can be constrained to the view controller
    if (self.superview || !viewController) {
        return NO;
    }
    
    //Add the view as a subview to the view controller
    [viewController.view addSubview:self];
    
    //Constrain the view to the left/leading edge of the controllers view
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeLeading
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeLeading
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    //Constrain the view to the right/trailing edge of the controllers view
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    //Constrain the view to the bottom edge of the controllers view
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    
    //Constrain the views height with an initial value of zero
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:0.0];
    
    //Add height contraint to itself
    [self addConstraint:self.heightConstraint];
    
    //Start observing keyboard notifications
    [self addObserverForKeyboardNotifications];
    
    return YES;
}

#pragma mark - Private Methods

- (void)addObserverForKeyboardNotifications {
    
    //Observe keyboard frame change notifications on the main thread
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification){
                                                      [self handleKeyboardNotification:notification];
                                                  }];
}

- (void)handleKeyboardNotification:(NSNotification *)notification {
    
    //Set visible keyboard height to the views height constraint
    CGRect keyboardFrame = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.heightConstraint.constant = MAX(0.0, CGRectGetHeight(self.superview.bounds) - CGRectGetMinY(keyboardFrame));
    
    //Animate the views height in relation to the keyboards frame change animation
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[(NSNumber *)notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationDuration:[(NSNumber *)notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

@end
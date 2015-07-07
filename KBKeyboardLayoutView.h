//
//  KBKeyboardLayoutView.h
//
//  Created by John Parron on 7/7/15.
//  Copyright (c) 2015 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KBKeyboardLayoutViewDelegate;

@interface KBKeyboardLayoutView : UIView

@property (weak, nonatomic) id<KBKeyboardLayoutViewDelegate> delegate;

- (BOOL)constrainToViewController:(UIViewController *)viewController;

@end

@protocol KBKeyboardLayoutViewDelegate <NSObject>

@optional
- (void)keyboardLayoutViewWillShow:(KBKeyboardLayoutView *)keyboardLayoutView;
- (void)keyboardLayoutViewWillHide:(KBKeyboardLayoutView *)keyboardLayoutView;

@end

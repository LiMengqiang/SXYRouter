//
//  UIViewController+TopViewController.h
//  HHRouterExample
//
//  Created by wuhaizeng on 16/6/14.
//  Copyright © 2016年 Huohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TopViewController)

+ (UIViewController*)topMostViewController;
+ (UIViewController*)topMostViewControllerOfViewController:(UIViewController*)viewController;

@end

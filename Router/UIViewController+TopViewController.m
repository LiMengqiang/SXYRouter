//
//  UIViewController+TopViewController.m
//  HHRouterExample
//
//  Created by wuhaizeng on 16/6/14.
//  Copyright © 2016年 Huohua. All rights reserved.
//

#import "UIViewController+TopViewController.h"

@implementation UIViewController (TopViewController)

+ (UIViewController*)topMostViewController
{
    UIViewController *rootVieWController = [UIApplication sharedApplication].windows.firstObject.rootViewController;
    return [self topMostViewControllerOfViewController:rootVieWController];
}

+ (UIViewController*)topMostViewControllerOfViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedViewController = [(UITabBarController*)viewController selectedViewController];
        return [self topMostViewControllerOfViewController:selectedViewController];
    }

    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visibleViewController = [(UINavigationController*)viewController visibleViewController];
        return [self topMostViewControllerOfViewController:visibleViewController];
    }

    if ([viewController presentedViewController]) {
        UIViewController *presentedViewController = [viewController presentedViewController];
        return [self topMostViewControllerOfViewController:presentedViewController];
    }

    for (UIView *subView in viewController.view.subviews) {
        UIResponder *nextResponder = subView.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewControllerOfViewController:(UIViewController *)nextResponder];
        }
    }
    NSLog(@"top viewController is %@", viewController);
    return viewController;
}

@end

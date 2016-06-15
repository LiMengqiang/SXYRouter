//
//  SXYRouter.h
//  HHRouterExample
//
//  Created by wuhaizeng on 16/6/14.
//  Copyright © 2016年 Huohua. All rights reserved.
//

/**
 *  创建swift class UIViewController 的时候在class前面加
 *  @objc(类名字) 例如
 *  @objc(PostViewController)
 *  class PostViewController: UIViewController{}
 *
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger, SXYRouteType) {
    SXYRouteTypeNone = 0,
    SXYRouteTypeViewController = 1,
    SXYRouteTypeBlock = 2
};

typedef id (^SXYRouterBlock)(NSDictionary *params);

@interface SXYRouter : NSObject

+ (instancetype)shared;

- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;
- (UIViewController *)matchController:(NSString *)route;

- (void)registerViewControllersWithPath:(NSString*)path;

- (void)map:(NSString *)route toBlock:(SXYRouterBlock)block;
- (SXYRouterBlock)matchBlock:(NSString *)route;
- (id)callBlock:(NSString *)route;

- (id)callBlock:(NSString *)route parameters:(NSDictionary*)parameters;

- (SXYRouteType)canRoute:(NSString *)route;

- (UIViewController *)pushWithRouter:(NSString *)router
                       parameters:(NSDictionary *)parameters;

- (UIViewController *)pushWithRouter:(NSString *)router
                  fromViewController:(UINavigationController *)from
                          parameters:(NSDictionary *)parameters
                           animated:(BOOL)animated;

- (UIViewController *)presentWithRouter:(NSString *)router
                          parameters:(NSDictionary *)parameters
                                   wrap:(BOOL)wrap; //是否需要 navigation

- (UIViewController *)presentWithRouter:(NSString *)router
                     fromViewController:(UIViewController *)from
                             parameters:(NSDictionary *)parameters
                               animated:(BOOL)animated
                                    wrap:(BOOL)wrap;

- (void)backToRouter:(NSString*)router;

@end

@interface UIViewController (SXYRouter)

@property (nonatomic, strong) NSDictionary *params;

@end
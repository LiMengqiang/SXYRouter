//
//  SXYRouter.m
//  HHRouterExample
//
//  Created by wuhaizeng on 16/6/14.
//  Copyright © 2016年 Huohua. All rights reserved.
//

#import "SXYRouter.h"
#import <objc/runtime.h>
#import "UIViewController+TopViewController.h"
@interface SXYRouter()
@property (strong, nonatomic) NSMutableDictionary *routes;
@end

@implementation SXYRouter

+ (instancetype)shared
{
    static SXYRouter *router = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (!router) {
            router = [[self alloc] init];
        }
    });
    return router;
}

- (void)registerViewControllersWithPath:(NSString *)path
{
    NSArray *viewControllers = [NSArray arrayWithContentsOfFile:path];
    __weak __typeof__(self) weakSelf = self;
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *classType = obj[@"classType"];
        NSString *URL = obj[@"URL"];
        if (classType && URL) {
            [weakSelf map:URL toControllerClass:NSClassFromString(classType)];
        }
    }];
}

- (void)map:(NSString *)route toBlock:(SXYRouterBlock)block
{
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];

    subRoutes[@"_"] = [block copy];
}

- (UIViewController *)matchController:(NSString *)route
{
    NSDictionary *params = [self paramsInRoute:route];
    Class controllerClass = params[@"controller_class"];

    UIViewController *viewController = [[controllerClass alloc] init];

    if ([viewController respondsToSelector:@selector(setParams:)]) {
        [viewController performSelector:@selector(setParams:)
                             withObject:[params copy]];
    }
    return viewController;
}

- (SXYRouterBlock)matchBlock:(NSString *)route
{
    NSDictionary *params = [self paramsInRoute:route];

    if (!params){
        return nil;
    }

    SXYRouterBlock routerBlock = [params[@"block"] copy];
    SXYRouterBlock returnBlock = ^id(NSDictionary *aParams) {
        if (routerBlock) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            [dic addEntriesFromDictionary:aParams];
            return routerBlock([NSDictionary dictionaryWithDictionary:dic].copy);
        }
        return nil;
    };

    return [returnBlock copy];
}

- (id)callBlock:(NSString *)route
{
    return [self callBlock:route parameters:nil];
}

- (id)callBlock:(NSString *)route parameters:(NSDictionary*)parameters
{
    NSDictionary *params = [self paramsInRoute:route];
    SXYRouterBlock routerBlock = [params[@"block"] copy];
    NSMutableDictionary *newParames = [NSMutableDictionary dictionaryWithDictionary:params];
    if (parameters) {
        [newParames setValuesForKeysWithDictionary:parameters];
    }
    if (routerBlock) {
        return routerBlock([newParames copy]);
    }
    return nil;
}

// extract params in a route
- (NSDictionary *)paramsInRoute:(NSString *)route
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"route"] = [self stringFromFilterAppUrlScheme:route];

    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromRoute:[self stringFromFilterAppUrlScheme:route]];
    for (NSString *pathComponent in pathComponents) {
        BOOL found = NO;
        NSArray *subRoutesKeys = subRoutes.allKeys;
        for (NSString *key in subRoutesKeys) {
            if ([subRoutesKeys containsObject:pathComponent]) {
                found = YES;
                subRoutes = subRoutes[pathComponent];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                params[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        if (!found) {
            return nil;
        }
    }

    // Extract Params From Query.
    NSRange firstRange = [route rangeOfString:@"?"];
    if (firstRange.location != NSNotFound && route.length > firstRange.location + firstRange.length) {
        NSString *paramsString = [route substringFromIndex:firstRange.location + firstRange.length];
        NSArray *paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                params[key] = value;
            }
        }
    }

    Class class = subRoutes[@"_"];
    if (class_isMetaClass(object_getClass(class))) {
        if ([class isSubclassOfClass:[UIViewController class]]) {
            params[@"controller_class"] = subRoutes[@"_"];
        } else {
            return nil;
        }
    } else {
        if (subRoutes[@"_"]) {
            params[@"block"] = [subRoutes[@"_"] copy];
        }
    }

    return [NSDictionary dictionaryWithDictionary:params];
}

#pragma mark - Private

- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }

    return _routes;
}

- (NSArray *)pathComponentsFromRoute:(NSString *)route
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    for (NSString *pathComponent in route.pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }

    return [pathComponents copy];
}

- (NSString *)stringFromFilterAppUrlScheme:(NSString *)string
{
    // filter out the app URL compontents.
    for (NSString *appUrlScheme in [self appUrlSchemes]) {
        if ([string hasPrefix:[NSString stringWithFormat:@"%@:", appUrlScheme]]) {
            return [string substringFromIndex:appUrlScheme.length + 2];
        }
    }

    return string;
}

- (NSArray *)appUrlSchemes
{
    NSMutableArray *appUrlSchemes = [NSMutableArray array];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    for (NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"]) {
        NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
        [appUrlSchemes addObject:appUrlScheme];
    }

    return [appUrlSchemes copy];
}

- (NSMutableDictionary *)subRoutesToRoute:(NSString *)route
{
    NSArray *pathComponents = [self pathComponentsFromRoute:route];

    NSInteger index = 0;
    NSMutableDictionary *subRoutes = self.routes;

    while (index < pathComponents.count) {
        NSString *pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }

    return subRoutes;
}

- (void)map:(NSString *)route toControllerClass:(Class)controllerClass
{
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];

    subRoutes[@"_"] = controllerClass;
}

- (SXYRouteType)canRoute:(NSString *)route
{
    NSDictionary *params = [self paramsInRoute:route];

    if (params[@"controller_class"]) {
        return SXYRouteTypeViewController;
    }

    if (params[@"block"]) {
        return SXYRouteTypeBlock;
    }
    
    return SXYRouteTypeNone;
}
#pragma -mark 添加方法
- (UIViewController*)setViewControllerParametersWithRouter:(NSString*)router
                                                parameters:(NSDictionary*)parameters
{
    __block UIViewController *viewController = [self matchController:router];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![key isKindOfClass:[NSString class]]) {
            return;
        }
        SEL setKey = NSSelectorFromString(key);
        if ([viewController respondsToSelector:setKey]) {
            [viewController setValue:obj forKey:key];
        }
    }];
    return viewController;
}

- (UIViewController *)pushWithRouter:(NSString *)router
                          parameters:(NSDictionary *)parameters
{
    return [self pushWithRouter:router fromViewController:nil parameters:parameters animated:YES];
}

- (UIViewController *)pushWithRouter:(NSString *)router
                  fromViewController:(UINavigationController *)from
                          parameters:(NSDictionary *)parameters
                            animated:(BOOL)animated
{
    UIViewController *viewController = [self setViewControllerParametersWithRouter:router parameters:parameters];
    if (from) {
        [from pushViewController:viewController animated:animated];
    }else{
        UINavigationController *navigationController = [UIViewController topMostViewController].navigationController;
        if (!navigationController) {
            return nil;
        }
        [navigationController pushViewController:viewController animated:animated];
    }

    return viewController;
}

- (UIViewController *)presentWithRouter:(NSString *)router
                             parameters:(NSDictionary *)parameters
                                    wrap:(BOOL)wrap
{
    return [self presentWithRouter:router fromViewController:nil parameters:parameters animated:YES wrap:wrap];
}

- (UIViewController *)presentWithRouter:(NSString *)router
                     fromViewController:(UIViewController *)from
                             parameters:(NSDictionary *)parameters
                               animated:(BOOL)animated
                                    wrap:(BOOL)wrap
{
    UIViewController *viewController = [self setViewControllerParametersWithRouter:router parameters:parameters];
    if (!from) {
        from = [UIViewController topMostViewController];
    }
    if (wrap) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [from presentViewController:navigationController animated:animated completion:nil];
    }else{
        [from presentViewController:viewController animated:animated completion:nil];
    }
    return viewController;
}

- (void)backToRouter:(NSString*)router
{
    UIViewController *currentViewController = [UIViewController topMostViewController];

    if (currentViewController.navigationController) {
        UINavigationController *navigationController = currentViewController.navigationController;

        if (!router) {
            if (navigationController.viewControllers.count > 1) {
                [navigationController popViewControllerAnimated:YES];
                return;
            }else{
                UIViewController *presentingViewController = currentViewController.presentingViewController;
                if (presentingViewController) {
                    [currentViewController dismissViewControllerAnimated:YES completion:nil];
                }
                return;
            }
        }

        for (UIViewController *viewController in navigationController.viewControllers) {
//            NSLog(@"view controller is %@\n params is %@",viewController, viewController.params);
            NSString *subRouter = viewController.params[@"route"];
            if ([router isEqualToString:subRouter]) {
                [navigationController popToViewController:viewController animated:YES];
                return;
            }
        }
        UIViewController *presentingViewController = currentViewController.presentingViewController;
        if (presentingViewController) {
            [currentViewController dismissViewControllerAnimated:NO completion:^{
                [self backToRouter:router];
            }];
        }
    }else{
        if (!router) {
            UIViewController *presentingViewController = currentViewController.presentingViewController;
            if (presentingViewController) {
                [currentViewController dismissViewControllerAnimated:YES completion:nil];
            }
            return;
        }

        NSString *subRouter = currentViewController.params[@"route"];
        if ([router isEqualToString:subRouter]) {

            return;
        }else{
            [currentViewController dismissViewControllerAnimated:NO completion:^{
                [self backToRouter:router];
            }];
        }
    }
}

@end

@implementation UIViewController (SXYRouter)

static char kAssociatedParamsObjectKey;

- (void)setParams:(NSDictionary *)paramsDictionary
{
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, paramsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params
{
    return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

@end


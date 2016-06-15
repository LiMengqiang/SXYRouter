//
//  ViewController.m
//  RouterExample
//
//  Created by wuhaizeng on 16/6/15.
//  Copyright © 2016年 cmss. All rights reserved.
//

#import "ViewController.h"
#import "RouterExample-swift.h"
#import "SXYRouter.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)doBtn:(id)sender {
    [[SXYRouter shared] pushWithRouter:@"SXY://UserViewController" parameters:@{@"xyz":@"1",@"vc2":@"sxyz2"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

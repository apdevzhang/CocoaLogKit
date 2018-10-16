//
//  ViewController.m
//  LogKitExample
//
//  Created by BANYAN on 2018/10/15.
//  Copyright © 2018年 BANYAN. All rights reserved.
//

#import "ViewController.h"
#import "LogKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLogTrace();    
    DLogVerbose(@"verbose level message");
    DLogDebug(@"debug level message");
    DLogInfo(@"info level message");
    DLogWarn(@"warn level message");
    DLogError(@"error level message");
}

@end

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
    
    DLogTrace();        // 输出当前控制器及函数名称
    
    [self printRandomLogMessage];
}

- (void)printRandomLogMessage {
    NSInteger randomLevel = arc4random() % 5;
    
    switch (randomLevel) {
        case 4:
            DLogError(@"this is a test error log message");
            break;
            
        case 3:
            DLogWarn(@"this is a test warn log message");
            break;
            
        case 2:
            DLogInfo(@"this is a test info log message");
            break;
            
        case 1:
            DLogDebug(@"this is a test debug log message");
            break;
            
        default:
            DLogVerbose(@"this is a test verbose log message");
            break;
    }
    
    NSTimeInterval logInterval = 1.f;
    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW, logInterval * NSEC_PER_SEC);
    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
        [self printRandomLogMessage];
    });
}

@end

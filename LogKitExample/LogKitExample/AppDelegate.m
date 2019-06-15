//
//  AppDelegate.m
//  LogKitExample
//
//  Created by BANYAN on 2018/10/15.
//  Copyright © 2018年 BANYAN. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLogKit/LogKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LogKit addTTYLogger];
    
    [LogKit addFileLogger];    
    
#ifdef DEBUG
    [LogKit addDashboardLogger];
#endif
    
    [LogKit setDefaultMailAddress:@[@"testMailAddress@gmail.com"]];
    
    [LogKit setDefaultLogPassword:@"101001"];
    
    return YES;
}

@end

// LogKitDebugView.m
//
// Copyright (c) 2018 BANYAN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LogKitDebugView.h"
#import "LogKit.h"

@implementation LogKitDebugView {
    UIView *backgroundView;
    UIView *navigationView;
    UISegmentedControl *segementedControl;
    UIButton *closeButton;
}

#pragma mark - Init
+ (LogKitDebugView *)sharedInstance {
    static LogKitDebugView *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LogKitDebugView alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    backgroundView = UIView.new;
    backgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:backgroundView];
    backgroundView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    navigationView = UIView.new;
    [backgroundView addSubview:navigationView];
    if ([self isIphoneX]) {
        navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 78);
    } else {
        navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54);
    }
    
    CAGradientLayer *gradientLayer = CAGradientLayer.layer;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:237. / 255 green:156. / 255 blue:119. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:234. / 255 green:133. / 255 blue:114. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:233. / 255 green:120. / 255 blue:114. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:232. / 255 green:115. / 255 blue:112. / 255 alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = navigationView.bounds;
    [navigationView.layer addSublayer:gradientLayer];
    
    closeButton = UIButton.new;
    [closeButton setBackgroundImage:[NSBundle log_closeButtonImage] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:closeButton];
    if ([self isIphoneX]) {
        closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 10, 45, 20, 20);
    } else {
        closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 10, 25, 20, 20);
    }
    
    NSArray *titleArray = @[[NSBundle log_localizedStringForKey:@"Clear Console"], [NSBundle log_localizedStringForKey:@"Mail Logs"]];
    
    NSDictionary *normalAttributes = @{
                                       NSFontAttributeName : [UIFont boldSystemFontOfSize:10.f],
                                       NSForegroundColorAttributeName : UIColor.whiteColor
                                       };
    
    segementedControl = [[UISegmentedControl alloc] initWithItems:titleArray];
    segementedControl.tintColor = UIColor.whiteColor;
    [segementedControl setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    segementedControl.momentary = YES;
    [segementedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [navigationView addSubview:segementedControl];
    if ([self isIphoneX]) {
        segementedControl.frame = CGRectMake((navigationView.frame.size.width - 160) / 2, 40, 160, 30);
    } else {
        segementedControl.frame = CGRectMake((navigationView.frame.size.width - 160) / 2, 20, 160, 30);
    }
    
    _consoleLoggerView = UIView.new;
    _consoleLoggerView.backgroundColor = UIColor.whiteColor;
    _consoleLoggerView.frame = CGRectMake(0, CGRectGetMaxY(navigationView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - navigationView.frame.size.height);
    [backgroundView addSubview:_consoleLoggerView];
    
    [LogKitConsoleLogger.sharedInstance showConsoleLoggerInView:_consoleLoggerView];
}

#pragma mark - Public Methods
- (void)open {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (void)close {
    [self removeFromSuperview];
}

#pragma mark - Action
- (void)closeButtonAction {
    [self close];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSInteger index = [sender selectedSegmentIndex];
    if (index == 0) {
        [LogKitConsoleLogger.sharedInstance clearConsoleLogger];
    } else if (index == 1) {
        [self removeFromSuperview];
        [LogKit sendLogFilesToMail];
    }
}

#pragma mark - Private Methods
- (BOOL)isIphoneX {
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        return CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size);
    } else {
        return NO;
    }
}

@end

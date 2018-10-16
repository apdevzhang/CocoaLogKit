// LogKitAssistiveButton.m
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

#import "LogKitAssistiveButton.h"
#import "LogKitDebugView.h"
#import "NSBundle+Logkit.h"

@implementation LogKitAssistiveButton {
    UIEdgeInsets _safeAreaInsets;
}

#pragma mark - Init
+ (LogKitAssistiveButton *)sharedInstance {
    static LogKitAssistiveButton *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = LogKitAssistiveButton.new;
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
    _safeAreaInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *localizabledAppVersion = [NSString stringWithFormat:@"%@ : %@", [NSBundle log_localizedStringForKey:@"APP Version"], appVersion];
    NSString *localizabledSystemVersion = [NSString stringWithFormat:@"%@ : %@", [NSBundle log_localizedStringForKey:@"System Version"], systemVersion];
    NSString *placeholderString = [NSString stringWithFormat:@"%@ \n %@", localizabledAppVersion, localizabledSystemVersion];        
    
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont systemFontOfSize:9.];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self setBackgroundImage:[NSBundle log_assistiveButtonImage] forState:UIControlStateNormal];
    [self setTitle:placeholderString forState:UIControlStateNormal];
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Public Methods
- (void)open {
    self.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 100, UIScreen.mainScreen.bounds.size.height - 100, 100, 50);
    
    [UIApplication.sharedApplication.delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - Action
- (void)buttonAction:(UIButton *)sender {
    [LogKitDebugView.sharedInstance open];
}

#pragma mark - Gesture
- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    UIWindow *parentWindow = UIApplication.sharedApplication.keyWindow;
    
    CGPoint translationPoint = [recognizer translationInView:parentWindow];

    CGPoint movedPoint = CGPointMake(recognizer.view.center.x + translationPoint.x, recognizer.view.center.y + translationPoint.y);
    
    // mark - top,left,bottom,right
    movedPoint.y = MAX(recognizer.view.frame.size.height / 2 + _safeAreaInsets.top, movedPoint.y);
    movedPoint.x = MAX(recognizer.view.frame.size.width / 2, movedPoint.x);
    movedPoint.y = MIN(parentWindow.frame.size.height - _safeAreaInsets.bottom - recognizer.view.frame.size.height / 2, movedPoint.y);
    movedPoint.x = MIN(parentWindow.frame.size.width - recognizer.view.frame.size.width / 2, movedPoint.x);
    
    recognizer.view.center = movedPoint;
    
    [recognizer setTranslation:CGPointZero inView:parentWindow];
}

@end

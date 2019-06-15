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

@interface LogKitDebugView ()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *navigationView;
@property (strong, nonatomic) UISegmentedControl *segementedControl;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIView *consoleLoggerView;
@end

@implementation LogKitDebugView

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
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit {
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.backgroundView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.backgroundView];
    
    [self.backgroundView addSubview:self.navigationView];
    self.navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self sizeAdaptation] ? 78 : 54);
   
    self.gradientLayer.frame = self.navigationView.bounds;
    [self.navigationView.layer addSublayer:self.gradientLayer];
    
    self.closeButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 44 - 10, [self sizeAdaptation] ? 45 : 20, 20, 20);
    [self.navigationView addSubview:self.closeButton];
    
    self.segementedControl.frame = CGRectMake((self.navigationView.frame.size.width - 160) / 2, [self sizeAdaptation] ? 40 : 20, 160, 30);
    [self.navigationView addSubview:self.segementedControl];
    
    self.consoleLoggerView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.navigationView.frame.size.height);
    [self.backgroundView addSubview:self.consoleLoggerView];
    
    [LogKitConsoleLogger.sharedInstance showConsoleLoggerInView:self.consoleLoggerView];
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
- (BOOL)sizeAdaptation {
    return UIApplication.sharedApplication.keyWindow.frame.size.height >= 812.f ? YES : NO;
}

#pragma mark - Setter/Getter
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = UIView.new;
        _backgroundView.backgroundColor = UIColor.whiteColor;
    }
    return _backgroundView;
}

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = UIView.new;
        _navigationView.backgroundColor = UIColor.whiteColor;
    }
    return _navigationView;
}

- (UISegmentedControl *)segementedControl {
    if (!_segementedControl) {
        _segementedControl = [[UISegmentedControl alloc] initWithItems:@[[NSBundle log_localizedStringForKey:@"Clear Console"], [NSBundle log_localizedStringForKey:@"Mail Logs"]]];
        _segementedControl.tintColor = UIColor.whiteColor;
        NSDictionary *normalAttributes = @{
                                           NSFontAttributeName : [UIFont boldSystemFontOfSize:10.f],
                                           NSForegroundColorAttributeName : UIColor.whiteColor
                                           };
        [_segementedControl setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
        _segementedControl.momentary = YES;
        [_segementedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segementedControl;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = UIButton.new;
        [_closeButton setBackgroundImage:[NSBundle log_closeButtonImage] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = CAGradientLayer.layer;
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:237. / 255 green:156. / 255 blue:119. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:234. / 255 green:133. / 255 blue:114. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:233. / 255 green:120. / 255 blue:114. / 255 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:232. / 255 green:115. / 255 blue:112. / 255 alpha:1].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

- (UIView *)consoleLoggerView {
    if (!_consoleLoggerView) {
        _consoleLoggerView = UIView.new;
        _consoleLoggerView.backgroundColor = UIColor.whiteColor;
    }
    return _consoleLoggerView;
}

@end

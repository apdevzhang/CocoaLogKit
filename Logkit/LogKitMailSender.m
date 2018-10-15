// LogKitMailSender.m
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

#import "LogKitMailSender.h"
#import "LogKit.h"

@interface LogKitMailSender () <MFMailComposeViewControllerDelegate>
@property (copy, nonatomic) SendMailComplete completeAction;
@property (strong, nonatomic) id keepInMemory;
@property (strong, nonatomic) MFMailComposeViewController *mailComposeViewController;
@end

@implementation LogKitMailSender

#pragma mark - Public Methods
+ (instancetype)sendMail:(SendMailBuilder)builder complete:(SendMailComplete)complete {
    return [[self alloc] initWithBuilder:builder complete:complete];
}

- (void)showFromViewController:(UIViewController *)viewController completion:(void(^)(void))completion {
    if ([MFMailComposeViewController canSendMail]) {
        [viewController presentViewController:self.mailComposeViewController animated:YES completion:completion];
        [self setKeepInMemory:self];
    }
}

#pragma mark - Private Methods
- (instancetype)initWithBuilder:(SendMailBuilder)builder complete:(SendMailComplete)complete {
    self = [super init];
    if (self) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        self.completeAction = complete;
        self.mailComposeViewController = mailComposeViewController;
        mailComposeViewController.mailComposeDelegate = self;
        builder(mailComposeViewController);
    }
    return self;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *message;
    switch (result) {
        case MFMailComposeResultCancelled: message = @"The user cancels the edit log file."; break;     
        case MFMailComposeResultSaved: message = @"The user saved the log file successfully."; break;
        case MFMailComposeResultSent: message = @"The user sent the log file successfully."; break;
        case MFMailComposeResultFailed: message = @"User attempts to save or send log file failed."; break;
        default: break;
    }
    DLogInfo(@"%@", [NSBundle log_localizedStringForKey:message]);
    self.completeAction(controller, result, error);
    self.keepInMemory = nil;
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

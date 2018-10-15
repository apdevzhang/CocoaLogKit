// LogKit.m
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

#import "LogKit.h"
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import "LogKitConsoleLogger.h"
#import "LogKitDebugView.h"
#import "LogKitAssistiveButton.h"
#if __has_include(<SSZipArchive/SSZipArchive.h>)
    #import <SSZipArchive/SSZipArchive.h>
#endif

static NSArray *_defaultMailAddress;
static NSString *_defaultLogPassword;

@implementation LogKit

#pragma mark - Init
+ (void)initialize {
#ifdef DEBUG
    [self addTTYLogger];
#endif
}

+ (id<DDLogFormatter>)logKitFormatter {
    static id<DDLogFormatter> _logKitFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _logKitFormatter = LogKitFormatter.new;
    });
    return _logKitFormatter;
}

#pragma mark - Public Methods
+ (void)addDashboardLogger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [DDLog addLogger:LogKitConsoleLogger.sharedInstance];
        [LogKitAssistiveButton.sharedInstance open];
    });
}

+ (void)addASLLogger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DDASLLogger *aslLogger = [DDASLLogger sharedInstance];
        aslLogger.logFormatter = [self logKitFormatter];
        [self addLogger:aslLogger];
    });
}

+ (void)addTTYLogger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
        ttyLogger.logFormatter = [self logKitFormatter];
        [self addLogger:ttyLogger];    
        
        char *xcode_colors = getenv("XcodeColors");
        if (xcode_colors && (strcmp(xcode_colors, "YES") == 0)) {
            [ttyLogger setForegroundColor:DLOG_VERBOSE_COLOR
                          backgroundColor:nil
                                  forFlag:DDLogFlagVerbose];
            [ttyLogger setForegroundColor:DLOG_DEBUG_COLOR
                          backgroundColor:nil
                                  forFlag:DDLogFlagDebug];
            [ttyLogger setForegroundColor:DLOG_INFO_COLOR
                          backgroundColor:nil
                                  forFlag:DDLogFlagInfo];
            [ttyLogger setForegroundColor:DLOG_WARNING_COLOR
                          backgroundColor:nil
                                  forFlag:DDLogFlagWarning];
            [ttyLogger setForegroundColor:DLOG_ERROR_COLOR
                          backgroundColor:nil
                                  forFlag:DDLogFlagError];
            [ttyLogger setColorsEnabled:YES];
        }
    });
}

+ (void)addFileLogger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DDFileLogger * fileLogger = [DDFileLogger new];
        fileLogger.rollingFrequency = 60 * 60 * 24 * 7;
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        fileLogger.maximumFileSize = 1024 * 1024 * 10;
        fileLogger.logFormatter = [self logKitFormatter];
        [self addLogger:fileLogger];
    });
}

+ (void)setDefaultMailAddress:(NSArray *)defaultMailAddress {
    _defaultMailAddress = defaultMailAddress;
}

+ (void)setDefaultLogPassword:(NSString *)defaultLogPassword {
    _defaultLogPassword = defaultLogPassword;
}

+ (void)sendLogFilesToMail {
    if (_defaultMailAddress.count == 0) {
        if (_defaultLogPassword.length == 0 || [_defaultLogPassword isKindOfClass:[NSNull class]]) {
            [self sendLogFilesToMail:nil password:nil];
        } else {
            [self sendLogFilesToMail:nil password:_defaultLogPassword];
        }
    } else {
        if (_defaultLogPassword.length == 0 || [_defaultLogPassword isKindOfClass:[NSNull class]]) {
            [self sendLogFilesToMail:_defaultMailAddress password:nil];
        } else {
            [self sendLogFilesToMail:_defaultMailAddress password:_defaultLogPassword];
        }
    }
}

#pragma mark - Private Methods
+ (NSArray<NSString *> *)logFileNames {
    DDFileLogger *fileLogger = DDFileLogger.new;
    NSArray<NSString *> *logFileNames = [fileLogger.logFileManager sortedLogFileNames];
    return logFileNames;
}

+ (NSString *)logDirectory {
    DDFileLogger *fileLogger = DDFileLogger.new;
    NSString *logDirectory = [fileLogger.logFileManager logsDirectory];
    return logDirectory;
}

+ (void)sendLogFilesToMail:(NSArray *)mailAddress password:(NSString *)password {
#if __has_include(<SSZipArchive/SSZipArchive.h>)
    NSString *logDirectory = [self logDirectory];
    NSArray *logFileNames = [self logFileNames];
    
    NSMutableArray *logFiles = NSMutableArray.new;
    [logFileNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *logFile = [logDirectory stringByAppendingPathComponent:obj];
        [logFiles addObject:logFile];
    }];
    
    NSString *logSaveDirectory = NSTemporaryDirectory();
    
    BOOL success;
    if (password.length == 0 || [password isKindOfClass:[NSNull class]]) {
       success = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip", [logSaveDirectory stringByAppendingPathComponent:[NSBundle log_localizedStringForKey:@"LogFile"]]] withFilesAtPaths:logFiles];
    } else {
       success = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip", [logSaveDirectory stringByAppendingPathComponent:[NSBundle log_localizedStringForKey:@"LogFile"]]] withFilesAtPaths:logFiles withPassword:password];
    }
    
    if (success) {
        DLogInfo(@"%@", [NSBundle log_localizedStringForKey:@"LogFile Compression Successed"]);
    } else {
        DLogError(@"%@", [NSBundle log_localizedStringForKey:@"LogFile Compression Failed"]);
    }
    
    Class mailClass = NSClassFromString((@"MFMailComposeViewController"));
    
    if (!mailClass) {
#ifdef DEBUG
        DAssert(mailClass, @"%@", [NSBundle log_localizedStringForKey:@"Sending mail within the application is not supported in the current system version"]);
#endif
        DLogError(@"%@", [NSBundle log_localizedStringForKey:@"Sending mail within the application is not supported in the current system version"]);
        return;
    }
    
    if (![mailClass canSendMail]) {
#ifdef DEBUG
        DAssert([mailClass canSendMail], @"%@", [NSBundle log_localizedStringForKey:@"The current user did not set up an email account"]);
#endif
        DLogError(@"%@", [NSBundle log_localizedStringForKey:@"The current user did not set up an email account"]);
        return;
    }
    
    NSData *logData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@.zip", [logSaveDirectory stringByAppendingPathComponent:[NSBundle log_localizedStringForKey:@"LogFile"]]]];
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    // appName:XX - LogFile (appVersionX.X、systemVersionX.X)
    NSString *mailContent = [NSString stringWithFormat:@"%@ - %@ (%@、%@)", [NSString stringWithFormat:@"%@:%@", [NSBundle log_localizedStringForKey:@"APP Name"], appName], [NSBundle log_localizedStringForKey:@"LogFile"], [NSString stringWithFormat:@"%@ %@", [NSBundle log_localizedStringForKey:@"APP Version"], appVersion], [NSString stringWithFormat:@"%@ %@", [NSBundle log_localizedStringForKey:@"System Version"], systemVersion]];
    
    LogKitMailSender *mailSender = [LogKitMailSender sendMail:^(MFMailComposeViewController *controller) {
        [controller setToRecipients:mailAddress];
        [controller setSubject:[NSBundle log_localizedStringForKey:@"LogFile"]];
        [controller setMessageBody:mailContent isHTML:NO];
        [controller addAttachmentData:logData mimeType:@"plain/zip" fileName:[[NSBundle log_localizedStringForKey:@"LogFile"] stringByAppendingString:@".zip"]];
    } complete:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [mailSender showFromViewController:UIApplication.sharedApplication.delegate.window.rootViewController completion:nil];
#else
    DLogError(@"%@ SSZipArchiver is required", THIS_METHOD);
#endif
}

@end

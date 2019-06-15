// LogKitFormatter.m
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

#import "LogKitFormatter.h"

@interface LogKitFormatter ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (copy, nonatomic) NSString *processName;
@end

@implementation LogKitFormatter

#pragma mark - Public Methods
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    return [NSString stringWithFormat:@"%@ %@[%@] %@ %@:%@ %@",
            [self.dateFormatter stringFromDate:logMessage.timestamp],
            self.processName,
            [self queueThreadLabelForLogMessage:logMessage],
            [self formatLogFlag:logMessage.flag],
            logMessage.fileName,
            @(logMessage.line),
            logMessage.message];
}

#pragma mark - Private Methods
- (NSString *)formatLogFlag:(DDLogFlag)logFlag {
    switch (logFlag) {
        case DDLogFlagError:
            return @"Error";
            break;
            
        case DDLogFlagWarning:
            return @"Warning";
            break;
            
        case DDLogFlagInfo:
            return @"Info";
            break;
            
        case DDLogFlagDebug:
            return @"Debug";
            break;
            
        default:
            return @"Verbose";
            break;
    }
}

#pragma mark - Setter/Getter
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = NSDateFormatter.new;
        [_dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    }
    return _dateFormatter;
}

- (NSString *)processName {
    if (!_processName) {
        _processName = NSProcessInfo.processInfo.processName;
    }
    return _processName;
}

@end

// LogKitMacros.h
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

#ifndef LogKitMacros_h
#define LogKitMacros_h

#import <DDLog.h>

#ifdef DEBUG
    static const int ddLogLevel = DDLogLevelVerbose;
#else
    static const int ddLogLevel = DDLogLevelError;
#endif

#define DLOG_VERBOSE_COLOR [DDColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0]
#define DLOG_DEBUG_COLOR [DDColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0]
#define DLOG_INFO_COLOR [DDColor colorWithRed:26.0/255.0 green:158.0/255.0 blue:4.0/255.0 alpha:1.0]
#define DLOG_WARNING_COLOR [DDColor colorWithRed:244.0/255.0 green:103.0/255.0 blue:8.0/255.0 alpha:1.0]
#define DLOG_ERROR_COLOR [DDColor redColor]

#define DLogError(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DLogWarn(frmt, ...)     LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DLogInfo(frmt, ...)     LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DLogDebug(frmt, ...)    LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define DLogVerbose(frmt, ...)  LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define DLogTrace()            DLogDebug(@"%s", __PRETTY_FUNCTION__)

#define DAssert(condition, frmt, ...) if (!(condition)) {     \
                                        NSString *description = [NSString stringWithFormat:frmt, ##__VA_ARGS__]; \
                                        DLogError(@"%@", description);                                          \
                                        NSAssert(NO, description);}

#define DAssertCondition(condition) DDAssert(condition, @"Condition not satisfied: %s", #condition)

#endif 


// LogKit.h
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

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "LogKitMacros.h"
#import "LogKitFormatter.h"
#import "LogKitMailSender.h"
#import "LogKitConsoleLogger.h"
#import "NSBundle+Logkit.h"

@interface LogKit : DDLog

///-------------------------
#pragma mark - Log
///-------------------------
/**!
 * @brief   Configure and add a recorder with console logs
*/
+ (void)addDashboardLogger;

/**!
 * @brief   Configure and add a DDASLLogger (Apple System Log)
*/
+ (void)addASLLogger;

/**!
 * @brief   Configure and add a DDFileLogger (log to a file)
*/
+ (void)addTTYLogger;

/**!
 * @brief   Send the log to the file (default for non debug builds)
*/
+ (void)addFileLogger;


///-------------------------
#pragma mark - Mail 
///-------------------------
/**!
 *
 * @brief   Sets the mailbox collection that receives log files (default is empty)
*/
+ (void)setDefaultMailAddress:(NSArray *)defaultMailAddress;

/**!
 * @brief   Set the password for the log file (default is empty)
*/
+ (void)setDefaultLogPassword:(NSString *)defaultLogPassword;

/**!
 * @brief   Send compressed log files to mailbox (default this method is not required if you add the perform the fun `[Logkit addDashboardLogger]`)
*/
+ (void)sendLogFilesToMail;

@end


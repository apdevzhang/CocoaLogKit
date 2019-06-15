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
 * @brief  Configure and add a recorder with console logs to APP -> （配置并添加日志记录至APP）
*/
+ (void)addDashboardLogger;

/**!
 * @brief  Configure and add a DDASLLogger (Apple System Log) -> （配置添加日志记录到苹果系统日志）
*/
+ (void)addASLLogger;

/**!
 * @brief  Configure and add a DDTTYLogger (Apple System Log and Xcode console),if the method has already been executed, there is no need to perform the function 'addASLLogger' -> （添加日志记录到苹果系统日志及Xcode控制台，如果此方法以及添加，则不再需要方法‘addASLLogger’）
*/
+ (void)addTTYLogger;

/**!
 * @brief  Send the log to the file (default for non debug builds),requied this method if you want send log files to mail -> （发生日志至文件，默认为DEBUG模式，如果期望发送日志到邮箱则需要此方法）
*/
+ (void)addFileLogger;

///-------------------------
#pragma mark - Mail 
///-------------------------
/**!
 *
 * @brief  Sets the mailbox collection that receives log files (default is empty) -> （设置接收日志文件的邮箱集合）
*/
+ (void)setDefaultMailAddress:(NSArray *)defaultMailAddress;

/**!
 * @brief  Set the password for the log file (default is empty) -> （设置日志文件解压密码，默认为空）
*/
+ (void)setDefaultLogPassword:(NSString *)defaultLogPassword;

/**!
 * @brief  Send compressed log files to mailbox (default this method is not required if you add the perform the function `[Logkit addDashboardLogger]`) -> （发生压缩日志文件至邮箱，当添加函数`[Logkit addDashboardLogger]`后此方法才生效）
*/
+ (void)sendLogFilesToMail;

@end


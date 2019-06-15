// NSBundle+Logkit.m
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

#import "NSBundle+Logkit.h"

@implementation NSBundle (Logkit)

#pragma mark - Init
+ (instancetype)logkitBundle {
    static NSBundle *logkitBundle = nil;
    if (logkitBundle == nil) {
        logkitBundle = [self bundleWithName:@"Logkit.bundle"];
    }
    return logkitBundle;
}

#pragma mark - Public Methods
+ (NSString *)log_localizedStringForKey:(NSString *)key {
    return [self log_localizedStringForKey:key value:nil];
}

+ (NSString *)log_localizedStringForKey:(NSString *)key value:(NSString *)value {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            language = @"zh-Hans";
        } else {
            language = @"en";
        }
        bundle = [NSBundle bundleWithPath:[[NSBundle logkitBundle] pathForResource:language ofType:@"lproj"]];
    }
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (UIImage *)log_assistiveButtonImage {
    static UIImage *assistiveButtonImage = nil;
    
    if (assistiveButtonImage == nil) {
        assistiveButtonImage = [[UIImage imageWithContentsOfFile:[[self logkitBundle] pathForResource:@"log_assistive_btn@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    
    return assistiveButtonImage;
}

+ (UIImage *)log_closeButtonImage {
    static UIImage *closeButtonImage = nil;
    
    if (closeButtonImage == nil) {
        closeButtonImage = [[UIImage imageWithContentsOfFile:[[self logkitBundle] pathForResource:@"log_close_btn@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    }
    
    return closeButtonImage;
}

#pragma mark - Private Methods
+ (NSBundle *)bundleWithName:(NSString *)name {
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    
    NSString *logKitBundlePath = [mainBundlePath stringByAppendingPathComponent:name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:logKitBundlePath]) {
        return [NSBundle bundleWithPath:logKitBundlePath];
    }
    return nil;
}

@end

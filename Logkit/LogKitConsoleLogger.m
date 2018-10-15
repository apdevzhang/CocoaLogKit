// LogKitConsoleLogger.m
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

#import "LogKitConsoleLogger.h"
#import "LogKitFormatter.h"

@interface LogKitConsoleLogger () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
    NSMutableArray *messages;
}
@end

@implementation LogKitConsoleLogger

#pragma mark - Synthesize
@synthesize logFormatter;
- (void)logMessage:(DDLogMessage *)logMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->messages addObject:logMessage];
        
        BOOL scroll = NO;
        
        if (self->tableView.contentOffset.y + self->tableView.bounds.size.height >= self->tableView.contentSize.height) {
            scroll = YES;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self->messages.count - 1 inSection:0];
        [self->tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        if (scroll) {
            [self->tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

#pragma mark - Init
+ (LogKitConsoleLogger *)sharedInstance {
    static LogKitConsoleLogger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = LogKitConsoleLogger.new;
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
    messages = NSMutableArray.new;
    
    tableView = UITableView.new;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColor.whiteColor;
    tableView.alpha = 0.8;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *messageText = [self textOfMessageForIndexPath:indexPath];
    
    CGFloat messageMargin = 10.0;
    
    return ceil([messageText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [self fontOfMessage]} context:nil].size.height + messageMargin);
}

#pragma mark - Public Methods
- (void)showConsoleLoggerInView:(UIView *)view {
    [view addSubview:tableView];
    UITableView *consoleLoggerTableView = tableView;
    consoleLoggerTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[consoleLoggerTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(consoleLoggerTableView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[consoleLoggerTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(consoleLoggerTableView)]];
}

- (void)clearConsoleLogger {
    [messages removeAllObjects];
    [tableView reloadData];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    DDLogMessage *message = messages[indexPath.row];
    switch (message.flag) {
        case DDLogFlagError: cell.textLabel.textColor = DLOG_ERROR_COLOR; break;
        case DDLogFlagWarning: cell.textLabel.textColor = DLOG_WARNING_COLOR; break;
        case DDLogFlagInfo: cell.textLabel.textColor = DLOG_INFO_COLOR; break;
        case DDLogFlagDebug: cell.textLabel.textColor = DLOG_DEBUG_COLOR; break;
        case DDLogFlagVerbose: cell.textLabel.textColor = DLOG_VERBOSE_COLOR; break;
        default: cell.textLabel.textColor = UIColor.whiteColor; break;
    }
    cell.textLabel.text = [self textOfMessageForIndexPath:indexPath];
    cell.textLabel.font = [self fontOfMessage];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = UIColor.clearColor;
}

- (NSString *)textOfMessageForIndexPath:(NSIndexPath *)indexPath {
    DDLogMessage *message = messages[indexPath.row];
    
    LogKitFormatter *formatter = LogKitFormatter.new;
    
    return [formatter formatLogMessage:message];
}

- (UIFont *)fontOfMessage {
    return [UIFont boldSystemFontOfSize:9];
}

@end

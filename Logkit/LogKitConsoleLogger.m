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

@interface LogKitConsoleLogger () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messages;
@end

@implementation LogKitConsoleLogger

@synthesize logFormatter;

#pragma mark - Init
+ (LogKitConsoleLogger *)sharedInstance {
    static LogKitConsoleLogger *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = LogKitConsoleLogger.new;
    });
    return sharedInstance;
}

#pragma mark - Delegate
#pragma mark   UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark   UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDLogMessage *message = self.messages[indexPath.row];
    
    CGFloat messageMargin = 10.0;
    
    return ceil([[self textOfMessage:message] boundingRectWithSize:CGSizeMake(tableView.bounds.size.width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [self fontOfMessage]} context:nil].size.height + messageMargin);
}

#pragma mark - Public Methods
- (void)showConsoleLoggerInView:(UIView *)view {
    [view addSubview:self.tableView];
    
    UITableView *consoleLoggerTableView = self.tableView;
    
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[consoleLoggerTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(consoleLoggerTableView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[consoleLoggerTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(consoleLoggerTableView)]];
}

- (void)clearConsoleLogger {
    [self.messages removeAllObjects];
    
    [self.tableView reloadData];
}

#pragma mark - Private Methods
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    DDLogMessage *message = self.messages[indexPath.row];

    cell.textLabel.text = [self textOfMessage:message];
    cell.textLabel.font = [self fontOfMessage];
    cell.textLabel.textColor = [self colorOfMessage:message.flag];
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = UIColor.clearColor;
}

- (void)logMessage:(DDLogMessage *)logMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messages addObject:logMessage];
        
        BOOL scroll = (self.tableView.contentOffset.y + self.tableView.bounds.size.height >= self.tableView.contentSize.height) ? YES : NO;
            
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
      
        scroll ?: [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

#pragma mark   Message Attribute
- (NSString *)textOfMessage:(DDLogMessage *)message {
    LogKitFormatter *formatter = LogKitFormatter.new;
    
    return [formatter formatLogMessage:message];
}

- (UIFont *)fontOfMessage {
    return [UIFont boldSystemFontOfSize:10.];
}

- (UIColor *)colorOfMessage:(DDLogFlag)logFlag {
    switch (logFlag) {
        case DDLogFlagError:
            return DLOG_ERROR_COLOR;
            break;
            
        case DDLogFlagWarning:
            return DLOG_WARNING_COLOR;
            break;
            
        case DDLogFlagInfo:
            return DLOG_INFO_COLOR;
            break;
            
        case DDLogFlagDebug:
            return DLOG_DEBUG_COLOR;
            break;
            
        case DDLogFlagVerbose:
            return DLOG_VERBOSE_COLOR;
            break;
            
        default:
            return UIColor.whiteColor;
            break;
    }
}
    
#pragma mark - Setter/Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.alpha = 0.8;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = NSMutableArray.new;
    }
    return _messages;
}

@end

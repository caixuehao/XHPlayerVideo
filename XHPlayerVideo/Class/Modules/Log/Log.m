//
//  Log.m
//  XHPlayerVideo
//
//  Created by cxh on 16/9/19.
//  Copyright © 2016年 C. All rights reserved.
//

#import "Log.h"

@implementation Log

+(void)Log:(NSString*)log{
    NSLog(@"%@",log);
   // [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:@"XHPlayerVideoLog.plist"];
        NSMutableArray* logArr = [[NSMutableArray alloc] initWithContentsOfFile:path];
        if (logArr == nil) logArr = [[NSMutableArray alloc] init];
        [logArr addObject:log];
        [logArr writeToFile:path atomically:YES];
    //}];
}

@end

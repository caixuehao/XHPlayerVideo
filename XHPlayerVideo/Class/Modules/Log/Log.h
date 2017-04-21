//
//  Log.h
//  XHPlayerVideo
//
//  Created by cxh on 16/9/19.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LOG(log) [Log Log:log];

@interface Log : NSObject

+(void)Log:(NSString*)log;

@end

//
//  PlayListWindow.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayListWindow : NSWindow

@property(nonatomic)BOOL isDisplay;

+(instancetype)share;

//显示 或者 关闭取相反的状态
+(void)display;

//+(void)hide;

@end

//
//  ControllerView.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//

#import "ControllerView.h"
#import <Masonry.h>
#import "Macro.h"
@implementation ControllerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    //画圆角
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,0,0) xRadius:5 yRadius:5];
    [CColor(0, 0, 0, 0.7) setFill];
    [bezierPath fill];
}

@end

//
//  VideoCellSelectedView.m
//  XHPlayerVideo
//
//  Created by cxh on 16/9/2.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoCellSelectedView.h"
#import "Macro.h"

@implementation VideoCellSelectedView
-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //画圆角
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,0,0) xRadius:5 yRadius:5];
    [bezierPath setLineWidth:5];
    [CColor(255, 225, 15, 0.7) setStroke];
    [bezierPath stroke];
    //渐变
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:CColor(0, 0, 0, 1) endingColor:CColor(0, 0, 0, 0.3)];
    NSBezierPath* bezierPath2 = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,0,0) xRadius:5 yRadius:5];
    [gradient drawInBezierPath:bezierPath2 angle:90];

}

@end

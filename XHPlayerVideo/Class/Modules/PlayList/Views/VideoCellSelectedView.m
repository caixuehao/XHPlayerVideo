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
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    float height = self.bounds.size.height;
    float width = self.bounds.size.width;
    
    //画圆角边框
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,0,0) xRadius:5 yRadius:5];
    [bezierPath setLineWidth:15.0];
    [CColor(255, 225, 15, 0.7) setStroke];
    [bezierPath stroke];
    
    

    float radius = 50.0;
    NSBezierPath* bezierPaht2 = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(width*0.5-radius, height*0.5-radius, radius*2.0, radius*2.0)];
    [bezierPaht2 setLineWidth:10.0];
    [CColor(155, 225, 15, 1) setStroke];
    [bezierPaht2 stroke];
    
    
    
    //渐变三角
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:CColor(125, 25, 255, 0.7) endingColor:CColor(205, 255, 125, 0.7)];
    NSBezierPath* bezierPath3 = [NSBezierPath bezierPath];
    [bezierPath3 moveToPoint:NSMakePoint(width*0.5-20.0, height*0.5-35)];//起点
    [bezierPath3 lineToPoint:NSMakePoint(width*0.5-20.0, height*0.5+35)];
    [bezierPath3 lineToPoint:NSMakePoint(width*0.5+45, height*0.5)];
    [bezierPath3 lineToPoint:NSMakePoint(width*0.5-20.0, height*0.5-35)];
    [bezierPath3 closePath];
    [gradient drawInBezierPath:bezierPath3 angle:170];
}

@end

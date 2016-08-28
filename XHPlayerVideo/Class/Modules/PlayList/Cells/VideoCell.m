//
//  VideoCell.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoCell.h"
#import "Macro.h"

@implementation VideoCell
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    VideoCell *cellCopy = [super copyWithZone:zone];
 
    return cellCopy;
}

- (void)setVideo:(VideoModel *)video{
    _video =  video;
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    //[super drawWithFrame:cellFrame inView:controlView];
    //背景
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(cellFrame,0,2) xRadius:0 yRadius:0];
    [CColor(0, 0, 0, 0.7) setFill];
    [bezierPath fill];
    //渐变
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:CColor(255, 255, 255, 1) endingColor:CColor(255, 255, 255, 0.2)];
    NSBezierPath* bezierPath2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(cellFrame.origin.x, cellFrame.origin.y+VideoCellHeight-30, 300, 29) xRadius:0 yRadius:0];
    [gradient drawInBezierPath:bezierPath2 angle:90];
    //文件名字
    NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor blackColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:13], NSFontAttributeName, nil];
    [[self.video.path lastPathComponent] drawAtPoint:NSMakePoint(cellFrame.origin.x, cellFrame.origin.y+VideoCellHeight-30) withAttributes:primaryTextAttributes];
}
@end

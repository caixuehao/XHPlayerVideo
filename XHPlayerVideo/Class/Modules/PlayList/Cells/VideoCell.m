//
//  VideoCell.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoCell.h"
#import "Macro.h"

#import <AVFoundation/AVFoundation.h>

@implementation VideoCell{
    
}
-(instancetype)init{
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    VideoCell *cellCopy = [super copyWithZone:zone];
    cellCopy.video = self.video;
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
    [CColor(255, 255, 255, 0.7) setFill];
    [bezierPath fill];
    //画图
//    NSImage* coverImage = [self getCoverImage];
//    [coverImage drawInRect:NSInsetRect(cellFrame,0,2)];
    //渐变
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:CColor(0, 0, 0, 1) endingColor:CColor(0, 0, 0, 0.2)];
    NSBezierPath* bezierPath2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(cellFrame.origin.x, cellFrame.origin.y+VideoCellHeight-20, 300, 19) xRadius:0 yRadius:0];
    [gradient drawInBezierPath:bezierPath2 angle:90];
    //文件名字
    NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSColor whiteColor], NSForegroundColorAttributeName, [NSFont systemFontOfSize:13], NSFontAttributeName, nil];
    [[self.video.path lastPathComponent] drawAtPoint:NSMakePoint(cellFrame.origin.x, cellFrame.origin.y+VideoCellHeight-20) withAttributes:primaryTextAttributes];

}

- (NSImage*)getCoverImage{
    NSImage *coverImage;
    //视频路径URL
    NSURL *fileURL = [NSURL fileURLWithPath:self.video.path];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (image) {
        coverImage = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(VideoCellWidth, VideoCellHeight)];
    }else{
        coverImage = [NSImage imageNamed:@"defaultCover.png"];
    }
    CGImageRelease(image);
    
    return coverImage;
}
@end

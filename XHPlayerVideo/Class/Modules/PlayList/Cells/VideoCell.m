//
//  VideoCell.m
//  XHPlayerVideo
//
//  Created by C on 16/8/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoCell.h"
#import "VideoCellSelectedView.h"
#import "Macro.h"

@interface VideoCell()<LoadThumbnailDelegate>

@end

@implementation VideoCell{
    NSTextField* titlelabel;
    NSImageView* coverImageView;
    VideoCellSelectedView* selectedView;
}

-(instancetype)init{
    self = [super init];
    if (self) {

        coverImageView = ({
            NSImageView* image = [[NSImageView alloc] init];
            image.frame = NSMakeRect(0, 0, VideoCellWidth, VideoCellHeight);
            [self addSubview:image];
            image.image =  [NSImage imageNamed:@"defaultCover.png"];
            image;
        });
        
        titlelabel = ({
            NSTextField* tf = [[NSTextField alloc] init];
            tf.frame = NSMakeRect(0, 0, 300, 40);
            [tf setBezeled:NO];
            //[tf setDrawsBackground:NO];
            [tf setEditable:NO];
            [tf setSelectable:NO];
            [tf setTextColor:CColor(255, 255, 255, 1)];
            [tf setBackgroundColor:CColor(0, 0, 0, 0.6)];
            tf.maximumNumberOfLines = 2;
            [self addSubview:tf];
            tf;
        });
        
//        selectedView = ({
//            VideoCellSelectedView *view = [[VideoCellSelectedView alloc] initWithFrame:self.bounds];
//            [self addSubview:view];
//            view;
//        });
    }
    return self;
}

- (void)dealloc{
//    NSLog(@"%s",__FUNCTION__);
}

- (id)copyWithZone:(NSZone *)zone
{
    VideoCell *cellCopy = [[VideoCell alloc] init];

    cellCopy.video = self.video;
    return cellCopy;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    //画圆角
//    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds,0,0) xRadius:5 yRadius:5];
//    [CColor(255, 225, 15, 0.7) setFill];
//    [bezierPath fill];
//    //渐变
//    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor:CColor(0, 0, 0, 1) endingColor:CColor(0, 0, 0, 0.3)];
//    NSBezierPath* bezierPath2 = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 2, 300, 39) xRadius:3 yRadius:3];
//    [gradient drawInBezierPath:bezierPath2 angle:90];

}





- (void)setVideo:(VideoModel *)video{
    _video = video;
 
    titlelabel.stringValue = [video.path lastPathComponent];
    if (video.thumbnailPath.length) {
        coverImageView.image = [[NSImage alloc] initWithContentsOfFile:video.thumbnailPath];
    }else{
         NSLog(@"开始加载封面");
        [self.video loadThumnbnail:self];
    }
  
}

#pragma LoadThumbnailDelegate

-(void)thumbnailLoaded:(NSImage *)thumbnail{
    NSLog(@"加载成功");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         if (thumbnail) coverImageView.image = thumbnail;
    }];
}

@end

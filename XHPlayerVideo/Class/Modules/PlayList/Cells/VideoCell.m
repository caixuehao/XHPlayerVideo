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
    if ([_video isCurrentVideo]) {
        selectedView = ({
            VideoCellSelectedView *view = [[VideoCellSelectedView alloc] initWithFrame:NSMakeRect(0, 0, VideoCellWidth, VideoCellHeight)];
            [self addSubview:view];
            view;
        });
    }
}


#pragma Actions
- (void)rightMouseDown:(NSEvent *)theEvent{
    NSLog(@"1234");
}


#pragma LoadThumbnailDelegate

-(void)thumbnailLoaded:(NSImage *)thumbnail{
    NSLog(@"加载成功");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         if (thumbnail) coverImageView.image = thumbnail;
    }];
}

@end

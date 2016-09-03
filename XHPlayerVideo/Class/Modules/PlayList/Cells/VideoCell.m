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
    NSButton* removeBtn;//右键事件获取不到，只能出此下策http://www.xuebuyuan.com/2139444.html
    VideoCellSelectedView* selectedView;
}

-(instancetype)init{
    self = [super initWithFrame: NSMakeRect(0, 0, VideoCellWidth, VideoCellHeight)];
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
        
        removeBtn = ({
            NSButton* btn = [[NSButton alloc] init];
            btn.frame = NSMakeRect(VideoCellWidth-5 - 40, VideoCellHeight -5-20, 40, 20);
            [btn setTitle:@"删除"];
            btn.target = self;
            [btn setAction:@selector(removeVideo)];
            [self addSubview:btn];
            btn;
        });
       
    }
    return self;
}
- (void)viewDidMoveToSuperview {
    if(self.superview == nil) return;
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
    if ([[NSFileManager defaultManager] fileExistsAtPath:video.path] == NO) {
         coverImageView.image = [NSImage imageNamed:@"videoNotExist"];
    }else if(video.thumbnailPath.length) {
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
//不知为何获取不到消息
- (void)rightMouseDown:(NSEvent *)theEvent{
//    [super rightMouseDown:theEvent];
    NSLog(@"1234");
}

-(void)removeVideo{
    if([self.video isCurrentVideo]){
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"删除"];
        [alert addButtonWithTitle:@"取消"];
        [alert setMessageText:@"正在播放"];
        [alert setInformativeText:@"这个视频正在播放，如果删除将会停止。"];
        [alert setAlertStyle:NSWarningAlertStyle];
//        [alert runModal];
        //单元格生存周期太短videoModel里面了。
        [alert beginSheetModalForWindow:_window modalDelegate:self.video
                         didEndSelector:@selector(removeAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    }else{
        [self.video remove];
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

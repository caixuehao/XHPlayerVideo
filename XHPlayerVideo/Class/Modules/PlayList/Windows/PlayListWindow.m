//
//  PlayListWindow.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//
#import "Macro.h"

#import "PlayListWindow.h"
#import "PlayListViewController.h"
//#import "PlayerVideoWindowController.h"


static PlayListWindow* sharePlayListWindow;
@implementation PlayListWindow

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _isDisplay = NO;
        [self setReleasedWhenClosed:NO];//设置关闭时不释放
        
        self.titlebarAppearsTransparent = YES; // 标题栏透明
        [self setStyleMask:NSResizableWindowMask|NSTitledWindowMask|NSFullSizeContentViewWindowMask];
        [self setMovableByWindowBackground:YES];
       
       
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];

        PlayListViewController* playlist = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:[NSBundle mainBundle]];
        [self setContentViewController:playlist];
        
        [self setMaxSize:NSMakeSize(VideoCellWidth+20, SSize.height)];
        [self setMinSize:NSMakeSize(VideoCellWidth+20, VideoCellHeight+40)];
        
    }
    return self;
}


@end

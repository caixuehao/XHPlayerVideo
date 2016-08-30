//
//  PlayListWindow.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListWindow.h"
#import "PlayListViewController.h"
#import "PlayerVideoWindowController.h"

static PlayListWindow* sharePlayListWindow;
@implementation PlayListWindow


+(void)show{
    if (sharePlayListWindow == nil) {
        sharePlayListWindow= [[PlayListWindow alloc] init];
        [[PlayerVideoWindowController getPlayerVideoWindowController].window addChildWindow:sharePlayListWindow ordered:NSWindowAbove];
    }
}


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

-(instancetype)init{
    self = [super init];
    if (self) {
        CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;        
        [self setStyleMask:NSBorderlessWindowMask];//设置无边框
//        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];//隐藏按钮
//        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [self setMovableByWindowBackground:YES];
        [self setFrameOrigin:NSMakePoint(playerVideoFrame.origin.x+playerVideoFrame.size.width, playerVideoFrame.origin.y)];
        
        PlayListViewController* playlist = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:[NSBundle mainBundle]];
        [self setContentViewController:playlist];
        
    }
    return self;
}


@end

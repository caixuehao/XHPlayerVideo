//
//  PlayerVideoWC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//
#import <Masonry.h>

#import "PlayerVideoWindowController.h"


@interface PlayerVideoWindowController ()<NSWindowDelegate>

@end
static PlayerVideoWindowController* playerVideoWindowController;
@implementation PlayerVideoWindowController{

}

+(PlayerVideoWindowController*)getPlayerVideoWindowController{
    return playerVideoWindowController;
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    playerVideoWindowController = nil;
}
-(void)awakeFromNib
{
      playerVideoWindowController = self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.

    self.window.delegate = self;
    
    [self loadSubViews];
    [self loadActions];
   
    
}

}

#pragma NSWindowDelegate
//将要全屏
- (NSSize)window:(NSWindow *)window willUseFullScreenContentSize:(NSSize)proposedSize{
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:NO];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:NO];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:NO];
    return [NSScreen mainScreen].frame.size;
}


//将要最大化 或者 将要取消最大化
- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame{
    return YES;
}

//窗口取消全屏
- (nullable NSArray<NSWindow *> *)customWindowsToExitFullScreenForWindow:(NSWindow *)window{
    NSLog(@"123");
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    return nil;
}
@end

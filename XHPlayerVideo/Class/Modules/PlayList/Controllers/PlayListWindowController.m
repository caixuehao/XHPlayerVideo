//
//  PlayListWindowController.m
//  XHPlayerVideo
//
//  Created by cxh on 16/9/1.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListWindowController.h"
#import "PlayListWindow.h"

#import "Macro.h"

@interface PlayListWindowController ()

@end

@implementation PlayListWindowController{
    PlayListWindow* playListWindow;
}
- (instancetype)init{
    playListWindow = [[PlayListWindow alloc] init];
    self = [super initWithWindow:playListWindow];
    if (self) {
       
    }
    return self;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma Actions
-(void)displayWindow:(NSRect)playerFrame{
 
 [playListWindow makeKeyAndOrderFront:nil];
//控制是否跟随
// [[PlayerVideoWindowController getPlayerVideoWindowController].window addChildWindow:sharePlayListWindow ordered:NSWindowAbove];
 [self.window setFrame:NSMakeRect(playerFrame.origin.x+playerFrame.size.width, playerFrame.origin.y,VideoCellWidth+20 , playerFrame.size.height) display:YES];
    playListWindow.isDisplay = YES;
}

-(void)displaySwitch:(NSRect)playerFrame{
    if (playListWindow.isDisplay){//&&playListWindow.visible
        [self hideWindow];
    }else {
        [self displayWindow:playerFrame];
    }
}

-(void)hideWindow{
    [playListWindow close];
    playListWindow.isDisplay = NO;
}

@end

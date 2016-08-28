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

@implementation PlayListWindow

+(void)show{
    
    PlayListWindow* window = [[PlayListWindow alloc] init];

    [[PlayerVideoWindowController getPlayerVideoWindowController].window addChildWindow:window ordered:NSWindowAbove];
   
}



-(instancetype)init{
    self = [super init];
    if (self) {
        CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;        
        [self setStyleMask:NSTitledWindowMask|NSMiniaturizableWindowMask];
        [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [self setMovableByWindowBackground:YES];
        
        [self setFrameOrigin:NSMakePoint(playerVideoFrame.origin.x+playerVideoFrame.size.width+10, playerVideoFrame.origin.y)];
        
        PlayListViewController* playlist = [[PlayListViewController alloc] initWithNibName:@"PlayListViewController" bundle:[NSBundle mainBundle]];
        [self setContentViewController:playlist];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow:) name:NSWindowWillCloseNotification object:self];
        self.title = @"1234";
    }
    return self;
}
#pragma NSWindowDelegate--


-(void)closeWindow:(id)sender{

}
@end

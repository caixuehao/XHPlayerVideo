//
//  PlayerVideoWC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayerVideoWindowController.h"

@interface PlayerVideoWindowController ()

@end
static PlayerVideoWindowController* playerVideoWindowController;
@implementation PlayerVideoWindowController

+(PlayerVideoWindowController*)getPlayerVideoWindowController{
    return playerVideoWindowController;
}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    playerVideoWindowController = nil;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    //CGSize size = [NSScreen mainScreen].frame.size;
    //设置初始位置
    playerVideoWindowController = self;
    [self.window setStyleMask:NSBorderlessWindowMask];//设置无边框
    [self.window setReleasedWhenClosed:NO];//设置关闭时不释放
    [self.window setContentSize:NSMakeSize(1000, 618)];
//    [self.window becomeMainWindow];
    [self.window setMovableByWindowBackground:YES];
     self.window.minSize = NSMakeSize(485, 273);
    [self.window center];
    
}

@end

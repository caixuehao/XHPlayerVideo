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
static NSWindowController* playerVideoWindowController;
@implementation PlayerVideoWindowController

+(NSWindowController*)getPlayerVideoWindowController{
    return playerVideoWindowController;
}

-(void)dealloc{
    playerVideoWindowController = nil;
}
- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    //CGSize size = [NSScreen mainScreen].frame.size;
    //设置初始位置
    playerVideoWindowController = self;
    [self.window setContentSize:NSMakeSize(1000, 618)];
//    [self.window becomeMainWindow];
    
    [self.window center];
}

@end

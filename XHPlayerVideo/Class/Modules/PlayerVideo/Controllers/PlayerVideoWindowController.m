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

@implementation PlayerVideoWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    //设置初始位置
    
    [self.window setContentSize:NSMakeSize(1000, 618)];
    CGSize size = [NSScreen mainScreen].frame.size;
    
    [self.window setFrameOrigin:NSMakePoint((size.width-1000)/2, (size.height-618)/2)];
}

@end

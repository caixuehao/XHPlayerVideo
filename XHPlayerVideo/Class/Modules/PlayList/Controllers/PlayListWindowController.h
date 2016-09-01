//
//  PlayListWindowController.h
//  XHPlayerVideo
//
//  Created by cxh on 16/9/1.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PlayListWindowController : NSWindowController

-(void)displayWindow:(NSRect)playerFrame;

-(void)displaySwitch:(NSRect)playerFrame;

-(void)hideWindow;

@end

//
//  PlayerVideoWC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//
#import <Masonry.h>

#import "PlayerVideoWindowController.h"
#import "PlayerVideoViewController.h"


@interface PlayerVideoWindowController ()<NSWindowDelegate>

@end
static PlayerVideoWindowController* playerVideoWindowController;
@implementation PlayerVideoWindowController{
    PlayerVideoViewController* playerVideoVC;
}

+(PlayerVideoWindowController*)getPlayerVideoWindowController{
    return playerVideoWindowController;
}


//-(instancetype)init{
//    self = [super initWithWindow:[[NSWindow alloc] init]];
//    if (self) {
//        playerVideoVC = [[PlayerVideoViewController alloc] initWithNibName:@"PlayerVideoViewController" bundle:[NSBundle mainBundle]];
//        [self.window setContentViewController:playerVideoVC];
//    }
//    return self;
//}

-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    playerVideoWindowController = nil;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    playerVideoVC = [[PlayerVideoViewController alloc] initWithNibName:@"PlayerVideoViewController" bundle:[NSBundle mainBundle]];
    [self.window setContentViewController:playerVideoVC];
    
    
    playerVideoWindowController = self;
    [self loadSubViews];
    [self loadActions];
}

-(void)loadActions{
    self.window.delegate = self;
}


#pragma NSWindowDelegate
//将要全屏
- (NSSize)window:(NSWindow *)window willUseFullScreenContentSize:(NSSize)proposedSize{
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:NO];//取消全屏按钮
    return [NSScreen mainScreen].frame.size;
}


//将要最大化 或者 将要取消最大化
- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame{
    return YES;
}

//窗口取消全屏
- (nullable NSArray<NSWindow *> *)customWindowsToExitFullScreenForWindow:(NSWindow *)window{
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    return nil;
}

//loadSubViews
-(void)loadSubViews{
    
    self.window.titlebarAppearsTransparent = YES; // 标题栏透明
    
    //设置无边框http://blog.csdn.net/leer168/article/details/13021251
    [self.window setStyleMask:NSResizableWindowMask|NSTitledWindowMask|NSFullSizeContentViewWindowMask];
    
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    
//    self.window.acceptsMouseMovedEvents = YES;//鼠标拖拽
    [self.window setReleasedWhenClosed:NO];//设置关闭时不释放
    [self.window setContentSize:NSMakeSize(485, 273)];
    
    self.window.minSize = NSMakeSize(485, 273);
    [self.window center];

}
@end

//
//  AppDelegate.m
//  XHPlayerVideo
//
//  Created by C on 16/8/26.
//  Copyright © 2016年 C. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoModel.h"
#import "Macro.h"
#import "PlayerVideoWindowController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    PlayerVideoWindowController* playerVideo = [[PlayerVideoWindowController alloc] init];
//    [playerVideo showWindow:self];
//    [playerVideo.window makeKeyAndOrderFront:nil];
   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//点击Dock重新打开主窗口
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
//    if (!flag){//是否有可见窗口
        //主窗口显示
//        [NSApp activateIgnoringOtherApps:NO];
        [[PlayerVideoWindowController getPlayerVideoWindowController].window makeKeyAndOrderFront:self];
//    }

    
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    NSLog(@"打开文件:%@",filename);

    //创建通知并发送
    VideoModel* video = [[VideoModel alloc] initWithPath:filename];
    [video play];
    
    return YES;
}

@end

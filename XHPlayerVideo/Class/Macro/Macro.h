//
//  Macro.h
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define SSize   [NSScreen mainScreen].frame.size

#define VideoCellWidth 300
#define VideoCellHeight 186

#pragma mark - Color

#define CColor(r,g,b,a) [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CColorRGB [NSColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]


#pragma Notification 

#define SendNotification(name,userinfo)  [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:name object:nil userInfo:userinfo]]

#define PlayVideoNotification @"PlayVideoNotification" //播放视频  ｛@“video”：VideoModel(要播放的视频)｝
#define StopPlayVideoNotification @"StopPlayVideoNotification"//停止播放视频 

#define PlayNextVideoNotification @"PlayNextVideoNotification" //播放下一个视频
#define PlayLastVideoNotification @"PlayLastVideoNotification" //播放上一个视频
#define PLayEndNotification @"PLayEndNotification"  //播放结束

#endif /* Macro_h */

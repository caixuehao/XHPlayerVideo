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

#pragma NSString
#define PlayVideoNotification @"PlayVideoNotification"

#endif /* Macro_h */
//
//  ControllerView.h
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ControllerView : NSView

//快进快退（先不写）
@property(nonatomic)NSButton* fastForwardBtn;
@property(nonatomic)NSButton* resetBtn;
@property(nonatomic)NSButton* rewindBtn;

//上一个视频  播放暂停  下一个视频
@property(nonatomic)NSButton* lastVideoBtn;
@property(nonatomic)NSButton* playSwitchBtn;
@property(nonatomic)NSButton* nextVideoBtn;

//音量
@property(nonatomic)NSButton* soundSwitchBtn;
@property(nonatomic)NSSlider* volumeSlider;

//视频进度
@property(nonatomic)NSSlider *videoSlider;
@property(nonatomic)NSTextField *videoCurrentTimeLabel;
@property(nonatomic)NSTextField *videoTotalTimeLabel;

@end

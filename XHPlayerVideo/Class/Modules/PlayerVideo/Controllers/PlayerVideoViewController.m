//
//  PlayerVideoVC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//
#import "PlayerVideoViewController.h"

#import <VLCKit/VLCKit.h>
#import <Masonry.h>
#import "Macro.h"

#import "ControllerView.h"

@interface PlayerVideoViewController ()<VLCMediaPlayerDelegate>

@end

@implementation PlayerVideoViewController{
    
    VLCMediaPlayer* player;
    
//    NSImageView* backgroundImage;
    VLCVideoView *videoPlayView;
    ControllerView *controllerView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
   
    [self loadSubViews];
    [self loadActions];
    
    player = [[VLCMediaPlayer alloc] initWithVideoView:videoPlayView];
    player.delegate = self;
    [player setMedia:[VLCMedia mediaWithPath:@"/Users/CXH/Documents/视频/MMD/红菱舞姬巡音LUKA】极乐净土【写实向环境渲染】_MMD·3D_动画_bilibili_哔哩哔哩弹幕视频网_1.flv"]];
  

}
#pragma loadActions
-(void)loadActions{
    
    [controllerView.playSwitchBtn setAction:@selector(playSwitch:)];
    [controllerView.nextVideoBtn setAction:@selector(nextVideo:)];
    
    [controllerView.videoSlider setAction:@selector(videoSliderAction:)];
    [controllerView.soundSwitchBtn setAction:@selector(soundSwitch:)];
    [controllerView.volumeSlider setAction:@selector(volumeSliderAction:)];
    
    // 创建监视区
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:
                                    NSTrackingMouseMoved |
                                    NSTrackingMouseEnteredAndExited |
                                    NSTrackingActiveAlways owner:self userInfo:nil];
    
    // 添加到View中
    [self.view addTrackingArea:trackingArea];
}
#pragma BottonActions
- (void)playSwitch:(id)sender {
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }else{
        [controllerView.playSwitchBtn setTitle:@"暂停"];
        [player play];
    }
    
}
- (void)nextVideo:(id)sender{
    NSWindow* window = [[NSWindow alloc] init];
    [window setContentSize:NSMakeSize(300, 618)];
    [window setFrameOrigin:NSMakePoint(1000, 0)];
    [window setStyleMask:NSBorderlessWindowMask];
    [window setMovableByWindowBackground:YES];
    [[NSApplication sharedApplication] beginModalSessionForWindow:window];
}
- (void)soundSwitch:(id)sender {
    if(player.audio.volume){
        player.audio.volume = 0;
    }else{
        player.audio.volume = controllerView.volumeSlider.intValue;
    }
}

#pragma mouseActions
// 鼠标进入监视区
- (void)mouseEntered:(NSEvent *)theEvent{
    controllerView.alphaValue = 1;
}
// 鼠标推出监视区
- (void)mouseExited:(NSEvent *)theEvent{
    controllerView.alphaValue = 0;
}
#pragma SliderActions

- (void)videoSliderAction:(id)sender {
    //不得不说想出这个方法的人真机智。原作者http://www.cnblogs.com/walkingZero/p/3920509.html
    if(controllerView.videoSlider.continuous){
        //开始移动
        controllerView.videoSlider.continuous = !controllerView.videoSlider.continuous;
    }else{
        //移动结束
        controllerView.videoSlider.continuous = !controllerView.videoSlider.continuous;
        player.position = controllerView.videoSlider.intValue/controllerView.videoSlider.maxValue;
    }
}
- (void)volumeSliderAction:(id)sender {
     player.audio.volume = controllerView.volumeSlider.intValue;
}

#pragma VLCMediaPlayerDelegate
//视频状态
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    NSLog(@"视频状态:%lu",player.state);//这个是player
    
    if (player.state == VLCMediaPlayerStateBuffering) {

    }
    
}

//时间发生变化（大约是1秒3次）
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
 //intValue单位毫米
    if (player.remainingTime.intValue == 0) {
        NSLog(@"播放完成");
    }
    if (controllerView.videoSlider.continuous) {
        controllerView.videoSlider.maxValue = player.time.intValue-player.remainingTime.intValue;
        controllerView.videoSlider.intValue = player.time.intValue;
        NSInteger intTime= controllerView.videoSlider.intValue/1000;
        controllerView.videoCurrentTimeLabel.stringValue = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                                             intTime/3600,intTime%3600/60,intTime%3600%60];
        NSInteger maxTime = controllerView.videoSlider.maxValue/1000;
        controllerView.videoTotalTimeLabel.stringValue = [NSString stringWithFormat:@"/%02ld:%02ld:%02ld",
                                             maxTime/3600,maxTime%3600/60,maxTime%3600%60];
    }
        
}

- (void)mediaPlayerChapterChanged:(NSNotification *)aNotification{
    NSLog(@"++++++++++++++");
}
- (void)mediaPlayerTitleChanged:(NSNotification *)aNotification{
    NSLog(@"-------------");
}
#pragma loadSubViews
-(void)loadSubViews{
    self.view.frame = CGRectMake(0, 0, 1000, 618);
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = CColor(30, 200, 200, 1).CGColor;
    
    
    videoPlayView = ({
        VLCVideoView* view = [[VLCVideoView alloc] init];
        view.backColor = CColor(20, 200, 200, 1);
        [self.view addSubview:view];
        view;
    });
    
    controllerView = ({
        ControllerView* view = [[ControllerView alloc] init];
        [self.view addSubview:view];
        view;
    });
 

    
    //layout
    
    [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [controllerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@80);
    }];
    

}
@end

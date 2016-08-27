//
//  PlayerVideoVC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//
#import "PlayerVideoVC.h"

#import <VLCKit/VLCKit.h>
#import <Masonry.h>
#import "Macro.h"

#import "ControllerView.h"

@interface PlayerVideoVC ()<VLCMediaPlayerDelegate>

@end

@implementation PlayerVideoVC{
    
    VLCMediaPlayer* player;
    
//    NSImageView* backgroundImage;
    __weak IBOutlet VLCVideoView *videoPlayView;
    __weak IBOutlet ControllerView *controllerView;
    
    __weak IBOutlet NSButton *playSwitchBtn;
    __weak IBOutlet NSSlider *videoSlider;
    __weak IBOutlet NSSlider *audioSlider;
    __weak IBOutlet NSTextField *videoCurrentTimeLabel;
    __weak IBOutlet NSTextField *videoTotalTimeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    player = [[VLCMediaPlayer alloc] initWithVideoView:videoPlayView];
    player.delegate = self;
    [player setMedia:[VLCMedia mediaWithPath:@"/Users/CXH/Documents/视频/MMD/【MMD】极乐净土 【楪祈】_MMD·3D_动画_bilibili_哔哩哔哩弹幕视频网_1.flv"]];
    [self loadSubViews];

}
#pragma BottonActions
- (IBAction)playSwitch:(id)sender {
    if(player.playing){
        playSwitchBtn.stringValue = @"播放";
        [player pause];
    }else{
        playSwitchBtn.stringValue = @"暂停";
        [player play];
    }
    
}

- (IBAction)soundSwitch:(id)sender {
    if(player.audio.volume){
        player.audio.volume = 0;
    }else{
        player.audio.volume = audioSlider.intValue;
    }
}

- (IBAction)fullScreenSwitch:(id)sender {
}
#pragma SliderActions

- (IBAction)videoSliderAction:(id)sender {
    //不得不说想出这个方法的人真机智。原作者http://www.cnblogs.com/walkingZero/p/3920509.html
    if(videoSlider.continuous){
        //开始移动
        videoSlider.continuous = !videoSlider.continuous;
    }else{
        //移动结束
        videoSlider.continuous = !videoSlider.continuous;
        player.position = videoSlider.intValue/videoSlider.maxValue;
    }
}
- (IBAction)audioSliderAction:(id)sender {
     player.audio.volume = audioSlider.intValue;
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
    if (videoSlider.continuous) {
        videoSlider.maxValue = player.time.intValue-player.remainingTime.intValue;
        videoSlider.intValue = player.time.intValue;
        NSInteger intTime= videoSlider.intValue/1000;
        videoCurrentTimeLabel.stringValue = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                                             intTime/3600,intTime%3600/60,intTime%3600%60];
        NSInteger maxTime = videoSlider.maxValue/1000;
        videoTotalTimeLabel.stringValue = [NSString stringWithFormat:@"/%02ld:%02ld:%02ld",
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
    
    videoPlayView.backColor = CColor(200, 200, 200, 1);
    
    videoCurrentTimeLabel.textColor = CColor(255, 255, 255,1);
    videoTotalTimeLabel.textColor = CColor(255, 255, 255,1);
    
    videoSlider.continuous = YES;//是否一直接收消息
    audioSlider.continuous = YES;//是否一直接收消息
    
    //layout    
//    [controllerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(20);
//        make.right.equalTo(self.view).offset(-20);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
//        make.height.equalTo(@200);
//    }];
//    
//    [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(NSMakeSize(1000, 618));
//    }];
//    
//    [self.view needsLayout];
    
    
    //废弃
//    backgroundImage = [NSImageView new];
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"background" ofType:@"jpg"];
//    backgroundImage.image = [[NSImage alloc] initWithContentsOfFile:path];
//    [self.view addSubview:backgroundImage];
//    
//    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}
@end

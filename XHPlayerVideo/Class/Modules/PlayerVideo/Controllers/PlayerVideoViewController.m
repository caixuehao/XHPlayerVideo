//
//  PlayerVideoVC.m
//  XHPlayerVideo
//
//  Created by C on 16/8/27.
//  Copyright © 2016年 C. All rights reserved.
//
#import "PlayerVideoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import <VLCKit/VLCKit.h>
#import <Masonry.h>
#import "Macro.h"

#import "PlayerVideoWindowController.h"
#import "ControllerView.h"
#import "PlayListWindow.h"
#import "PlayerTitleView.h"


@interface PlayerVideoViewController ()<VLCMediaPlayerDelegate>

@end

@implementation PlayerVideoViewController{
    
    VLCMediaPlayer* player;
    
//    NSImageView* backgroundImage;
    VLCVideoView *videoPlayView;
    //视频视图的约束 填充配合视图
    NSView* videoPlayViewLeftView;
    NSView* videoPlayViewTopView;
    NSView* videoPlayViewRightView;
    NSView* videoPlayViewBottonView;
    
    ControllerView *controllerView;
    PlayerTitleView *playerTitleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self loadSubViews];
    [self loadActions];
    
    //防止启动太卡
    [self performSelector:@selector(loadPlayer) withObject:nil afterDelay:5.1f];
    
}

- (void)viewDidAppear{
    [super viewDidAppear];
    //加载播放列表 窗口
    [PlayListWindow show];

}
#pragma loadActions
//加载播放器
-(void)loadPlayer{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        player = [[VLCMediaPlayer alloc] initWithVideoView:videoPlayView];
        player.delegate = self;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.currentVideo) {
                [player stop];
                [player setMedia:[VLCMedia mediaWithPath:self.currentVideo.path]];
                [player play];
            }
        }];
        //    player.adjustFilterEnabled = NO;
    }];
}

-(void)loadActions{
    
    //头部控制器事件
    playerTitleView.closeBtn.target = self;
    playerTitleView.minmizeBtn.target = self;
    playerTitleView.maximizeBtn.target = self;
    
    [playerTitleView.closeBtn setAction:@selector(close)];
    [playerTitleView.minmizeBtn setAction:@selector(minmize)];
    [playerTitleView.maximizeBtn setAction:@selector(maxmize)];
    
    //底部主控制器事件
    controllerView.playSwitchBtn.target = self;
    controllerView.nextVideoBtn.target = self;
    
    controllerView.videoSlider.target = self;
    controllerView.soundSwitchBtn.target = self;
    controllerView.volumeSlider.target = self;
    
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
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:PlayVideoNotification object:nil];
    
    
}
#pragma Actions


- (void)playVideo:(NSNotification *)notifiction{
    self.currentVideo = [notifiction.userInfo objectForKey:@"video"];
    //防止调用过快 引起打卡死
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playVideo) object:nil];
    [self performSelector:@selector(playVideo) withObject:nil afterDelay:0.5f];
}

- (void)playVideo{
    if(player){
        [player stop];
        [player setMedia:[VLCMedia mediaWithPath:self.currentVideo.path]];
        [player play];
    }
}



#pragma BottonActions
- (void)close{
    [self pause];
//    [self.view.window performClose:nil];
    [self.view.window close];
}
- (void)minmize{
    [self pause];
//    [self.view.window.childWindows enumerateObjectsUsingBlock:^(__kindof NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.view.window removeChildWindow:obj];
//    }];
//    [self.view.window performMiniaturize:nil];//最小化
    [self.view.window miniaturize:nil];

}
- (void)maxmize{
//    [self.view.window setMaxFullScreenContentSize:[NSScreen mainScreen].frame.size];
//    [self.view.window toggleFullScreen:nil];//全屏

    
}
- (void)pause{
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }
}
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
    [playerTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    controllerView.alphaValue = 1;
}
// 鼠标推出监视区
- (void)mouseExited:(NSEvent *)theEvent{
    controllerView.alphaValue = 0;
    [playerTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
}
//鼠标拖动
- (void)mouseDragged:(NSEvent *)theEvent{
    NSPoint point = self.view.window.frame.origin;
    point.x += theEvent.deltaX;
    point.y -= theEvent.deltaY;
    [self.view.window setFrameOrigin:point];
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
        if(player.videoSize.width>0){
            [self updateLayout];
        }
    }
    
}

//时间发生变化（大约是1秒3次）
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
 //intValue单位毫米
    if (player.time.intValue == 0) {
            NSLog(@"播放开始");
    }else if(player.remainingTime.intValue == 0&&player.time.intValue != 0){
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
    self.view.layer.backgroundColor = CColor(100, 200, 220, 1).CGColor;
    
   
    //视频
    videoPlayView = ({
        VLCVideoView* view = [[VLCVideoView alloc] init];
        view.backColor = CColor(20, 200, 200, 1);
        view.fillScreen = NO;//不填充变形
        [self.view addSubview:view];
        view;
    });
    
    //头部
    playerTitleView = ({
        PlayerTitleView* view = [[PlayerTitleView alloc] init];
        [self.view addSubview:view];
        view;
    });

    //控制器（顺便约束了宽度）
    controllerView = ({
        ControllerView* view = [[ControllerView alloc] init];
        [self.view addSubview:view];
        view;
    });
    //视频视图的约束 填充配合视图
    videoPlayViewLeftView = ({
        NSView* view  = [[NSView alloc] init];
        [self.view addSubview:view];
        view;
    });
    videoPlayViewTopView = ({
        NSView* view  = [[NSView alloc] init];
        [self.view addSubview:view];
        view;
    });
   videoPlayViewRightView = ({
        NSView* view  = [[NSView alloc] init];
        [self.view addSubview:view];
        view;
    });
    videoPlayViewBottonView = ({
        NSView* view  = [[NSView alloc] init];
        [self.view addSubview:view];
        view;
    });
    
  
    //layout
    
    [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.height.equalTo(self.view);
    }];
    
    [playerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];

    [controllerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.equalTo(@80);
    }];
    
    [videoPlayViewLeftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
    }];
    [videoPlayViewTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
    [videoPlayViewRightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
    }];
    [videoPlayViewBottonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    

}

//视频加载成功时根据视频尺寸 更新约束布局比例
-(void)updateLayout{
    
    [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.width.equalTo(self.view).priorityLow();
        make.left.equalTo(videoPlayViewLeftView.mas_right);
        make.top.equalTo(videoPlayViewTopView.mas_bottom);
        make.right.equalTo(videoPlayViewRightView.mas_left);
        make.bottom.equalTo(videoPlayViewBottonView.mas_top);
        make.width.equalTo(videoPlayView.mas_height).multipliedBy(player.videoSize.width/player.videoSize.height);
    }];
    
}
@end

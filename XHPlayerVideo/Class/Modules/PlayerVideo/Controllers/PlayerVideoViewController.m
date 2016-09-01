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
#import "PlayListWindowController.h"
#import "PlayerTitleView.h"

@interface PlayerVideoViewController ()<VLCMediaPlayerDelegate>
@property(nonatomic,weak)VLCMedia* media;
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
    
    PlayerTitleView *playerTitleView;
    ControllerView *controllerView;
 
    NSTrackingArea *trackingArea;
    NSInteger unresponsiveTime;
    
    PlayListWindowController* playListWindowController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    unresponsiveTime = 4;
    
    [self loadSubViews];
    [self loadActions];
    
    //加载播放列表窗口
    playListWindowController = [[PlayListWindowController alloc] init];
   
    //加载播放器防止启动太卡
    [self performSelector:@selector(loadPlayer) withObject:nil afterDelay:0.5f];
    
}

- (void)viewDidAppear{
    [super viewDidAppear];
    [playListWindowController displayWindow:self.view.window.frame];
}

#pragma loadActions
//加载播放器
-(void)loadPlayer{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        player = [[VLCMediaPlayer alloc] initWithVideoView:videoPlayView];
        player.delegate = self;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.currentVideo) {
                [player setMedia:self.currentVideo.media];
                [player play];
            }
        }];
        //    player.adjustFilterEnabled = NO;
    }];
}

-(void)loadActions{
    
    //标题按钮
    playerTitleView.closeBtn.target = self;
    playerTitleView.minmizeBtn.target = self;
    playerTitleView.maximizeBtn.target = self;
    playerTitleView.displayPlayListBtn.target = self;
    
    [playerTitleView.closeBtn setAction:@selector(close)];
    [playerTitleView.minmizeBtn setAction:@selector(minmize)];
    [playerTitleView.maximizeBtn setAction:@selector(maxmize)];
    [playerTitleView.displayPlayListBtn setAction:@selector(displayPlayList)];
    
    //底部主控制器事件
    controllerView.playSwitchBtn.target = self;
    controllerView.nextVideoBtn.target = self;
    
    controllerView.videoSlider.target = self;
    controllerView.soundSwitchBtn.target = self;
    controllerView.volumeSlider.target = self;
    
    [controllerView.playSwitchBtn setAction:@selector(playSwitch:)];
    [controllerView.nextVideoBtn setAction:@selector(nextVideo:)];
    [controllerView.lastVideoBtn setAction:@selector(lastVideo:)];
    
    [controllerView.videoSlider setAction:@selector(videoSliderAction:)];
    [controllerView.soundSwitchBtn setAction:@selector(soundSwitch:)];
    [controllerView.volumeSlider setAction:@selector(volumeSliderAction:)];
    
    // 创建监视区
    trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:
                                    NSTrackingMouseMoved |
                                    NSTrackingMouseEnteredAndExited |
                                    NSTrackingActiveAlways owner:self userInfo:nil];
    
    
    // 添加到View中
    [self.view addTrackingArea:trackingArea];

    //注册通知
    //播放视频通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:) name:PlayVideoNotification object:nil];
    //窗口大小改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    
    //启动定时器
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

}
#pragma Actions

//播放视频
- (void)playVideo:(NSNotification *)notifiction{
    self.currentVideo = [notifiction.userInfo objectForKey:@"video"];
    //防止调用过快 引起打卡死
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playVideo) object:nil];
    [self performSelector:@selector(playVideo) withObject:nil afterDelay:0.5f];
}

- (void)playVideo{
    [self.view.window makeKeyAndOrderFront:self];//显示窗口
    //if(player.media.state != VLCMediaStateBuffering&&player)//防止在缓冲时被释放（不知道这样写有没有问题）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [player stop];
        [player setMedia:self.currentVideo.media];
        [player play];// 不能在这里调用？
    }];
}
//窗口大小改变
- (void)windowDidResize:(id)sender{
    //防止调用过快 引起打卡死
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTrackingArea) object:nil];
    [self performSelector:@selector(updateTrackingArea) withObject:nil afterDelay:0.5f];
    
}
- (void)updateTrackingArea{
    //移除以前的
    [self.view removeTrackingArea:trackingArea];
    // 创建监视区
    trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds options:
                    NSTrackingMouseMoved |
                    NSTrackingMouseEnteredAndExited |
                    NSTrackingActiveAlways owner:self userInfo:nil];
    
    // 添加到View中
    [self.view addTrackingArea:trackingArea];
}

//定时器
-(void)timerAction{

    switch (unresponsiveTime) {
        case 0:
            [self onlyDisplayVideoView];
            break;
        case 4:
            [self dispplayAllView];
            --unresponsiveTime;
            break;
        default:
            --unresponsiveTime;
            break;
    }
    
}
#pragma Actions

#pragma TitleBottonActions
//关闭窗口（其实是隐藏）
- (void)close{
    [self pause];
    [self.view.window close];
//    [self.view.window performClose:nil];

}
//最小化
- (void)minmize{
    [self pause];
    [self.view.window miniaturize:nil];
//    [self.view.window performMiniaturize:nil];//最小化
}
//全屏
- (void)maxmize{
    [self.view.window toggleFullScreen:nil];//全屏
}

//显示（隐藏播放列表）
- (void)displayPlayList{
    unresponsiveTime = 4;
   [playListWindowController displaySwitch:self.view.window.frame];
}





#pragma ControllerBottonActions

- (void)pause{
    unresponsiveTime = 4;
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }
}
- (void)playSwitch:(id)sender {
    unresponsiveTime = 4;
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }else{
        [controllerView.playSwitchBtn setTitle:@"暂停"];
        [player play];
    }
    
}

- (void)lastVideo:(id)sender{
    unresponsiveTime = 4;
    SendNotification(PlayLastVideoNotification, nil);
}

- (void)nextVideo:(id)sender{
    unresponsiveTime = 4;
    SendNotification(PlayNextVideoNotification, nil);
}


- (void)soundSwitch:(id)sender {
    unresponsiveTime = 4;
    if(player.audio.volume){
        player.audio.volume = 0;
    }else{
        player.audio.volume = controllerView.volumeSlider.intValue;
    }
}






#pragma mouseActions
//鼠标进入监视区
- (void)mouseEntered:(NSEvent *)theEvent{
    unresponsiveTime = 4;
    [self dispplayAllView];
}

//鼠标推出监视区
- (void)mouseExited:(NSEvent *)theEvent{
    //[self onlyDisplayVideoView];
}

//鼠标拖动
- (void)mouseDragged:(NSEvent *)theEvent{
    NSPoint point = self.view.window.frame.origin;
    point.x += theEvent.deltaX;
    point.y -= theEvent.deltaY;
    [self.view.window setFrameOrigin:point];
}
//鼠标移动
- (void)mouseMoved:(NSEvent *)theEvent{
    unresponsiveTime = 4;
}
//鼠标按下
- (void)mouseDown:(NSEvent *)theEvent{
    unresponsiveTime = 4;
}
//鼠标松开
- (void)mouseUp:(NSEvent *)theEvent{
    unresponsiveTime = 4;
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%i,%f",controllerView.videoSlider.intValue,controllerView.videoSlider.maxValue);
            player.position = controllerView.videoSlider.intValue/controllerView.videoSlider.maxValue;
        }];
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
    } else if(player.state == VLCMediaPlayerStatePaused){
         NSLog(@"%i",player.remainingTime.intValue);
        if (player.remainingTime.intValue > -100) {//妈的这种判断方法感觉很坑啊
            SendNotification(PLayEndNotification, nil);
        }
    }
    
}

//时间发生变化（大约是1秒3次）
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
 //intValue单位毫米
    if (player.time.intValue == 0) {
            NSLog(@"播放开始");
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







#pragma loadSubViews
-(void)loadSubViews{
    self.view.frame = CGRectMake(0, 0, 1000, 618);
    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = CColor(100, 200, 220, 1).CGColor;
    //背景图片
    NSImageView* backImage =({
        NSImageView* iv = [[NSImageView alloc] init];
        iv.image = [NSImage imageNamed:@"background.jpg"];
        [self.view addSubview:iv];
        iv;
    });
    //视频
    videoPlayView = ({
        VLCVideoView* view = [[VLCVideoView alloc] init];
        //view.backColor = CColor(20, 200, 200, 1);
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
    //背景图片
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view).priorityLow();
    }];
    
//    [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.height.equalTo(self.view);
//    }];
    
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


//显示全部
- (void)dispplayAllView{
    if (controllerView.alphaValue == 1) return;
    
    [playerTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    controllerView.alphaValue = 1;
    [NSCursor unhide];
}

//仅显示视频view
- (void)onlyDisplayVideoView{
     if (controllerView.alphaValue == 0) return;
    
    [playerTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    controllerView.alphaValue = 0;
    
    //判断是否是全屏（看看是否隐藏鼠标）
    NSSize size1 = self.view.frame.size;
    NSSize size2 = [NSScreen mainScreen].frame.size;
    if(size1.width==size2.width&&size1.height==size2.height){
        [NSCursor hide];
    }
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

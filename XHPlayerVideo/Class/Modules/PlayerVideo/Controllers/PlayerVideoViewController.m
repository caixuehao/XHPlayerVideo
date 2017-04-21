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
#import "Log.h"

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
    NSTimer* hideTimer;
    
    PlayListWindowController* playListWindowController;
    
    BOOL isFirstPlay;//实在没办法用了这么陋的办法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self dispplayAllView];
    isFirstPlay = YES;
    
    [self loadSubViews];
    [self loadActions];
    //音量
    controllerView.volumeSlider.intValue = (short)[[NSUserDefaults standardUserDefaults] integerForKey:@"videoVolune"];
    if (controllerView.volumeSlider.intValue == 0)controllerView.volumeSlider.intValue = 50;
    
    
    //加载播放列表窗口
    playListWindowController = [[PlayListWindowController alloc] init];
   
    //加载播放器防止启动太卡
    [self performSelector:@selector(loadPlayer) withObject:nil afterDelay:0.2f];
    
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
        player.audio.volume = controllerView.volumeSlider.intValue;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (self.currentVideo) {
                [player setMedia:self.currentVideo.media];
                [player play];
                isFirstPlay = YES;
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
    playerTitleView.topBtn.target = self;
    playerTitleView.displayPlayListBtn.target = self;
    
    [playerTitleView.closeBtn setAction:@selector(close)];
    [playerTitleView.minmizeBtn setAction:@selector(minmize)];
    [playerTitleView.maximizeBtn setAction:@selector(maxmize)];
    [playerTitleView.topBtn setAction:@selector(topWindow)];
    [playerTitleView.displayPlayListBtn setAction:@selector(displayPlayList)];
    
    //底部主控制器事件
    controllerView.turnDownRateBtn.target = self;
    controllerView.turnOnRateBtn.target = self;
    
    controllerView.lastVideoBtn.target = self;
    controllerView.playSwitchBtn.target = self;
    controllerView.nextVideoBtn.target = self;
    
    controllerView.videoSlider.target = self;
    controllerView.soundSwitchBtn.target = self;
    controllerView.volumeSlider.target = self;
    
    [controllerView.turnDownRateBtn setAction:@selector(turnDownRate)];
    [controllerView.turnOnRateBtn setAction:@selector(turnOnRate)];
    
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
    //视频停止
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayVideo:) name:StopPlayVideoNotification object:nil];
    //窗口大小改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    
    //启动定时器
    hideTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];

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
    LOG(@"playVideo start");
    NSString *log = [NSString stringWithFormat:@"视频状态:%lu hasVideoOut：%@  willPlay:%@ position:%f seekable:%@ canPause:%@" ,player.state,player.hasVideoOut?@"YES":@"NO",player.willPlay?@"YES":@"NO",player.position,player.seekable?@"YES":@"NO",player.canPause?@"YES":@"NO"];
    LOG(log);
    
    
    log = [NSString stringWithFormat:@"%d  %d",player.media.length.intValue,player.remainingTime.intValue];
    LOG(log);
    
    log = [NSString stringWithFormat:@"audio:%p media:%p media.mediaType:%lu length:%d state:%lu",player.audio,player.media,player.media.mediaType,player.media.length.intValue,player.media.state];
    LOG(log);
    //if(player.media.state != VLCMediaStateBuffering&&player)//防止在缓冲时被释放（不知道这样写有没有问题）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.view.window makeKeyAndOrderFront:self];//显示窗口
        [self ChangeVideoUpdateUI];
        if (player) {
            [player stop];
            //LOG(@"play setMedia");
            [player setMedia:self.currentVideo.media];
           // LOG(@"play play");
            [player play];// 不能在这里调用？
            //LOG(@"play play end");
        }
        isFirstPlay = YES;
    }];
    LOG(@"playVideo end");
}
//停止播放
-(void)stopPlayVideo:(NSNotification *)notifiction{
    if([self.currentVideo isEqualtoVideoModel:[notifiction.userInfo objectForKey:@"video"]]){
        [self stopPlayVideo];
    }
}
-(void)stopPlayVideo{
    _currentVideo = nil;
    [player stop];
    [player setMedia:nil];
    [self stopPlayVideoUpdateUI];
}

//窗口大小改变
- (void)windowDidResize:(id)sender{
    //防止调用过快 引起打卡死
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateTrackingArea) object:nil];
    [self performSelector:@selector(updateTrackingArea) withObject:nil afterDelay:0.1f];
    
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
    if (unresponsiveTime<0) return;
    if(unresponsiveTime-- == 0){
        [self onlyDisplayVideoView];
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
//置顶
- (void)topWindow{
    NSLog(@"%lu",self.view.window.level);
    if (self.view.window.level) {
        [self.view.window setLevel:0];
        [playerTitleView.topBtn setTitle:@"置顶"];
    }else{
        [self.view.window setLevel:NSStatusWindowLevel];
        [playerTitleView.topBtn setTitle:@"取消置顶"];
    }
    
}
//显示（隐藏播放列表）
- (void)displayPlayList{
    [self dispplayAllView];
   [playListWindowController displaySwitch:self.view.window.frame];
}





#pragma ControllerBottonActions

- (void)turnDownRate{
    [self dispplayAllView];
    if(player.playing){
        //防卡死
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(turnDownRateSelector) object:nil];
        [self performSelector:@selector(turnDownRateSelector) withObject:nil afterDelay:0.1f];
    }
}
-(void)turnDownRateSelector{
    float rate = player.rate - 0.1;
    if (rate<0.1)return;
    player.rate = rate;
    controllerView.currentRateLabel.stringValue = [NSString stringWithFormat:@"×%.1f",player.rate];
}

- (void)turnOnRate{
    [self dispplayAllView];
    if(player.playing){
        //防卡死
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(turnOnRateSelector) object:nil];
        [self performSelector:@selector(turnOnRateSelector) withObject:nil afterDelay:0.1f];
    }
}

-(void)turnOnRateSelector{
    float rate = player.rate + 0.1;
    if (rate>4)return;
    player.rate = rate;
    controllerView.currentRateLabel.stringValue = [NSString stringWithFormat:@"×%.1f",player.rate];
}

- (void)pause{
    [self dispplayAllView];
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }
}
- (void)playSwitch:(id)sender {
    [self dispplayAllView];
    if(player.playing){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        [player pause];
    }else{
        [controllerView.playSwitchBtn setTitle:@"暂停"];
        [player play];
    }
}

- (void)lastVideo:(id)sender{
    [self dispplayAllView];
    SendNotification(PlayLastVideoNotification, nil);
}

- (void)nextVideo:(id)sender{
    [self dispplayAllView];
    SendNotification(PlayNextVideoNotification, nil);
}


- (void)soundSwitch:(id)sender {
    [self dispplayAllView];
    if(player.audio.volume){
        [controllerView.soundSwitchBtn setTitle:@"🔊❌"];
        player.audio.volume = 0;
    }else{
         [controllerView.soundSwitchBtn setTitle:@"🔊"];
        player.audio.volume = controllerView.volumeSlider.intValue;
    }
}






#pragma mouseActions
//鼠标进入监视区
- (void)mouseEntered:(NSEvent *)theEvent{
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
    [self dispplayAllView];
}
//鼠标按下
- (void)mouseDown:(NSEvent *)theEvent{
    [self dispplayAllView];
}
//鼠标松开
- (void)mouseUp:(NSEvent *)theEvent{
    [self dispplayAllView];
}


#pragma keyboard
- (void)keyDown:(NSEvent *)theEvent{
    NSLog(@"%d,%@",theEvent.keyCode,theEvent.characters);
    switch (theEvent.keyCode) {
        case 49://空格
            [self playSwitch:nil];
            break;
        case 123://左
            [player extraShortJumpBackward];
            break;
        case 124://右
            [player extraShortJumpForward];
            break;
        case 125://下
            controllerView.volumeSlider.intValue =  controllerView.volumeSlider.intValue - 5;
            [self volumeSliderAction:nil];
            break;
        case 126://上
            controllerView.volumeSlider.intValue =  controllerView.volumeSlider.intValue + 5;
            [self volumeSliderAction:nil];
            break;
        default:
            break;
    }
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
    [[NSUserDefaults standardUserDefaults] setObject:@(player.audio.volume)forKey:@"videoVolune"];
}








#pragma VLCMediaPlayerDelegate
//视频状态
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification{
    LOG(@"mediaPlayerStateChanged strat");
    NSString *log = [NSString stringWithFormat:@"视频状态:%lu hasVideoOut：%@  willPlay:%@ position:%f seekable:%@ canPause:%@" ,player.state,player.hasVideoOut?@"YES":@"NO",player.willPlay?@"YES":@"NO",player.position,player.seekable?@"YES":@"NO",player.canPause?@"YES":@"NO"];
    LOG(log);
    
    
    log = [NSString stringWithFormat:@"%d  %d",player.media.length.intValue,player.remainingTime.intValue];
    LOG(log);
    
    log = [NSString stringWithFormat:@"audio:%p media:%p media.mediaType:%lu length:%d state:%lu",player.audio,player.media,player.media.mediaType,player.media.length.intValue,player.media.state];
    LOG(log);
    
    if (player.state == 2&&(player.media.length||player.hasVideoOut)&&isFirstPlay&&player.videoSize.width) {
        isFirstPlay = NO;
        NSString *log = [NSString stringWithFormat:@"当前视频宽高:%f,%f",player.videoSize.width,player.videoSize.height];
        LOG(log);
        if (player.videoSize.height&&player.videoSize.width) {//判断一下有时候会传两个空值
            LOG(@"播放开始");
           // [self playStartUpdateUI];
        }
    } else
    if(player.state == VLCMediaPlayerStatePaused){
        [controllerView.playSwitchBtn setTitle:@"播放"];
        //剩余时间不靠谱(这样判断也不知道有没有问题，我已经把我看到的变量，差不多都试了一次)
        if (player.position == 1.0||controllerView.videoSlider.intValue/controllerView.videoSlider.maxValue == 1.0||player.remainingTime.intValue>-2000) {
            NSLog(@"播放结束");
            [self stopPlayVideo];
            SendNotification(PLayEndNotification, nil);
        }
    }else if(player.state == VLCMediaPlayerStateStopped){
        NSLog(@"视频出错？");
        //SendNotification(PlayNextVideoNotification, nil);
    }
    LOG(@"mediaPlayerStateChanged end");
}

//时间发生变化（大约是1秒3次）
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification{
 //intValue单位毫米
//    if (isFirstPlay == YES) {
//        isFirstPlay = NO;
//    }
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
#pragma registerForDragged
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

-(BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender{
    // 1）、获取拖动数据中的粘贴板
    NSPasteboard *zPasteboard = [sender draggingPasteboard];
    // 2）、从粘贴板中提取我们想要的NSFilenamesPboardType数据，这里获取到的是一个文件链接的数组，里面保存的是所有拖动进来的文件地址，如果你只想处理一个文件，那么只需要从数组中提取一个路径就可以了。
    NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
    NSLog(@"%@",list);
    return YES;
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
    unresponsiveTime = 4 ;
    
    if (controllerView.alphaValue == 1) return;
    playerTitleView.alphaValue = 1;
    controllerView.alphaValue = 1;
    [NSCursor unhide];
}

//仅显示视频view
- (void)onlyDisplayVideoView{
     if (controllerView.alphaValue == 0) return;
    
    playerTitleView.alphaValue = 0;
    controllerView.alphaValue = 0;
    
    //判断是否是全屏（看看是否隐藏鼠标）
    NSSize size1 = self.view.frame.size;
    NSSize size2 = [NSScreen mainScreen].frame.size;
    if(size1.width==size2.width&&size1.height==size2.height){
        [NSCursor hide];
    }
}

//视频加载成功时根据视频尺寸 更新约束布局比例
-(void)playStartUpdateUI{
    LOG(@"playStartUpdateUI start");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.width.equalTo(self.view).priorityLow();
            make.left.equalTo(videoPlayViewLeftView.mas_right);
            make.top.equalTo(videoPlayViewTopView.mas_bottom);
            make.right.equalTo(videoPlayViewRightView.mas_left);
            make.bottom.equalTo(videoPlayViewBottonView.mas_top);
            make.width.equalTo(videoPlayView.mas_height).multipliedBy(player.videoSize.width/player.videoSize.height);
        }];
    }];
    LOG(@"playStartUpdateUI end");
}

//视频停止时更新UI
-(void)stopPlayVideoUpdateUI{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"当前视频宽高:%f,%f",player.videoSize.width,player.videoSize.height);
        [videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.width.mas_equalTo(0);
            make.left.equalTo(videoPlayViewLeftView.mas_right);
            make.top.equalTo(videoPlayViewTopView.mas_bottom);
            make.right.equalTo(videoPlayViewRightView.mas_left);
            make.bottom.equalTo(videoPlayViewBottonView.mas_top);
        }];
        [videoPlayView displayIfNeeded];
    }];
}
//改变视频时刷新UI
-(void)ChangeVideoUpdateUI{
    //LOG(@"ChangeVideoUpdateUI start");
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [controllerView.playSwitchBtn setTitle:@"暂停"];
        playerTitleView.titleLabel.text = [self.currentVideo.path lastPathComponent];
        LOG(playerTitleView.titleLabel.text);
        [self dispplayAllView];
    }];
    // LOG(@"ChangeVideoUpdateUI end");
}

@end

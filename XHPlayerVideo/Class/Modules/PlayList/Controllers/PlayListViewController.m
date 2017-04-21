//
//  PlayListViewController.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListViewController.h"
//#import "PlayerVideoWindowController.h"
#import "PlayListWindow.h"

#import "Macro.h"
#import <Masonry.h>

#import <CommonCrypto/CommonDigest.h>

#import "PlayListTitleView.h"
#import "VideoListTableView.h"

#import "PlayListModel.h"



@interface PlayListViewController ()<PlayListUpdateDataDelegate>

@end

@implementation PlayListViewController{
    PlayListTitleView* playlistTitleView;
    VideoListTableView* videoTableView;
   
    PlayListModel* playListModel;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        playListModel = [PlayListModel share];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
 
    ;
    
    [self loadSubViews];
    [self loadActions];
    
}

- (void)loadActions{
   
    [playListModel setDelegate:self];
    
    playlistTitleView.hideBtn.target = self;
    playlistTitleView.playModeBtn.target = self;
    playlistTitleView.removeAllVideoBtn.target = self;
    playlistTitleView.addVideoBtn.target = self;
    
    [playlistTitleView.hideBtn setAction:@selector(hide)];
    [playlistTitleView.playModeBtn setAction:@selector(changePlayMode)];
    [playlistTitleView.removeAllVideoBtn setAction:@selector(removeAllVideo)];
    [playlistTitleView.addVideoBtn setAction:@selector(addVideo)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playLastVideo) name:PlayLastVideoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playNextVideo) name:PlayNextVideoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:PLayEndNotification object:nil];
    
}
#pragma Actions
- (void)hide{
    [self.view.window close];
}
- (void)changePlayMode{
    if (playListModel.playMode == 3) {
        playListModel.playMode = 0;
    }else{
        ++(playListModel.playMode);
    }
    [playlistTitleView updatePlayModeBtnState];
}


- (void)removeAllVideo{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"删除所有"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:@"清空所有视频"];
    [alert setInformativeText:@"你确定全部清空！？"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:self.view.window modalDelegate:self
                     didEndSelector:@selector(removeAllAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)removeAllAlertDidEnd:(NSAlert *)alert  returnCode:(NSInteger)returnCode   contextInfo:(void *)contextInfo{
    if (returnCode == 1000) {
        [playListModel removeAll];
    }
}

- (void)addVideo{
    
//    NSInteger result = [[NSOpenPanel openPanel] runModalForTypes:@[@"flv",@"mp4",@"avi",@"rmvb",@"wma",@"flash",@"3gp",@"mkv"]];
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    openPanel.allowedFileTypes = @[@"flv",@"mp4",@"avi",@"rmvb",@"wma",@"flash",@"3gp",@"mkv",@"mov"];
    NSInteger result = [openPanel runModal];
    if (result == NSFileHandlingPanelOKButton)
    {
        NSString *path = [[openPanel URL] path];
        NSLog(@"打开文件:%@",path);
        [[[VideoModel alloc] initWithPath:path] play];
    }
}
#pragma NSNotification

-(void)playLastVideo{
    if(playListModel.playList.count == 0)return;
    if(playListModel.playList.count == 1){
        [playListModel setCurrentVideo:[playListModel.playList firstObject]];
        return;
    }
    
    NSInteger row = [playListModel.playList indexOfObject:playListModel.currentVideo];
    if (row == NSNotFound) return;
    switch (playListModel.playMode) {
        case PlayModeListCycle:
        case PlayModeSingleCycle:
        case PlayModeSequential:
            if(row == 0){
                [playListModel setCurrentVideo:[playListModel.playList lastObject]];
            }else{
                [playListModel setCurrentVideo:playListModel.playList[row-1]];
            }
            break;
        case PlayModeRandom:
            [playListModel setCurrentVideo:playListModel.playList[arc4random()%playListModel.playList.count]];
            break;
        default:
            break;
    }
}
-(void)playNextVideo{
    if(playListModel.playList.count == 0)return;
    if(playListModel.playList.count == 1){
        [playListModel setCurrentVideo:[playListModel.playList firstObject]];
        return;
    }
    
    NSInteger row = [playListModel.playList indexOfObject:playListModel.currentVideo];
    if (row == NSNotFound) return;
    switch (playListModel.playMode) {
        case PlayModeListCycle:
        case PlayModeSingleCycle:
        case PlayModeSequential:
            if(row+1 == playListModel.playList.count){
                [playListModel setCurrentVideo:[playListModel.playList firstObject]];
            }else{
                [playListModel setCurrentVideo:playListModel.playList[row+1]];
            }
            break;
        case PlayModeRandom:
            [playListModel setCurrentVideo:playListModel.playList[arc4random()%playListModel.playList.count]];
            break;
        default:
            break;
    }
}

-(void)playEnd{
    NSInteger row = [playListModel.playList indexOfObject:playListModel.currentVideo];
    if (playListModel.playMode == PlayModeSequential&&row+1 == playListModel.playList.count) {
        return;
    }else if(playListModel.playMode == PlayModeSingleCycle){
        [playListModel setCurrentVideo:playListModel.currentVideo];return;
    }
    [self playNextVideo];
}


#pragma PlayListUpdateDataDelegate
-(void)playlistUpdateData:(PlayListModel *)model{
    videoTableView.videos = model.playList;
    [videoTableView reloadData];
}



#pragma loadSubViews
- (void)loadSubViews{
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:CColor(200, 10, 150, 1).CGColor];
//    CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;
//    self.view.frame = NSMakeRect(0, 0,VideoCellWidth+20, playerVideoFrame.size.height);
    
    
    //组成头部
    playlistTitleView = ({
        PlayListTitleView* view = [[PlayListTitleView alloc] init];
        [self.view addSubview:view];
        view;
    });
    
    //建立tabelview
    NSScrollView * tableContainer = [[NSScrollView alloc] init];
    videoTableView = ({
        VideoListTableView * tableView = [[VideoListTableView alloc] initWithModel:playListModel];
        [tableContainer setDocumentView:tableView];
        [tableContainer setHasVerticalScroller:YES];
        [self.view addSubview:tableContainer];
        tableView;
    });

    //layout
    [playlistTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    
    [tableContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playlistTitleView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
}




@end
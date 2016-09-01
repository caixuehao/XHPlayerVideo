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



@interface PlayListViewController ()

@end

@implementation PlayListViewController{
    PlayListTitleView* playlistTitleView;
    VideoListTableView* videoTableView;
    NSMutableArray<VideoModel *>* VideoDataArr;
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    VideoDataArr = [[PlayListModel share] playList];
    
    [self loadSubViews];
    [self loadActions];
    
}

- (void)loadActions{
    playlistTitleView.hideBtn.target = self;
    [playlistTitleView.hideBtn setAction:@selector(hide)];
}



#pragma Actions
- (void)hide{
    [self.view.window close];
}

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
        VideoListTableView * tableView = [[VideoListTableView alloc] initWithArray:VideoDataArr];
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
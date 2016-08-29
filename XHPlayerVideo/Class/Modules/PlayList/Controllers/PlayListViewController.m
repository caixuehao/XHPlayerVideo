//
//  PlayListViewController.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayerVideoWindowController.h"

#import "Macro.h"
#import <Masonry.h>

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
        CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;
        self.view.frame = NSMakeRect(0, 0,VideoCellWidth, playerVideoFrame.size.height);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.view setWantsLayer:YES];
    [self.view.layer setBackgroundColor:CColor(200, 10, 150, 1).CGColor];
    
    [self loadSubViews];
    [self loadActions];
}

- (void)loadActions{
    playlistTitleView.hideBtn.target = self;
    [playlistTitleView.hideBtn setAction:@selector(hide)];
}
#pragma Actions
- (void)hide{
     [[PlayerVideoWindowController getPlayerVideoWindowController].window removeChildWindow:self.view.window];
}

- (void)loadSubViews{
   
    VideoDataArr = [[PlayListModel share] playList];
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
        //    [tableContainer setHasVerticalScroller:YES];
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

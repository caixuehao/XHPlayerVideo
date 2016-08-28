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

#import "VideoListTableView.h"

@interface PlayListViewController ()

@end

@implementation PlayListViewController{
    VideoListTableView * videoTableView;
    NSMutableArray<VideoModel *>* VideoDataArr;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect playerVideoFrame = [PlayerVideoWindowController getPlayerVideoWindowController].window.frame;
        self.view.frame = NSMakeRect(0, 0,VideoCellWidth, playerVideoFrame.size.height-20);
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
  
}



- (void)loadSubViews{
    VideoDataArr = [[NSMutableArray alloc] init];
    NSArray* pathArr = @[@"/Users/CXH/Documents/视频/MMD/极乐净土 【楪祈】.flv",
                         @"/Users/CXH/Documents/视频/MMD/萌萌哒的樱miku.flv",
                         @"/Users/CXH/Documents/视频/MMD/AC娘XYZの魔法.flv",
                         @"/Users/CXH/Documents/视频/MMD/红菱舞姬巡音LUKA极乐净土.flv",
                         @"/Users/CXH/Documents/视频/MMD/Romance.flv",
                         @"/Users/CXH/Documents/视频/MMD/Hi-Fi Raver [Tda Idiolect].flv",
                         @"/Users/CXH/Documents/视频/AMV/第一天~~~！.mp4"];
    for (int i = 0; i < pathArr.count; i++) {
        VideoModel* video = [[VideoModel alloc] init];
        video.path = pathArr[i];
        [VideoDataArr addObject:video];
    }
    
    
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
    [tableContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view);
    }];
}
@end

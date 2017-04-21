//
//  videoListTableView.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoListTableView.h"
#import "Macro.h"
#import "VideoCell.h"


@interface VideoListTableView ()<NSTableViewDataSource,NSTableViewDelegate>

@end

@implementation VideoListTableView{
    PlayListModel* _model;
}
-(instancetype)initWithArray:(NSArray<VideoModel *>*)videos{
    self = [super init];
    if (self) {
        self.videos = [[NSMutableArray alloc] initWithArray:videos];
        
        self.rowHeight = VideoCellHeight;
        //初始化一行
        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"VideoCell"];
        
        [column1 setWidth:VideoCellWidth];//行宽
        column1.headerCell.title = @"播放列表";//行头名称
//        [column1 setDataCell:[[VideoCell alloc] init]];//设置cell类型
    
        [self addTableColumn:column1];
        [self setDataSource:self];
        [self setDelegate:self];
        
    }
    return self;
}
-(instancetype)initWithModel:(PlayListModel*)model{
    self = [super init];
    if (self) {
        _model = model;
        _videos = model.playList;
        self.videos = [[NSMutableArray alloc] initWithArray:_model.playList];
        
        self.rowHeight = VideoCellHeight;
        //初始化一行
        NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"VideoCell"];
        
        [column1 setWidth:VideoCellWidth];//行宽
        column1.headerCell.title = @"播放列表";//行头名称
        //        [column1 setDataCell:[[VideoCell alloc] init]];//设置cell类型
        
        [self addTableColumn:column1];
        [self setDataSource:self];
        [self setDelegate:self];
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
#pragma NSTableViewDataSource,NSTableViewDelegate---
//返回有几列（必须实现）
- ( NSInteger )numberOfRowsInTableView:( NSTableView *)tableView
{
    return self.videos.count;
}


//初始化每行数据（必须实现）
//-  ( id )tableView:( NSTableView *)tableView objectValueForTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
//{
//    VideoCell* cell =  [tableColumn dataCellForRow:row];
//    cell.video = self.videos[row];
//    return cell;
//}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    VideoCell* cell = [tableView makeViewWithIdentifier:@"VideoCell" owner:self];
    if (cell == nil) {
        cell = [[VideoCell alloc] init];
    }
    cell.video = self.videos[row];
    return cell;
}
//操作cell调用
//-( void )tableView:( NSTableView *)tableView setObjectValue:( id )object forTableColumn:( NSTableColumn *)tableColumn row:( NSInteger )row
//{
//    VideoModel* video = self.videos[row];
//    NSLog(@"%@",video.path);
//    [video play];
//}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
//    VideoModel* video = self.videos[row];
//    NSLog(@"%@",video.path);
//    [video play];
    
    [_model setCurrentVideo:_model.playList[row]];
    return YES;
}

@end

//
//  PlayListModel.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"
typedef NS_ENUM(NSInteger, PlayMode) {
    PlayModeListCycle,//顺序播放
    PlayModeSingleCycle,//单曲循环
    PlayModeRandom,//随机播放
    PlayModeSequential//顺序播放
};
@protocol PlayListUpdateDataDelegate;

@interface PlayListModel : NSObject

+(instancetype)share;
//当改变了需要保存的数据时调用（额，因为老是崩溃我就不退出时保存了。）
-(void)updateData;


@property(nonatomic,weak)id<PlayListUpdateDataDelegate>delegate;

@property(nonatomic,readonly)NSMutableArray<VideoModel*>* playList;


@property(nonatomic)VideoModel* currentVideo;//正在播放的视频

@property(nonatomic)PlayMode playMode;//播放模式

@end

//数据刷新时调用
@protocol PlayListUpdateDataDelegate
@optional
-(void)playlistUpdateData:(PlayListModel*)model;
@end
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
    PlayMode顺序播放,
    PlayMode单曲循环,
    PlayMode随机播放,
    PlayMode列表循环
};

@interface PlayListModel : NSObject

+(instancetype)share;

@property(nonatomic,readonly)NSMutableArray<VideoModel*>* playList;

@property(nonatomic,readonly)NSMutableArray<VideoModel*>* playHistory;


@property(nonatomic,copy)VideoModel* currentVideo;

@property(nonatomic,readonly)VideoModel* lastVideo;

@property(nonatomic,readonly)VideoModel* nextVideo;


@property(nonatomic)PlayMode playmode;

-(void)saveData;

@end

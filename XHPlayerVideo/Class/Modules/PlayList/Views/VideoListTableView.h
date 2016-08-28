//
//  videoListTableView.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoModel.h"

@interface VideoListTableView : NSTableView
//@property(nonatomic)id<NSTabViewDelegate> selectedDelegate;

@property(nonatomic)NSMutableArray<VideoModel *>* videos;

-(instancetype)initWithArray:(NSArray<VideoModel *>*)videos;

@end

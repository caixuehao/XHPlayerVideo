//
//  PlayListModel.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

@interface PlayListModel : NSObject<NSCoding>

@property(nonatomic,strong)NSMutableArray* playHistory;

@property(nonatomic,strong)VideoModel* currentVideo;

//@property(nonatomic,strong)
@end

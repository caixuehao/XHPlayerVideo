//
//  VideoCell.h
//  XHPlayerVideo
//
//  Created by C on 16/8/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoModel.h"
@interface VideoCell : NSView<NSCopying>

@property(nonatomic)VideoModel* video;

@end

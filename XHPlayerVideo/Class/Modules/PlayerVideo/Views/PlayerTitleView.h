//
//  PlayerTitleView.h
//  XHPlayerVideo
//
//  Created by C on 16/8/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSLabel.h"

@interface PlayerTitleView : NSView



@property(nonatomic)NSButton* closeBtn;

@property(nonatomic)NSButton* minmizeBtn;

@property(nonatomic)NSButton* maximizeBtn;

@property(nonatomic)NSLabel* titleLabel;

@property(nonatomic)NSButton* displayPlayListBtn;

@end

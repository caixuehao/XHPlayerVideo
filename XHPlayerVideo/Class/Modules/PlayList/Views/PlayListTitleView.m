//
//  PlayListTitleView.m
//  XHPlayerVideo
//
//  Created by C on 16/8/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListTitleView.h"
#import "PlayListModel.h"
#import "Macro.h"
#import <Masonry.h>

@implementation PlayListTitleView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadSubView];
         
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:0];
    [CColor(255, 255, 255, 0.7) setFill];
    [bezierPath fill];
    // Drawing code here.
    
}

//loadSubView
- (void)loadSubView{
    _hideBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"隐藏"];
        [self addSubview:btn];
        btn;
    });
    
    _playModeBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"顺序播放"];
        [self addSubview:btn];
        btn;
    });
    
    //layout
 
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(40);
    }];
    
    [_playModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_hideBtn.mas_right).offset(10);
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(60);
    }];
}

-(void)setPlayModeBtnState:(PlayMode)playMode{
    switch (playMode) {
        case PlayMode列表循环: [_playModeBtn setTitle:@"顺序播放"];break;
        case PlayMode单曲循环: [_playModeBtn setTitle:@"单曲循环"];break;
        case PlayMode随机播放: [_playModeBtn setTitle:@"随机播放"];break;
        case PlayMode顺序播放: [_playModeBtn setTitle:@"顺序播放"];break;
        default:
            break;
    }
}
@end

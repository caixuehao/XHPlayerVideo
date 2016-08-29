//
//  PlayerTitleView.m
//  XHPlayerVideo
//
//  Created by C on 16/8/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayerTitleView.h"

#import "Macro.h"
#import <Masonry.h>

@implementation PlayerTitleView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:0 yRadius:0];
    [CColor(255, 255, 255, 0.7) setFill];
    [bezierPath fill];
    // Drawing code here.
}

//loadSubView
- (void)loadSubView{
     _closeBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"❌"];
        [self addSubview:btn];
        btn;
    });
    
    _minmizeBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"-"];
        [self addSubview:btn];
        btn;
    });
    
    _maximizeBtn = ({
        NSButton* btn = [[NSButton alloc] init];
        [btn setTitle:@"➕"];
        [self addSubview:btn];
        btn;
    });
    
    //layout
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self).offset(0);
        make.size.mas_equalTo(NSMakeSize(10, 10));
    }];
    
    [_minmizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_closeBtn.mas_right).offset(10);
        make.centerY.equalTo(self).offset(0);
        make.size.mas_equalTo(NSMakeSize(10, 10));
    }];
    
    [_maximizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_minmizeBtn.mas_right).offset(10);
        make.centerY.equalTo(self).offset(0);
        make.size.mas_equalTo(NSMakeSize(10, 10));
    }];
}
@end

//
//  PlayListTitleView.m
//  XHPlayerVideo
//
//  Created by C on 16/8/29.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListTitleView.h"

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
        [btn setImage:[NSImage imageNamed:@""]];
        [self addSubview:btn];
        btn;
    });

    //layout
 
    [_hideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(40);
    }];
}
@end

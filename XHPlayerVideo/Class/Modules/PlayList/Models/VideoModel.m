//
//  XHVideo.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoModel.h"
#import "PlayListModel.h"

@implementation VideoModel

-(instancetype)copyWithZone:(NSZone *)zone{
    VideoModel* vm = [[VideoModel alloc] init];
    vm.path = self.path;
    return vm;
}


//播放
-(void)play{
    [[PlayListModel share] setCurrentVideo:self];
}

//判断是否相等
-(BOOL)isEqualtoVideoModel:(VideoModel*)aVideoModel{
    return [self.path isEqualToString:aVideoModel.path];
}

//把所有数据做成一个字典方便保存
-(NSDictionary*)getData{
    return @{@"path":self.path};
}
//用本地读取的数据创建对象
-(instancetype)initWithData:(NSDictionary*)data{
    self = [super init];
    if (self) {
        self.path = [data objectForKey:@"path"];
    }
    return self;
}
@end

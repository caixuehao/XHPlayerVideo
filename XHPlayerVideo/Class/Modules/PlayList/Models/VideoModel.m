//
//  XHVideo.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoModel.h"
#import "Macro.h"

@implementation VideoModel

-(instancetype)copyWithZone:(NSZone *)zone{
    VideoModel* vm = [[VideoModel alloc] init];
    vm.path = self.path;
    return vm;
}

//播放
-(void)play{
    NSDictionary* dic = @{@"video":self};
    NSNotification *notification =[NSNotification notificationWithName:PlayVideoNotification object:nil userInfo:dic];//创建通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];//通过通知中心发送通知
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

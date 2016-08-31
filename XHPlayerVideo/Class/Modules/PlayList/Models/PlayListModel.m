//
//  PlayListModel.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListModel.h"


#import "Macro.h"

static PlayListModel* playListModelShare;

@interface PlayListModel ()

@end
@implementation PlayListModel{
    
}
+(instancetype)share{
    if (playListModelShare == nil) {
        playListModelShare = [[PlayListModel alloc] init];
    }
    return playListModelShare;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}
-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

-(void)setCurrentVideo:(VideoModel *)currentVideo{
    NSLog(@"%@",[self getPath]);
    _currentVideo = currentVideo;
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self addVideoModel:currentVideo];
    }];

    
    NSDictionary* dic = @{@"video":self.currentVideo};
    NSNotification *notification =[NSNotification notificationWithName:PlayVideoNotification object:nil userInfo:dic];//创建通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];//通过通知中心发送通知
}




-(void)addVideoModel:(VideoModel*)videoModel{
    if(videoModel==nil)return;
    
    if (_playList == nil)_playList = [[NSMutableArray alloc] init];
    BOOL isRepeat = NO;
    for (int i = 0; i < _playList.count; i++) {
        if ([_playList[i] isEqualtoVideoModel:videoModel])
            isRepeat = YES;
    }
    
    if (isRepeat == NO) {
        [_playList insertObject:videoModel atIndex:0];
        [self saveData];
    }
}




#pragma FileReadWrite

-(NSString*)getPath{
    //百度QQ的用户信息都放在这里所以我参考了一下
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"XHPlayerVideo"];
    path = [path stringByAppendingPathComponent:@"PlayList.plist"];
    return path;
}

-(void)loadData{
    NSFileManager* mgr = [NSFileManager defaultManager];
    NSString* path = [self getPath];
    if([mgr fileExistsAtPath:path] == YES){//查看文件是否存在
        NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        _playList = [[NSMutableArray alloc] init];
        NSArray* playlist = [data objectForKey:@"playList"];
        for (int i = 0; i < playlist.count;i++) {
            [_playList addObject:[[VideoModel alloc] initWithData:playlist[i]]];
        }
        
    }else{
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:[[self getPath] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bo) NSLog(@"文件夹创建失败！");
    }
}





-(void)saveData{
    //防止掉用过快（如滑动音量条时）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(saveDataSelector) object:nil];
        [self performSelector:@selector(saveDataSelector) withObject:nil afterDelay:0.5f];
    }];
}

-(void)saveDataSelector{
    
    NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    NSMutableArray* playlist = [[NSMutableArray alloc] init];
    for (int i = 0; i < _playList.count; i++) {
        [playlist addObject:[_playList[i] getData]];
    }
    [data setObject:playlist forKey:@"playList"];
    [data writeToFile:[self getPath] atomically:YES];
    
}
@end

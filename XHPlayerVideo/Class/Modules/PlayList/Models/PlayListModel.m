//
//  PlayListModel.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "PlayListModel.h"

#import "Log.h"
#import "Macro.h"

static PlayListModel* playListModelShare;

@interface PlayListModel ()
@property(nonatomic,readonly)NSMutableArray<VideoModel*>* playHistory;//
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
        _playHistory = [[NSMutableArray alloc] init];
        [self loadData];
    }
    return self;
}
-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

//设置当前应该播放的视频
-(void)setCurrentVideo:(VideoModel *)currentVideo{
    NSLog(@"%@",[self getPath]);
    
    
    NSUInteger index = [_playList indexOfObject:currentVideo];
    if(index == NSNotFound){
        BOOL isRepeat = NO;
        for (int i = 0; i < _playList.count; i++) {
            if ([_playList[i] isEqualtoVideoModel:currentVideo]){
                _currentVideo = _playList[i];
                isRepeat = YES; break;
            }
        }
        if (isRepeat == NO) {
            [self addVideoModel:currentVideo];
            _currentVideo = currentVideo;
        }
    }else{
        _currentVideo = currentVideo;
    }
    [self updateData];
    
    if(currentVideo)SendNotification(PlayVideoNotification, @{@"video":_currentVideo});
}

-(void)setPlayMode:(PlayMode)playmode{
    _playMode = playmode;
}





//增
-(void)addVideoModel:(VideoModel*)videoModel{
    if(videoModel==nil)return;
    
    if (_playList == nil)_playList = [[NSMutableArray alloc] init];
    BOOL isRepeat = NO;
    for (int i = 0; i < _playList.count; i++) {
        if ([_playList[i] isEqualtoVideoModel:videoModel]){
            isRepeat = YES;break;
        }
    }
    
    if (isRepeat == NO) {
        [_playList insertObject:videoModel atIndex:0];
        [self updateData];
    }
}

//删
-(void)removeAll{
    if(_currentVideo)SendNotification(StopPlayVideoNotification, @{@"video":_currentVideo});
    [_playList removeAllObjects];
    [self updateData];
}
-(void)removeVideo:(VideoModel*)video{
    if(video == nil)return;
    
    if([_playList indexOfObject:video] == NSNotFound)return;
    
    if([video isCurrentVideo]){
        SendNotification(StopPlayVideoNotification, @{@"video":video});
    }
    [_playList removeObject:video];
    [self updateData];
    
}



#pragma FileReadWrite

-(NSString*)getPath{
    //百度QQ的用户信息都放在这里所以我参考了一下
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];//NSDesktopDirectory
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
        _playMode = [[data objectForKey:@"playMode"] integerValue];
    }else{
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:[[self getPath] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bo) NSLog(@"文件夹创建失败！");
    }
}





-(void)updateData{
    //防止掉用过快
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateDataSelector) object:nil];
        [self performSelector:@selector(updateDataSelector) withObject:nil afterDelay:0.2f];
    }];
}

-(void)updateDataSelector{
    [self saveData];
    if (_delegate) {
        [_delegate playlistUpdateData:self];
    }
}

-(void)saveData{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
        NSMutableArray* playlist = [[NSMutableArray alloc] init];
        for (int i = 0; i < _playList.count; i++) {
            [playlist addObject:[_playList[i] getData]];
        }
        [data setObject:playlist forKey:@"playList"];
        [data setObject:@(_playMode) forKey:@"playMode"];
        [data writeToFile:[self getPath] atomically:YES];
    }];
}
@end

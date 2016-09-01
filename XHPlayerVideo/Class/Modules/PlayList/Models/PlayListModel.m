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
    if(currentVideo)SendNotification(PlayVideoNotification, @{@"video":currentVideo});
    
    if ([_currentVideo isEqualtoVideoModel:currentVideo]) {
        if([_playList indexOfObject:currentVideo] == NSNotFound){
            [self addVideoModel:currentVideo];
        }
        _currentVideo = currentVideo;
        [self updateData];
    }
}

-(void)setPlaymode:(PlayMode)playmode{
    _playmode = playmode;
    [self updateData];
}











//更新播放顺序
-(void)updatePlayOrder{
    int row = [_playList indexOfObject:_currentVideo];
    switch (_playmode) {
        case PlayMode列表循环:
            
            break;
        case PlayMode单曲循环
            :
            break;
        case PlayMode随机播放:
            
            break;
        case PlayMode顺序播放:
            
            break;
        default:
            break;
    }
    
}



//增
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
        [self updateData];
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





-(void)updateData{
    //防止掉用过快（如滑动音量条时）
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateDataSelector) object:nil];
        [self performSelector:@selector(updateDataSelector) withObject:nil afterDelay:0.5f];
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
        [data writeToFile:[self getPath] atomically:YES];
    }];
}
@end

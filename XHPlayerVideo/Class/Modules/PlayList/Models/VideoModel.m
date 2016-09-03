//
//  XHVideo.m
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "VideoModel.h"
#import "PlayListModel.h"

#import "Macro.h"

#import <CommonCrypto/CommonDigest.h>
#import <VLCKit/VLCKit.h>

//获取缩略图太卡了只能这样了
static NSMutableArray<VideoModel*> *currentThumbnailLoadingArr;
static int currentThumbnailLoadingCount = 0;


@interface VideoModel()<VLCMediaThumbnailerDelegate>

@end

@implementation VideoModel

-(instancetype)copyWithZone:(NSZone *)zone{
    VideoModel* vm = [[VideoModel alloc] initWithData:[self getData]];
    return vm;
}

//用路径初始化一个视频对象
-(instancetype)initWithPath:(NSString*)path{
    self = [super init];
    if (self) {
        _path = path;
        _media = [VLCMedia mediaWithPath:self.path];
        _thumbnailPath = @"";
    }
    return self;
}

//用本地读取的数据创建对象
-(instancetype)initWithData:(NSDictionary*)data{
    self = [super init];
    if (self) {
        _path = [data objectForKey:@"path"];
        _media = [VLCMedia mediaWithPath:self.path];
        _thumbnailPath = [data objectForKey:@"thumbnailPath"];
    }
    return self;
}

//把所有数据做成一个字典方便保存
-(NSDictionary*)getData{
    
    return @{@"path":_path,
             @"thumbnailPath":_thumbnailPath};
}


//加载缩略图
-(void)loadThumnbnail:(id<LoadThumbnailDelegate>)delegate{
    //查看本地是否存在
    if([ [NSFileManager defaultManager] fileExistsAtPath:[self getThumbnailShouldSavePath]]){
        _thumbnailPath = [self getThumbnailShouldSavePath];
        [[PlayListModel share] updateData];
        return;
    }
    
    
    if (currentThumbnailLoadingArr == nil) currentThumbnailLoadingArr = [[NSMutableArray alloc] init];
    if([currentThumbnailLoadingArr indexOfObject:self] == NSNotFound)[currentThumbnailLoadingArr addObject:self];
    
    //一个对象只加载一次
    if (_delegate == nil) {
        if (currentThumbnailLoadingCount == 0) {
            currentThumbnailLoadingCount = 1;
            [self performSelector:@selector(loadThumnbnail) withObject:self afterDelay:0.5];
        }
    }
    _delegate = delegate;
}

-(void)loadThumnbnail{
    //这里注意，必须重新新建VLCMedia一个放进去。要不VLCMediaThumbnailer会把它释放掉，如果当前的视频正在播放肯定GG了。
    VLCMediaThumbnailer * mt = [VLCMediaThumbnailer thumbnailerWithMedia:[VLCMedia mediaWithPath:_path] andDelegate:self];
    mt.thumbnailHeight = VideoCellHeight;
    mt.thumbnailWidth = VideoCellWidth;
    mt.snapshotPosition = 0.1;//视频帧位置
    [mt fetchThumbnail];
}

//播放
-(void)play{
    [[PlayListModel share] setCurrentVideo:self];
}

//删除
- (void)removeAlertDidEnd:(NSAlert *)alert  returnCode:(NSInteger)returnCode   contextInfo:(void *)contextInfo{
    if (returnCode == 1000) {
        [self remove];
    }
}
- (void)remove{
    [[PlayListModel share] removeVideo:self];
}

//判断是否相等
-(BOOL)isEqualtoVideoModel:(VideoModel*)aVideoModel{
    return [_path isEqualToString:aVideoModel.path];
}
//判断是否是正在正在播放的视频
-(BOOL)isCurrentVideo{
    return [_path isEqualToString:[PlayListModel share].currentVideo.path];
}




#pragma VLCMediaThumbnailerDelegate
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    //获取失败
    currentThumbnailLoadingCount = 0;
    [currentThumbnailLoadingArr removeObject:self];
    [[currentThumbnailLoadingArr firstObject] loadThumnbnail:[currentThumbnailLoadingArr firstObject].delegate];
    
    if(_delegate)[_delegate thumbnailLoaded:nil];
}
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    //获取成功
    currentThumbnailLoadingCount = 0;
    [currentThumbnailLoadingArr removeObject:self];
    [[currentThumbnailLoadingArr firstObject] loadThumnbnail:[currentThumbnailLoadingArr firstObject].delegate];
    
    if(thumbnail == nil) return;
    
    NSLog(@"获取成功:%@",[self.path lastPathComponent]);
    NSImage* image  = [[NSImage alloc] initWithCGImage:thumbnail size:NSMakeSize(VideoCellWidth, VideoCellHeight)];
    if(image)[self SaveThumbnail:image];
    NSLog(@"图片存放成功");
    if(_delegate)[_delegate thumbnailLoaded:image];
    
}
















//保存图片
-(void)SaveThumbnail:(NSImage*)thumbnail{
    
    
    NSData *imageData = [thumbnail TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    [imageRep setSize:thumbnail.size];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:@{}];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[[self getThumbnailShouldSavePath] stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    [imageData writeToFile:[self getThumbnailShouldSavePath] atomically:YES];
 
    _thumbnailPath = [self getThumbnailShouldSavePath];
    [[PlayListModel share] updateData];
}

//随便算一下文件名字
-(NSString*)getThumbnailShouldSavePath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"XHPlayerVideo"];
    path = [path stringByAppendingPathComponent:@"thumbnail"];
    path = [path stringByAppendingPathComponent:[self md5:self.path]];
    path = [path stringByAppendingString:@".png"];
    return path;
}

- (NSString *)md5:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}
@end

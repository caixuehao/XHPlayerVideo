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
  
    //确保只进来一次
    if (_delegate == nil) {
        VLCMediaThumbnailer * mt = [VLCMediaThumbnailer thumbnailerWithMedia:self.media andDelegate:self];
        mt.thumbnailHeight = VideoCellHeight;
        mt.thumbnailWidth = VideoCellWidth;
        mt.snapshotPosition = 0.2;//视频帧位置
        [mt fetchThumbnail];
    }
    _delegate = delegate;
}

//播放
-(void)play{
    [[PlayListModel share] setCurrentVideo:self];
}

//判断是否相等
-(BOOL)isEqualtoVideoModel:(VideoModel*)aVideoModel{
    return [_path isEqualToString:aVideoModel.path];
}





#pragma VLCMediaThumbnailerDelegate
- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    //获取失败
    if(_delegate)[_delegate thumbnailLoaded:nil];
}
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    //获取成功
    //保存图片
    NSImage* image  = [[NSImage alloc] initWithCGImage:thumbnail size:NSMakeSize(VideoCellWidth, VideoCellHeight)];
    [self SaveThumbnail:image];
    
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
    [[PlayListModel share] saveData];
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

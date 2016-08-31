//
//  XHVideo.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VLCKit/VLCKit.h>

@interface VideoModel : NSObject

@property(nonatomic,readonly)NSString* path;
@property(nonatomic,readonly)VLCMedia* media;
@property(nonatomic,readonly)NSString* thumbnailPath;


//用本地读取的数据创建对象
-(instancetype)initWithData:(NSDictionary*)data;

//用路径初始化一个视频对象
-(instancetype)initWithPath:(NSString*)path;

//把所有数据做成一个字典方便保存
-(NSDictionary*)getData;

//播放
-(void)play;

//判断是否相等
-(BOOL)isEqualtoVideoModel:(VideoModel*)aVideoModel;

//存放略缩图 随便根据路径md5算一下
-(void)SaveThumbnail:(NSImage*)thumbnail;
@end

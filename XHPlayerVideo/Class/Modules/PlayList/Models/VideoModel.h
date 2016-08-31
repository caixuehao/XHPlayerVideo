//
//  XHVideo.h
//  XHPlayerVideo
//
//  Created by C on 16/8/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <VLCKit/VLCKit.h>

@interface VideoModel : NSObject

@property(nonatomic)NSString* path;
//@property(nonatomic,weak)VLCMedia* media;
//播放
-(void)play;

//判断是否相等
-(BOOL)isEqualtoVideoModel:(VideoModel*)aVideoModel;

//把所有数据做成一个字典方便保存
-(NSDictionary*)getData;

//用本地读取的数据创建对象
-(instancetype)initWithData:(NSDictionary*)data;

@end

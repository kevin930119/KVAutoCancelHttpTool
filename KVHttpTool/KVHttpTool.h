//
//  KVHttpTool.h
//  KVAutoCancelHttpTool
//
//  Created by kevin on 2018/4/16.
//  Copyright © 2018年 kv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+KVHttp.h"
//快速创建一个弱引用类型的对象（用于block）
#define KV_WO(object,weakObject) __weak __typeof(&*object)weakObject = object
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, KVHttpResponseCode) {
    KVHttpResponseCode_Success, //成功
    KVHttpResponseCode_Cancelled,  //被取消
    KVHttpResponseCode_Fail //失败
};

typedef void(^KVHTTPResponseHandle)(KVHttpResponseCode code, NSInteger statusCode, NSDictionary * responseHeaderFields, id responseObject);

@interface KVHttpTool : NSObject

/**
 Get请求

 @param url 请求链接
 @param params 参数
 @param object 可以释放的对象，用于自动取消网络任务，不需要自动取消可以传nil
 @param handler 回调
 @return 网络请求任务
 */
+ (NSURLSessionDataTask*)getWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler;

/**
 Post请求

 @param url 请求链接
 @param params 参数
 @param object 可以释放的对象，用于自动取消网络任务，不需要自动取消可以传nil
 @param handler 回调
 @return 网络请求任务
 */
+ (NSURLSessionDataTask*)postWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler;

/**
 Put请求

 @param url 请求链接
 @param params 参数
 @param object 可以释放的对象，用于自动取消网络任务，不需要自动取消可以传nil
 @param handler 回调
 @return 网络请求任务
 */
+ (NSURLSessionDataTask*)putWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler;

/**
 停止所有请求
 */
+ (void)stopAllRequest;

//其他诸如同步请求，下载任务，自行实现，本Demo仅演示如何实现自动取消网络请求。

@end

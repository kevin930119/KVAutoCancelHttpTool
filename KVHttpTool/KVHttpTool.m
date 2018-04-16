//
//  KVHttpTool.m
//  KVAutoCancelHttpTool
//
//  Created by kevin on 2018/4/16.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "KVHttpTool.h"

@interface KVHttpTool ()

@property (nonatomic, strong) AFHTTPSessionManager * manager;

@end

@implementation KVHttpTool

+ (instancetype)sharedHttpTool {
    static KVHttpTool * kvhttpTool = nil;
    static dispatch_once_t kvhttpToolToken;
    dispatch_once(&kvhttpToolToken, ^{
        kvhttpTool = [[KVHttpTool alloc] init];
    });
    return kvhttpTool;
}

- (instancetype)init {
    if (self = [super init]) {
        //默认配置，如果需要修改，可自行修改，如果需要配置https，也自行配置
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 60;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    }
    return self;
}

+ (NSURLSessionDataTask*)getWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    KV_WO(object, wobject);
    if (!wobject.kvHttpObject) {
        //为该释放对象添加一个监听释放过程的响应对象
        wobject.kvHttpObject = [[KVHttpResponseObject alloc] init];
    }
    NSURLSessionDataTask * task = [[KVHttpTool sharedHttpTool].manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [wobject.kvHttpObject.httpTasks removeObject:task]; //响应对象移除该请求任务
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //处理回调结果
        [self handleHttpResponse:YES task:task responseObject:responseObject error:nil handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [wobject.kvHttpObject.httpTasks removeObject:task]; //响应对象移除该请求任务
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //处理回调结果
        [self handleHttpResponse:NO task:task responseObject:nil error:error handler:handler];
    }];
    [wobject.kvHttpObject.httpTasks addObject:task];    //响应对象添加该请求任务，如果释放对象释放了，那么响应对象会自动取消掉所持有的所有未完成请求任务
    return task;
}

+ (NSURLSessionDataTask*)postWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    KV_WO(object, wobject);
    if (!wobject.kvHttpObject) {
        wobject.kvHttpObject = [[KVHttpResponseObject alloc] init];
    }
    NSURLSessionDataTask * task = [[KVHttpTool sharedHttpTool].manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [wobject.kvHttpObject.httpTasks removeObject:task];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self handleHttpResponse:YES task:task responseObject:responseObject error:nil handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [wobject.kvHttpObject.httpTasks removeObject:task];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self handleHttpResponse:NO task:task responseObject:nil error:error handler:handler];
    }];
    [wobject.kvHttpObject.httpTasks addObject:task];
    return task;
}

+ (NSURLSessionDataTask*)putWithUrl:(NSString*)url params:(NSDictionary*)params object:(NSObject*)object handler:(KVHTTPResponseHandle)handler {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    KV_WO(object, wobject);
    if (!wobject.kvHttpObject) {
        wobject.kvHttpObject = [[KVHttpResponseObject alloc] init];
    }
    NSURLSessionDataTask * task = [[KVHttpTool sharedHttpTool].manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [wobject.kvHttpObject.httpTasks removeObject:task];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self handleHttpResponse:YES task:task responseObject:responseObject error:nil handler:handler];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [wobject.kvHttpObject.httpTasks removeObject:task];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self handleHttpResponse:NO task:task responseObject:nil error:error handler:handler];
    }];
    [wobject.kvHttpObject.httpTasks addObject:task];
    return task;
}

+ (void)handleHttpResponse:(BOOL)isSuccess task:(NSURLSessionDataTask*)task responseObject:(id)responseObject error:(NSError*)error handler:(KVHTTPResponseHandle)handler {
    if (isSuccess) {
        if (handler) {
            NSInteger statusCode = 200;
            NSDictionary * headers = nil;
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)task.response;
                statusCode = urlResponse.statusCode;
                headers = urlResponse.allHeaderFields;
            }
            handler(KVHttpResponseCode_Success, statusCode, headers, responseObject);
        }
    }else {
        if (handler) {
            NSInteger statusCode = 0;
            NSDictionary * headers = nil;
            KVHttpResponseCode code = KVHttpResponseCode_Fail;
            if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse*)task.response;
                statusCode = urlResponse.statusCode;
                headers = urlResponse.allHeaderFields;
            }
            if (error.code == -999) {
                //被取消的
                code = KVHttpResponseCode_Cancelled;
            }
            handler(code, statusCode, headers, nil);
        }
    }
}

+ (void)stopAllRequest {
    [[KVHttpTool sharedHttpTool].manager.operationQueue cancelAllOperations];
}

@end

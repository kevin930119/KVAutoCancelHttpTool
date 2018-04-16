//
//  KVHttpResponseObject.m
//  ARTFIRE
//
//  Created by kevin on 2017/2/22.
//  Copyright © 2017年 yiye. All rights reserved.
//

#import "KVHttpResponseObject.h"

@implementation KVHttpResponseObject

- (instancetype)init {
    if (self = [super init]) {
        self.httpTasks = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    if (self.httpTasks.count) {
        for (id object in self.httpTasks) {
            if ([object isKindOfClass:[NSURLSessionDataTask class]]) {
                [((NSURLSessionDataTask*)object) cancel];   //取消任务
            }
        }
    }
}

@end

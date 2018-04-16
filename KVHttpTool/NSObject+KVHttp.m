//
//  NSObject+KVHttp.m
//  ARTFIRE
//
//  Created by kevin on 2017/2/22.
//  Copyright © 2017年 yiye. All rights reserved.
//

#import "NSObject+KVHttp.h"
#import <objc/runtime.h>

@implementation NSObject (KVHttp)

- (KVHttpResponseObject*)kvHttpObject {
    KVHttpResponseObject * object = objc_getAssociatedObject(self, "kvHttpObject");
    return object;
}

- (void)setKvHttpObject:(KVHttpResponseObject *)kvHttpObject {
    objc_setAssociatedObject(self, "kvHttpObject", kvHttpObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

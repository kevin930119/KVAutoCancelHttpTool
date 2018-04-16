//
//  NSObject+KVHttp.h
//  ARTFIRE
//
//  Created by kevin on 2017/2/22.
//  Copyright © 2017年 yiye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVHttpResponseObject.h"

@interface NSObject (KVHttp)
//网络请求对象
@property (nonatomic, strong) KVHttpResponseObject * kvHttpObject;

@end

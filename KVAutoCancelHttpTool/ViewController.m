//
//  ViewController.m
//  KVAutoCancelHttpTool
//
//  Created by kevin on 2018/4/16.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewController.h"
#import "KVHttpTool.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSURLSessionDataTask * _task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主页面";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [self getBtnWithTitle:@"开始请求" sel:@selector(beginTask:) frame:CGRectMake(0, 0, 100, 40)];
    [self.view addSubview:btn];
    btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0 - 80);
    
    UIButton * btn1 = [self getBtnWithTitle:@"取消请求" sel:@selector(cancleTask:) frame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y + btn.frame.size.height + 40, btn.frame.size.width, btn.frame.size.height)];
    [self.view addSubview:btn1];
    
    UIButton * btn2 = [self getBtnWithTitle:@"跳转页面" sel:@selector(jump) frame:CGRectMake(btn.frame.origin.x, btn1.frame.origin.y + btn1.frame.size.height + 40, btn.frame.size.width, btn.frame.size.height)];
    [self.view addSubview:btn2];
}

- (UIButton*)getBtnWithTitle:(NSString*)title sel:(SEL)selector frame:(CGRect)frame {
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor blackColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)beginTask:(UIButton*)btn {
    //
    NSMutableDictionary * param = nil;
    //添加参数
//    param = [NSMutableDictionary dictionary];
//    [param setObject:@"1" forKey:@"version"]
    //替换为自己接口的地址
    _task = [KVHttpTool getWithUrl:@"http://www.baidu.com" params:param object:self handler:^(KVHttpResponseCode code, NSInteger statusCode, NSDictionary *responseHeaderFields, id responseObject) {
        if (code == KVHttpResponseCode_Success) {
            NSLog(@"成功");
        }else if (code == KVHttpResponseCode_Cancelled) {
            NSLog(@"被取消");
        }else {
            NSLog(@"失败");
        }
        NSLog(@"%ld %@ %@", statusCode, responseHeaderFields, NSStringFromClass([responseObject class]));
    }];
}

- (void)cancleTask:(UIButton*)btn {
    [_task cancel];
}

- (void)jump {
    TwoViewController * vc = [[TwoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

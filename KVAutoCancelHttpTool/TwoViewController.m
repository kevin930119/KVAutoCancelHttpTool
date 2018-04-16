//
//  TwoViewController.m
//  KVAutoCancelHttpTool
//
//  Created by kevin on 2018/4/16.
//  Copyright © 2018年 kv. All rights reserved.
//

#import "TwoViewController.h"
#import "KVHttpTool.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [self getBtnWithTitle:@"开始请求" sel:@selector(beginTask:) frame:CGRectMake(0, 0, 100, 40)];
    [self.view addSubview:btn];
    btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2.0, [UIScreen mainScreen].bounds.size.height / 2.0);
}

- (void)beginTask:(UIButton*)btn {
    NSMutableDictionary * param = nil;
    //添加参数
    //param = [NSMutableDictionary dictionary];
    //[param setObject:@"1" forKey:@"version"];
    [KVHttpTool getWithUrl:@"https://www.artfire.com.cn/YihuoService/services/groupchat/getcrhomepagedata" params:param object:nil handler:^(KVHttpResponseCode code, NSInteger statusCode, NSDictionary *responseHeaderFields, id responseObject) {
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

@end

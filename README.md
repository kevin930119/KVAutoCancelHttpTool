# KVAutoCancelHttpTool
基于AFNetworking封装，能够自动取消网络请求任务的工具

# 1 使用方法
## 1.1 GET
```
NSMutableDictionary * param = nil;
//添加参数
//param = [NSMutableDictionary dictionary];
//[param setObject:@"1" forKey:@"version"];
KV_WS(weakSelf);
[KVHttpTool getWithUrl:@"自己的接口请求地址" params:param object:self handler:^(KVHttpResponseCode code, NSInteger statusCode, NSDictionary *responseHeaderFields, id responseObject) {
if (code == KVHttpResponseCode_Success) {
NSLog(@"成功");
}else if (code == KVHttpResponseCode_Cancelled) {
NSLog(@"被取消");
}else {
NSLog(@"失败");
}
NSLog(@"%ld %@ %@", statusCode, responseHeaderFields, NSStringFromClass([responseObject class]));
[weakSelf hahaha];  //必须得做好内存管理，这是做好程序的前提，不然自动取消也不好使
//        [self hahaha];
}];
```
## 1.2 POST
&emsp;&emsp;同1.1。
## 1.3 PUT
&emsp;&emsp;同1.1.
# 2 注意事项
&emsp;&emsp;由于使用的是监听释放对象的释放来实现的自动取消，所以必须得做好释放对象的内存管理，保证释放对象能够被正常释放，一般释放对象传入当前控制器即可，也可以根据需要传入其他对象，只要保证释放对象能够被正常释放即可，而且做好内存管理也是我们身为iOS程序员的责任，我想不到任何理由让你不去做好内存管理。
&emsp;&emsp;另外，我们也可以利用KVAutoCancelHttpTool去判断当前控制器的生命周期是否正常，如果发现当你退出页面时，小菊花还在转，那么就去检查一遍是否哪里内存泄漏了吧。

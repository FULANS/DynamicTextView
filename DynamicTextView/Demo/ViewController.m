//
//  ViewController.m
//  Demo
//
//  Created by 王郑 on 16/6/29.
//  Copyright © 2016年 王郑. All rights reserved.
//

#import "ViewController.h"
#import "DynamicTextView.h"
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenwidth (kScreenBounds.size.width)
#define kScreenheight (kScreenBounds.size.height)
@interface ViewController ()

@property (strong, nonatomic) DynamicTextView *dynamicTextView;

@end

@implementation ViewController

// 懒加载
-(DynamicTextView *)dynamicTextView
{
    if (!_dynamicTextView) {
        
        // 初始化:
        _dynamicTextView = [[DynamicTextView alloc] initWithFrame:CGRectMake(0,kScreenheight - 49, kScreenwidth, 49)];
        // 点击textview弹出键盘时背景view的颜色
        _dynamicTextView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_dynamicTextView setPlaceholderText:@"请输入文字"];
        
        // 点击按钮后的输出操作:
        _dynamicTextView.DynamicTextViewBlock = ^(NSString *text) {
            
            NSLog(@"输出啦:%@",text);
        };
    }
    return _dynamicTextView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.dynamicTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DynamicTextView.m
//  Demo
//
//  Created by 王郑 on 16/6/29.
//  Copyright © 2016年 王郑. All rights reserved.
//

#import "DynamicTextView.h"
#import "Masonry.h"
#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenwidth (kScreenBounds.size.width)
#define kScreenheight (kScreenBounds.size.height)
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

@interface DynamicTextView()<UITextViewDelegate,UIScrollViewDelegate> {
    
    BOOL statusTextView; // 当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
}

@property (nonatomic, strong) UIView *backGroundView; // 背景view
@property (nonatomic, strong) UITextView *textView; // 背景view上的输入框
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *sendButton; // 背景view上的发送按钮

@end


@implementation DynamicTextView

// 重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        // 对键盘进行监听:
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    // 点击空白区域,键盘回收
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    
    return self;
    
}

- (void)centerTapClick {
    
    [_textView resignFirstResponder];
}

- (void)createUI {
    
    // 利用Masonry进行布局:
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        // make 代表约束
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(kScreenwidth-65);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.placeholderLabel.backgroundColor = [UIColor blueColor];
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(39);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
    
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    // 修改, 设置整个self的frame为全屏大小
    self.frame = kScreenBounds;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        
        self.backGroundView.frame = CGRectMake(0, kScreenheight-height-49, kScreenwidth, 49);
    }else{
        CGRect rect = CGRectMake(0, kScreenheight - self.backGroundView.frame.size.height-height, kScreenwidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, 0, kScreenwidth, 49);
        self.frame = CGRectMake(0, kScreenheight-49, kScreenwidth, 49); // 把整个self的frame变为初始大小
    }else{
        CGRect rect = CGRectMake(0, 0, kScreenwidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(0, kScreenheight - rect.size.height, kScreenwidth, self.backGroundView.frame.size.height);
    }
}


#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    /**
     *  设置占位符
     */
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        [self.sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        [self.sendButton setBackgroundColor:UIColorRGB(70 , 163, 231)];
        self.sendButton.userInteractionEnabled = YES;
    }
    
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(kScreenwidth-65, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - 49, kScreenwidth, 49);
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - textView.contentSize.height-10, kScreenwidth,textView.contentSize.height+10);
        NSLog(@"%lf",self.backGroundView.frame.size.height);
    }else{
        // 当文字内容高度超过设定的最大值时,textview不会在变高,不做任何操作
        statusTextView = YES;
        return;
    }
    
}

#pragma  mark -- 发送事件
- (void)sendClick:(UIButton *)sender{
    [self.textView endEditing:YES];
    if (self.DynamicTextViewBlock) {
        self.DynamicTextViewBlock(self.textView.text);
    }
    
    //---- 发送成功之后清空 ------//
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    [self.sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
    self.sendButton.userInteractionEnabled = NO;
    self.frame = CGRectMake(0, kScreenheight-49, kScreenwidth, 49);
    self.backGroundView.frame = CGRectMake(0, 0, kScreenwidth, 49);
}



#pragma mark --- 懒加载控件
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 49)];
        _backGroundView.backgroundColor = UIColorRGB(230, 230, 230);
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.textColor = [UIColor grayColor];
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setBackgroundColor:UIColorRGB(180, 180, 180)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }else{
        
    }
}





@end

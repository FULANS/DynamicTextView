//
//  DynamicTextView.h
//  Demo
//
//  Created by 王郑 on 16/6/29.
//  Copyright © 2016年 王郑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MaxTextViewHeight 80 //限制文字输入的高度
@interface DynamicTextView : UIView
/**
 *  发送文本
 */
@property (copy, nonatomic) void (^DynamicTextViewBlock)(NSString *text);

/**
 *  设置占位符
 */
- (void)setPlaceholderText:(NSString *)text;
@end

//
//  UIView+LZFrame.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/3.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LZFrame)

/// x
@property (nonatomic) CGFloat lz_x;
/// y
@property (nonatomic) CGFloat lz_y;
/// 宽
@property (nonatomic) CGFloat lz_width;
/// 高
@property (nonatomic) CGFloat lz_height;
/// 底部y值
@property (nonatomic) CGFloat lz_bottom;
/// 右侧x值
@property (nonatomic) CGFloat lz_right;
/// 中心点x
@property (nonatomic) CGFloat lz_centerX;
/// 中心点y
@property (nonatomic) CGFloat lz_centerY;
/// (x,y)坐标
@property (nonatomic) CGPoint lz_origin;
/// 大小
@property (nonatomic) CGSize lz_size;

@end

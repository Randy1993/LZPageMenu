//
//  LZPageMenuHeader.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/3.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#ifndef LZPageMenuHeader_h
#define LZPageMenuHeader_h

/// 当前设备的屏幕宽度
#define LZ_ScreenWidth ([UIScreen mainScreen].bounds.size.width)
/// 当前设备的屏幕高度
#define LZ_ScreenHeight ([UIScreen mainScreen].bounds.size.height)
// iPhone X 宏定义
#define  LZ_iPhoneX (LZ_ScreenWidth == 375.f && LZ_ScreenHeight == 812.f ? YES : NO)
// 适配iPhone X 导航栏高度
#define  LZ_NavHeight (LZ_iPhoneX ? 88.f : 64.f)

/// weakSelf
#define LZWeakSelf(weakSelf) __weak __typeof(self) weakSelf = self;
/// strongSelf
#define LZStrongSelf(strongSelf) __strong __typeof(&*weakSelf) strongSelf = weakSelf;

#import "UIView+LZFrame.h"
#import "LZPageMenuPropertyManager.h"

#endif /* LZPageMenuHeader_h */

//
//  LZPageMenu.h
//  LZPageMenu
//
//  Created by Randy Liu on 2017/12/25.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPageMenuProtocols.h"

/**
 使用方式：调用initWithFrame--->设置属性--->调用reloadData--->添加LZPageMenu的view到父视图。
 
 1、可以自定义Item，需要设置customMenuItem并实现相关协议方法。
 2、LZPageMenuPropertyProtocol中显示LZPageMenu的所有外部可用属性。
 
 处于优化的小考虑，菜单采用UICollectionView实现，在同一时刻内存和图层中只有一个子控制器的显示。
 */
@interface LZPageMenu : UIViewController<LZPageMenuPropertyProtocol>

#pragma mark - PageMenu
/// 代理
@property (nonatomic, weak) id<LZPageMenuDelegate> delegate;

#pragma mark - 外部方法
/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

@end

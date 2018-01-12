//
//  LZPageMenu.h
//  LZPageMenu
//
//  Created by Randy Liu on 2017/12/25.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZPageMenuPropertyProtocol.h"

@class LZPageMenu;

@protocol LZPageMenuDelegate <NSObject>

@optional

/**
 添加了新的页面
 */
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;

/**
 头部发生的偏移, stretchHeaderView = NO
 */
- (void)headerViewOffsetY:(CGFloat)offsetY;

/**
 进行拉伸时头部发生的偏移和高度的变化值,stretchHeaderView = YES
 */
- (void)headerViewOffsetY:(CGFloat)offsetY heightOffset:(CGFloat)offsetHeight;

/**
 子控制器UISCrollView的滚动
 */
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;

/**
 子控制器UISCrollView结束滚动
 */
- (void)subScrollViewDidEndScroll:(UIScrollView *)scrollView;
@end

/**
 使用方式：调用initWithFrame--->设置属性--->调用reloadData--->添加LZPageMenu的view到父视图。
 
 1、可以自定义Item，需要设置customMenuItem并实现相关协议方法。
 2、LZPageMenuPropertyProtocol中显示LZPageMenu的所有外部可用属性。
 
 处于优化的小考虑，菜单采用UICollectionView实现，在同一时刻内存和图层中只有一个子控制器的显示。
 */
@interface LZPageMenu : UIViewController<LZPageMenuPropertyProtocol>

#pragma mark - PageMenu
/// 代理
@property (nonatomic, assign) id<LZPageMenuDelegate> delegate;

#pragma mark - 外部方法
/**
 初始化
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 刷新数据，赋值玩所有属性后调用
 */
- (void)reloadData;

/**
 刷新所有的标题, 需要提前设置menuItemTitles属性
 */
- (void)updateAllItemTitle;

@end

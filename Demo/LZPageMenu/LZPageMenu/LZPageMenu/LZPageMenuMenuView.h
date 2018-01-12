//
//  LZPageMenuMenuView.h
//  LZPageMenu
//
//  Created by Randy Liu on 2017/12/25.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZPageMenuPropertyManager;

@interface LZPageMenuMenuViewCell : UICollectionViewCell

/// 标题
@property (nonatomic, weak) UILabel *titleLabel;
/// 自定义视图
@property (nonatomic, weak) UIView *customView;
/// 垂直分割线
@property (nonatomic, weak, readonly) CALayer *verticalSeparator;
/// 属性管理器
@property (nonatomic, strong) LZPageMenuPropertyManager *propertyManager;

@end

/**
 社区分段选择视图
 */
@interface LZPageMenuMenuView : UICollectionView

/// 点击item
@property (nonatomic, strong) void(^selectedItemBlock)(CGRect frame, NSInteger index);
/// 属性管理器
@property (nonatomic, strong) LZPageMenuPropertyManager *propertyManager;

- (void)refreshCell:(NSInteger)selectedIndex;

@end

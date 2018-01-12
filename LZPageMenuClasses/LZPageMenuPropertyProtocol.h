//
//  LZPageMenuPropertyProtocol.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LZPageMenuCustomProtocol.h"

typedef NS_ENUM(NSUInteger, LZSelectionIndicatorType) {
    /// 线条指示线，
    LZSelectionIndicatorTypeLine = 1 << 0,
    /// 圆形指示线，直径为高度
    LZSelectionIndicatorTypeDot  = 1 << 1,
    /// 指示线图片
    LZSelectionIndicatorTypeImage  = 1 << 2,
    /// 方块指示
    LZSelectionIndicatorTypeBlock  = 1 << 3,
    /// 实心椭圆指示
    LZSelectionIndicatorTypeSolidOval  = 1 << 4,
    /// 空心椭圆指示
    LZSelectionIndicatorTypeSolidHollowOval = 1 << 5
};

@protocol LZPageMenuPropertyProtocol <NSObject>

@optional

#pragma mark - PageMenu
/// 进行自定义的代理
@property (nonatomic, weak) id<LZPageMenuCustomProtocol> customDelegate;
/// LZPageMenu的背景色
@property (nonatomic, strong) UIColor *pageMenuBackgroundColor;
/// 控制器数组
@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;
/// 未选中富文本标题。默认不使用该属性，标题为控制器的标题。
@property (nonatomic, strong) NSMutableArray<NSAttributedString *> *menuItemUnSelectedTitles;
/// 选中富文本标题，可以不设置。默认不使用该属性，标题为控制器的标题或者为未选中的标题
@property (nonatomic, strong) NSMutableArray<NSAttributedString *> *menuItemSelectedTitles;
/// 设置默认选中
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

#pragma mark - 菜单栏Item指示线
/// 是否显示指示线，默认显示
@property (nonatomic, assign) BOOL needShowSelectionIndicator;
/// 指示线高度, 默认为2
@property (nonatomic, assign) CGFloat selectionIndicatorHeight;
/// 指示线偏移，即上下左右缩进的距离，该值会影响指示线的宽高。Dot和Image类型默认居中，线条、椭圆等默认与菜单Item等宽登高，默认为（0，0，0，0）
@property (nonatomic, assign) UIEdgeInsets selectionIndicatorOffset;
/// 指示线的颜色，默认为白色
@property (nonatomic, strong) UIColor *selectionIndicatorColor;
/// 指示线的形状，默认为线条
@property (nonatomic, assign) LZSelectionIndicatorType selectionIndicatorType;
/// 当指示线为SelectionIndicatorTypeImage类型时，该值才有用
@property (nonatomic, strong) UIImage *selectionIndicatorImage;
/// 当指示线为SelectionIndicatorTypeImage类型时,控制图片的宽度，如果不设置该值，将默认居中显示，并取图片的原有宽度
@property (nonatomic, assign) CGFloat selectionIndicatorImageWidth;
/// 是否让指示线与文本等宽，此值在自定义宽度、item宽度均分时起作用， 默认为YES
@property (nonatomic, assign) BOOL selectionIndicatorWithEqualToTextWidth;

#pragma mark - 菜单底部整体线条
/// 底部线高度，设置该值大于0，将会显示菜单底部线条
@property (nonatomic, assign) CGFloat menuBottomLineHeight;
/// 底部线颜色
@property (nonatomic, strong) UIColor *menuBottomLineColor;

#pragma mark - Menu
/// 菜单背景色
@property (nonatomic, strong) UIColor *menuBackgroundColor;
/// 菜单高度
@property (nonatomic, assign) CGFloat menuHeight;
/// 菜单的frame，当菜单需要显示在导航栏之上时可设置该属性
@property (nonatomic, assign) CGFloat menuFrame;
/// 设置菜单的偏移，实际上设置UICollectionView的frame，这种偏移会导致在滚动式头尾有部分被遮挡的效果，默认为Zero
@property (nonatomic, assign) UIEdgeInsets menuInset;
/// 设置菜单内容的偏移，实际上设置UICollectionView的contentInset偏移，这种偏移不会导致遮挡效果，默认为（0.0, 15.0, 0.0, 15.0）
@property (nonatomic, assign) UIEdgeInsets menuContentInset;
/// 是否允许回弹，默认为YES
@property (nonatomic, assign) BOOL enableHorizontalBounce;
/// 是否允许菜单滚动
@property (nonatomic, assign) BOOL enableScroll;
/// 菜单的宽度
@property (nonatomic, assign) CGFloat menuWidth;
/// item宽度是否均分menu宽度，需要设置menuWidth，否则取屏幕宽度。此值对自定义菜单无效。
@property (nonatomic, assign) BOOL averageMenuWitdh;

#pragma mark - MenuItem
/// 选中颜色
@property (nonatomic) UIColor *selectedMenuItemLabelColor;
/// 未选中颜色
@property (nonatomic) UIColor *unselectedMenuItemLabelColor;
/// 选中标题字体
@property (nonatomic) UIFont *selectedMenuItemLabelFont;
/// 未选中标题字体
@property (nonatomic) UIFont *unselectedMenuItemLabelFont;
/// Item之间的空隙，默认为15.0
@property (nonatomic, assign) CGFloat menuItemSpace;
/// Item选中宽度(数组)。默认不使用该属性，默认为文本的宽度，当需要自定义宽度时设置该属性
@property (nonatomic, copy) NSArray *menuItemSelectedWidths;
/// Item未选中宽度(数组)。默认不使用该属性，默认为文本的宽度，当需要自定义宽度时设置该属性
@property (nonatomic, copy) NSArray *menuItemUnSelectedWidths;
/// Item的宽度是否根据文本宽度进行确定, 默认为YES
@property (nonatomic, assign) BOOL menuItemWidthBasedOnTitleTextWidth;
/// 选中Item视图滚动动画的持续时间(秒),默认为0.5
@property (nonatomic, assign) CGFloat scrollAnimationDurationOnMenuItemTap;

#pragma mark - MenuItem垂直分割线
/// 垂直分割线宽度，设置该值大于0将显示垂直分割线
@property (nonatomic, assign) CGFloat verticalSeparatorWidth;
/// 垂直分割线高度
@property (nonatomic, assign) CGFloat verticalSeparatorHeight;
/// 垂直分割线颜色
@property (nonatomic, strong) UIColor *verticalSeparatorColor;
/// 隐藏最后一个Item的分割线，默认为YES
@property (nonatomic, assign) BOOL hideLastVerticalSeparator;

#pragma mark - 将菜单显示在导航栏
/// 将菜单显示在导航栏，请在添加PageMenu至父视图后reloadData
@property (nonatomic, assign) BOOL showMenuInNavigationBar;

#pragma mark - 带头部视图
/// 头部视图
@property (nonatomic, strong) UIView *headerView;
/// 头部视图的高度
@property (nonatomic, assign) CGFloat headerViewHeight;
/// 头部是否进行拉伸，默认为YES
@property (nonatomic, assign) BOOL stretchHeaderView;
/// 头部缩放、偏移的最大比例，默认0.5
@property (nonatomic, assign) CGFloat headerViewMaxmumOffsetRate;
/// 头部视图顶端安全距离，上滑到达极限时，菜单之上所流出的距离
@property (nonatomic, assign) CGFloat headerViewTopSafeDistance;
/// 头部视图底部安全距离，底部会留出一段安全距离
@property (nonatomic, assign) CGFloat headerViewBottomSafeDistance;

@end

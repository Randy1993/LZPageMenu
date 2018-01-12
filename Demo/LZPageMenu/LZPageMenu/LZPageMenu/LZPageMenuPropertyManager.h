//
//  LZPageMenuPropertyManager.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZPageMenuPropertyProtocol.h"

typedef NS_ENUM(NSUInteger, LZPageMenuItemType) {
    LZPageMenuItemTypeViewControllerTitle,
    LZPageMenuItemTypeCustomView,
    LZPageMenuItemTypeAverageWidth,
    LZPageMenuItemTypeCustomWidth,
    LZPageMenuItemTypeAttribute
};

@interface LZPageMenuPropertyManager : NSObject<LZPageMenuPropertyProtocol>

/// item未选中的宽度，用户不允许使用的属性
@property (nonatomic, strong, readonly) NSMutableArray *itemUnselectedWidths;
/// item选中的宽度，用户不允许使用的属性
@property (nonatomic, strong, readonly) NSMutableArray *itemSelectedWidths;
/// item未选中文本的宽度，用户不允许使用的属性
@property (nonatomic, strong, readonly) NSMutableArray *itemUnselectedTextWidths;
/// item选中文本的宽度，用户不允许使用的属性
@property (nonatomic, strong, readonly) NSMutableArray *itemSelectedTextWidths;
/// itemType
@property (nonatomic, assign, readonly) LZPageMenuItemType menuItemType;
/// 最后选中的Index，用户不允许使用的属性
@property (nonatomic, assign) NSInteger lastSelectedIndex;
/// 开始滚动时的Index
@property (nonatomic, assign) NSInteger startScrollIndex;
/// 是否显示指示块在最底层
@property (nonatomic, assign) BOOL showIndicatorInLowestLayer;
/// 是否点击了菜单
@property (nonatomic, assign) BOOL hadTapMenu;
/// 为了解决指示块被cell遮挡
@property (nonatomic, strong) void(^setIndicatorHierarchy)(void);

/**
 计算所有item的宽度
 */
- (void)caclulateItemWidth;

/**
 获取选中item的宽度
 */
- (CGFloat)selectedWidth:(NSInteger)index;

/**
 获取未选中item的宽度
 */
- (CGFloat)unSelectedWidth:(NSInteger)index;

/**
 当item宽度均分、自定义宽度时需要进行frame的特殊计算
 */
- (CGRect)getSpecialFrame:(CGRect)cellFrame index:(NSInteger)index;
@end

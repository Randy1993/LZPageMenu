//
//  LZPageMenuPropertyManager.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "LZPageMenuPropertyManager.h"

@implementation LZPageMenuPropertyManager

/// 这些属性皆为外接属性，供用户使用
@synthesize customDelegate, pageMenuBackgroundColor, viewControllers, menuItemUnSelectedTitles, menuItemSelectedTitles,
            needShowSelectionIndicator, selectionIndicatorHeight, selectionIndicatorOffset, selectionIndicatorColor, selectionIndicatorType, selectionIndicatorImage,selectionIndicatorImageWidth, selectionIndicatorWithEqualToTextWidth,
            menuBottomLineHeight, menuBottomLineColor, menuBackgroundColor, menuHeight, menuFrame, menuInset, menuContentInset, enableHorizontalBounce, defaultSelectedIndex, enableScroll, averageMenuWitdh,
            selectedMenuItemLabelColor, unselectedMenuItemLabelColor, selectedMenuItemLabelFont, unselectedMenuItemLabelFont, menuItemSpace, menuItemSelectedWidths, menuItemUnSelectedWidths, menuItemWidthBasedOnTitleTextWidth, scrollAnimationDurationOnMenuItemTap,
            verticalSeparatorWidth, verticalSeparatorHeight, verticalSeparatorColor, hideLastVerticalSeparator,
            showMenuInNavigationBar, menuWidth,
            headerView, headerViewHeight, headerViewTopSafeDistance, headerViewBottomSafeDistance, stretchHeaderView, headerViewMaxmumOffsetRate;

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _itemSelectedWidths = [NSMutableArray array];
        _itemUnselectedWidths = [NSMutableArray array];
        _lastSelectedIndex = -1;
        _showIndicatorInLowestLayer = YES;
    }
    return self;
}

#pragma mark - 公有方法
- (void)caclulateItemWidth {
    [_itemSelectedWidths removeAllObjects];
    [_itemUnselectedWidths removeAllObjects];
    
    CGFloat width = 0;
    
    // 存在自定义视图
    if (self.customDelegate) {
        _menuItemType = LZPageMenuItemTypeCustomView;
        
        for (int i = 0; i < self.viewControllers.count; i++) {
            if ([self.customDelegate respondsToSelector:@selector(menuItemSelectedWidth:)]) {
                width = [self.customDelegate menuItemSelectedWidth:i];
                
                [_itemSelectedWidths addObject:@(width)];
            }
            
            if ([self.customDelegate respondsToSelector:@selector(menuItemUnselectedWidth:)]) {
                width = [self.customDelegate menuItemUnselectedWidth:i];
                
                [_itemUnselectedWidths addObject:@(width)];
            }
        }
        
        return;
    }
    
    // 设置了自定义宽度
    if (!self.menuItemWidthBasedOnTitleTextWidth && (self.menuItemSelectedWidths.count > 0 || self.menuItemUnSelectedWidths.count)) {
        _menuItemType = LZPageMenuItemTypeCustomWidth;
        if (self.menuItemSelectedWidths.count > 0) [_itemSelectedWidths addObjectsFromArray:self.menuItemSelectedWidths];
        if (self.menuItemUnSelectedWidths.count > 0) [_itemUnselectedWidths addObjectsFromArray:self.menuItemUnSelectedWidths];
        
        [self setupTextWidthsArray];
        for (UIViewController *vc in self.viewControllers) {
             [self caclulateItemTextWidth:vc.title];
        }
        return;
    }
    
    // 设置了富文本
    if (self.menuItemUnSelectedTitles.count > 0) {
        _menuItemType = LZPageMenuItemTypeAttribute;
        
        [self addWidthInArray:_itemUnselectedWidths byArray:self.menuItemUnSelectedTitles];
        [self addWidthInArray:_itemUnselectedWidths byArray:self.menuItemSelectedTitles];
    
        return;
    }
    
    // 等宽
    if (self.averageMenuWitdh && !self.menuItemWidthBasedOnTitleTextWidth) {
        _menuItemType = LZPageMenuItemTypeAverageWidth;
        
        [self setupTextWidthsArray];
        
        for (UIViewController *vc in self.viewControllers) {
            CGFloat totalwidth = self.menuWidth;
            if (totalwidth <= 0) totalwidth = [UIScreen mainScreen].bounds.size.width;
            // 剔除间距
            totalwidth -= (self.viewControllers.count - 1)*self.menuItemSpace;
            totalwidth -= (self.menuInset.left + self.menuInset.right);
            totalwidth -= (self.menuContentInset.left + self.menuContentInset.right);
            
            width = totalwidth/self.viewControllers.count;
            
            [_itemUnselectedWidths addObject:@(width)];
            [_itemSelectedWidths addObject:@(width)];
            
            [self caclulateItemTextWidth:vc.title];
        }
        
        return;
    }
    
    // 使用控制器的标题
    for (UIViewController *vc in self.viewControllers) {
        _menuItemType = LZPageMenuItemTypeViewControllerTitle;
        
        width = [vc.title sizeWithAttributes:@{NSFontAttributeName:self.unselectedMenuItemLabelFont}].width;
        [_itemUnselectedWidths addObject:@(width)];
        width = [vc.title sizeWithAttributes:@{NSFontAttributeName:self.selectedMenuItemLabelFont}].width;
        [_itemSelectedWidths addObject:@(width)];
    }
}

- (CGFloat)selectedWidth:(NSInteger)index {
    if (index >= _itemSelectedWidths.count) return [self unSelectedWidth:index];
    return [_itemSelectedWidths[index] floatValue];
}

- (CGFloat)unSelectedWidth:(NSInteger)index {
    if (index >= _itemUnselectedWidths.count) return 0;
    
    return [_itemUnselectedWidths[index] floatValue];
}

- (CGRect)getSpecialFrame:(CGRect)cellFrame index:(NSInteger)index {
    if ((self.menuItemType == LZPageMenuItemTypeAverageWidth || self.menuItemType == LZPageMenuItemTypeCustomWidth) && self.selectionIndicatorWithEqualToTextWidth) {
        CGFloat width = [self unSelectedTextWidth:index];;
        if (index == _lastSelectedIndex) width = [self selectedTextWidth:index];
        CGFloat x = (cellFrame.size.width - width)/2.0;
        
        CGRect newFrame = CGRectMake(cellFrame.origin.x + x, cellFrame.origin.y, width, cellFrame.size.height);
        
        return newFrame;
    }
    
    return cellFrame;
}

#pragma mark - 私有方法
- (void)addWidthInArray:(NSMutableArray *)array byArray:(NSMutableArray<NSAttributedString *> *)attributes {
    for (NSAttributedString *attribute in attributes) {
        CGFloat width = [attribute boundingRectWithSize:CGSizeMake(300.0, self.menuHeight - self.menuInset.top) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
        [array addObject:@(width)];
    }
}

- (CGFloat)selectedTextWidth:(NSInteger)index {
    if (index >= _itemSelectedTextWidths.count) return [self unSelectedTextWidth:index];
    return [_itemSelectedTextWidths[index] floatValue];
}

- (CGFloat)unSelectedTextWidth:(NSInteger)index {
    if (index >= _itemUnselectedTextWidths.count) return 0;
    
    return [_itemUnselectedTextWidths[index] floatValue];
}

- (void)setupTextWidthsArray {
    if (!_itemSelectedTextWidths) _itemSelectedTextWidths = [NSMutableArray array];
    if (!_itemUnselectedTextWidths) _itemUnselectedTextWidths = [NSMutableArray array];
    [_itemSelectedTextWidths removeAllObjects];
    [_itemUnselectedTextWidths removeAllObjects];
}

- (void)caclulateItemTextWidth:(NSString *)title {
    if (self.menuItemUnSelectedTitles.count > 0) {
        [self addWidthInArray:_itemUnselectedTextWidths byArray:self.menuItemUnSelectedTitles];
        [self addWidthInArray:_itemSelectedTextWidths byArray:self.menuItemSelectedTitles];
    } else {
        CGFloat width = [title sizeWithAttributes:@{NSFontAttributeName:self.unselectedMenuItemLabelFont}].width;
        [_itemUnselectedTextWidths addObject:@(width)];
        width = [title sizeWithAttributes:@{NSFontAttributeName:self.selectedMenuItemLabelFont}].width;
        [_itemSelectedTextWidths addObject:@(width)];
    }
}

@end

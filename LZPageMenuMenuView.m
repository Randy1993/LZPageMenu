//
//  LZPageMenuMenuView.h
//  LZPageMenu
//
//  Created by Randy Liu on 2017/12/25.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "LZPageMenuMenuView.h"
#import "LZPageMenuHeader.h"
#import <objc/message.h>

static NSString *LZPageMenuMenuViewCellIdentifire = @"CommunitySegmentScrollViewCellIdentifire";

#pragma mark - CommunitySegmentScrollViewCell
/**
 社区分段选择视图cell
 */
@implementation LZPageMenuMenuViewCell

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupSubviews {
    if (_customView || _titleLabel) return;
    
    UIView *subView = nil;
   
    if (_propertyManager.menuItemType == LZPageMenuItemTypeCustomView) {
        subView = [_propertyManager.customDelegate menuItemView:0];
        _customView = subView;
    } else {
        // 初始化子视图
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        subView = label;
        _titleLabel = label;
    }
  
    [self.contentView addSubview:subView];
    
    if (_propertyManager.verticalSeparatorWidth <= 0) return;
    CALayer *verticalSeparator = [[CALayer alloc] init];
    verticalSeparator.backgroundColor = _propertyManager.verticalSeparatorColor.CGColor;
    [self.contentView.layer addSublayer:verticalSeparator];
    _verticalSeparator = verticalSeparator;
}

- (void)setPropertyManager:(LZPageMenuPropertyManager *)propertyManager {
    _propertyManager = propertyManager;
    
    [self setupSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   if (_titleLabel) _titleLabel.frame = self.contentView.bounds;
   if (_customView) _customView.frame = self.contentView.bounds;
   if (_verticalSeparator) _verticalSeparator.frame = CGRectMake(self.contentView.lz_width - _propertyManager.verticalSeparatorWidth, (self.contentView.lz_height - _propertyManager.verticalSeparatorHeight)/2.0, _propertyManager.verticalSeparatorWidth, _propertyManager.verticalSeparatorHeight);
}

@end



#pragma mark - CommunitySegmentScrollView

@interface LZPageMenuMenuView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

/**
 社区分段选择视图
 */
@implementation LZPageMenuMenuView

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:CGRectZero collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.scrollsToTop = NO;
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[LZPageMenuMenuViewCell class] forCellWithReuseIdentifier:LZPageMenuMenuViewCellIdentifire];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 处理默认选中，之所以将方法放在这里是因为只能获取集合视图显示后的cell的frame
    if (_propertyManager.defaultSelectedIndex >= 0) {
        _propertyManager.hadTapMenu = YES;
        [self refreshCell:_propertyManager.defaultSelectedIndex];
        [self handleTap:[NSIndexPath indexPathForItem:_propertyManager.defaultSelectedIndex inSection:0]];
        _propertyManager.defaultSelectedIndex = -1;
    }
    
    if (_propertyManager.needShowSelectionIndicator && _propertyManager.showIndicatorInLowestLayer) {
        _propertyManager.setIndicatorHierarchy();
    }
}

- (void)setPropertyManager:(LZPageMenuPropertyManager *)propertyManager {
    _propertyManager = propertyManager;
    
    self.contentInset = _propertyManager.menuContentInset;
    self.bounces = _propertyManager.enableHorizontalBounce;
    self.scrollEnabled = _propertyManager.enableScroll;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _propertyManager.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZPageMenuMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LZPageMenuMenuViewCellIdentifire forIndexPath:indexPath];
    cell.propertyManager = _propertyManager;
    
    // 垂直分割线处理
    if (cell.verticalSeparator) cell.verticalSeparator.hidden = (indexPath.item == _propertyManager.viewControllers.count - 1 && _propertyManager.hideLastVerticalSeparator);
    
    // 自定义Item处理
    if (_propertyManager.menuItemType == LZPageMenuItemTypeCustomView) {
        if ([cell.customView respondsToSelector:NSSelectorFromString(@"configData:index:selected:")]) {
            id itemData = nil;
            if ([_propertyManager.customDelegate respondsToSelector:@selector(customViewData:)]) {
                itemData = [_propertyManager.customDelegate customViewData:indexPath.item];
            }
            ((void (*)(id, SEL, id, NSInteger, BOOL))objc_msgSend)(cell.customView, NSSelectorFromString(@"configData:index:selected:"), itemData, indexPath.item, _propertyManager.lastSelectedIndex == indexPath.item);
        }
        
        return cell;
    }
    
    // 富文本Item的处理
    if (_propertyManager.menuItemType == LZPageMenuItemTypeAttribute) {
        if (_propertyManager.lastSelectedIndex == indexPath.item && _propertyManager.menuItemSelectedTitles.count > 0) {
            cell.titleLabel.attributedText = _propertyManager.menuItemSelectedTitles[indexPath.row];
        } else {
            cell.titleLabel.attributedText = _propertyManager.menuItemUnSelectedTitles[indexPath.row];
        }
    } else { // 普通文本Item处理
        cell.titleLabel.text = [_propertyManager.viewControllers[indexPath.row] title];
        cell.titleLabel.textColor = (indexPath.item == _propertyManager.lastSelectedIndex ? _propertyManager.selectedMenuItemLabelColor : _propertyManager.unselectedMenuItemLabelColor);
        cell.titleLabel.font = (indexPath.item == _propertyManager.lastSelectedIndex ? _propertyManager.selectedMenuItemLabelFont : _propertyManager.unselectedMenuItemLabelFont);
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = _propertyManager.menuHeight - _propertyManager.menuInset.top;
    CGFloat width = _propertyManager.lastSelectedIndex == indexPath.item ? [_propertyManager selectedWidth:indexPath.item] : [_propertyManager unSelectedWidth:indexPath.item];
    
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_propertyManager.lastSelectedIndex == indexPath.item || _propertyManager.hadTapMenu) return;
    
    _propertyManager.hadTapMenu = YES;
    
    // 设置选中
    [self refreshCell:indexPath.item];
    
    // 处理点击
    [self handleTap:indexPath];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return _propertyManager.menuItemSpace;
}

#pragma mark - 外部方法
- (void)refreshCell:(NSInteger)selectedIndex {
    if (selectedIndex >= _propertyManager.viewControllers.count || selectedIndex < 0 || selectedIndex == _propertyManager.lastSelectedIndex) return;
    
    // 更新cell
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForItem:selectedIndex inSection:0]];
    if (_propertyManager.lastSelectedIndex >= 0) [indexPaths addObject:[NSIndexPath indexPathForItem:_propertyManager.lastSelectedIndex inSection:0]];
    _propertyManager.lastSelectedIndex = selectedIndex;
    [self reloadItemsAtIndexPaths:indexPaths.copy];
    
    // 滑动
    [self scrollToItemAtIndexPath:indexPaths.firstObject atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - 点击的回调
- (void)handleTap:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect frame = attribute.frame;
    // 处理某些特殊情况
    if (CGRectEqualToRect(CGRectZero, frame)) {
        [self performSelector:@selector(handleTap:) withObject:indexPath afterDelay:0.1];
        return;
    }
    
    frame = [_propertyManager getSpecialFrame:frame index:indexPath.item];
    !self.selectedItemBlock ? : self.selectedItemBlock(frame, indexPath.item);
}

@end


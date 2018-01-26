//
//  LZPageMenu.m
//  LZPageMenu
//
//  Created by Randy Liu on 2017/12/25.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "LZPageMenu.h"
#import "LZPageMenuMenuView.h"
#import "LZPageMenuHeader.h"
#import "LZPageMenuDynamicItem.h"

static CGFloat LZBehaviorLimitValue = 1.5;

@interface LZPageMenu () <UIScrollViewDelegate> {
    CGFloat _headerViewMaximumOffset;
    CGFloat _panStartY;
    CGFloat _panEndY;
    CGPoint _panStartPoint;
    UIScrollView *_panScrollView;
    // 当菜单上滑到极限时，不允许继续偏移菜单
    BOOL _canNotScrollMenuView;
}

/// 控制器滚动视图
@property (nonatomic, weak) UIScrollView *contollerScrollView;
/// 菜单视图内的滚动菜单
@property (nonatomic, weak) LZPageMenuMenuView *menuScrollView;
/// panGesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
/// 自控制器的控制视图
@property (nonatomic, strong) NSMutableDictionary *subScrollviews;
/// item指示线
@property (nonatomic, weak) CALayer *itemIndicator;
/// 底部线
@property (nonatomic, weak) CALayer *bottomLine;
/// 菜单视图
@property (nonatomic, weak) UIView *menuView;
/// 属性管理器
@property (nonatomic, strong) LZPageMenuPropertyManager *propertyManager;
/// 已经添加过的index
@property (nonatomic, strong) NSMutableSet *addedIndexs;
/// 当前正在内存中的indexs
@property (nonatomic, strong) NSMutableSet *showInMemoryIndexs;

#pragma mark - 约束
/// 头视图的Y
@property (nonatomic, strong) NSLayoutConstraint *headerView_Y;
/// 头视图的left
@property (nonatomic, strong) NSLayoutConstraint *headerView_Left;
/// 头视图的right
@property (nonatomic, strong) NSLayoutConstraint *headerView_Right;
/// 头视图的height
@property (nonatomic, strong) NSLayoutConstraint *headerView_Height;

#pragma mark - UI动力学
/// 模仿UISCrollView弹性和惯性的动画
@property (nonatomic, strong) UIDynamicAnimator *animator;
/// 惯性行为
@property (nonatomic, strong) UIDynamicItemBehavior *inertiaBehavior;
/// 弹性行为
@property (nonatomic, strong) UIAttachmentBehavior *bounceBehavior;
/// 行为Item
@property (nonatomic, strong) LZPageMenuDynamicItem *animatorItem;

@end

@implementation LZPageMenu

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    if (_animator) {
        [_animator removeBehavior:_inertiaBehavior];
        [_animator removeBehavior:_bounceBehavior];
        _inertiaBehavior = nil; _bounceBehavior = nil; _animatorItem = nil;
    }
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (!self) return nil;
    
    self.view.frame = frame;
    self.addedIndexs = [NSMutableSet set];
    self.showInMemoryIndexs = [NSMutableSet set];
    // 初始话数据
    [self initialize];
    // 初始化子视图
    [self setupSubviews];
    
    return self;
}

- (void)initialize {
    self.pageMenuBackgroundColor = [UIColor whiteColor];
    self.selectionIndicatorColor = [UIColor redColor];
    self.menuBottomLineColor = [UIColor redColor];
    self.menuBackgroundColor = [UIColor orangeColor];
    self.selectedMenuItemLabelColor = [UIColor redColor];
    self.unselectedMenuItemLabelColor = [UIColor whiteColor];
    self.menuBottomLineColor = [UIColor lightGrayColor];
    self.verticalSeparatorColor = [UIColor lightGrayColor];
    
    self.needShowSelectionIndicator = YES;
    self.enableHorizontalBounce = YES;
    self.menuItemWidthBasedOnTitleTextWidth = YES;
    self.hideLastVerticalSeparator = YES;
    self.enableScroll = YES;
    self.selectionIndicatorWithEqualToTextWidth = YES;
    self.stretchHeaderView = YES;
    
    self.menuHeight = 44.0;
    self.selectionIndicatorHeight = 2.0;
    self.menuInset = UIEdgeInsetsZero;
    self.selectionIndicatorOffset = UIEdgeInsetsZero;
    self.menuContentInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    self.menuItemSpace = 15.0;
    self.scrollAnimationDurationOnMenuItemTap = 0.5;
    self.selectionIndicatorType = LZSelectionIndicatorTypeLine;
    self.defaultSelectedIndex = 0;
    self.menuBottomLineHeight = 0;
    self.verticalSeparatorHeight = 0;
    self.verticalSeparatorWidth = 0;
    self.headerViewMaxmumOffsetRate = 0.5;
    
    self.selectedMenuItemLabelFont = [UIFont boldSystemFontOfSize:18.0];
    self.unselectedMenuItemLabelFont = [UIFont systemFontOfSize:16.0];
}

- (void)setupSubviews {
    UIView *menuBackgroundView = [[UIView alloc] init];
    menuBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:menuBackgroundView];
    _menuView = menuBackgroundView;
    
    LZPageMenuMenuView *menuScrollView  = [[LZPageMenuMenuView alloc] init];
    menuScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [menuBackgroundView addSubview:menuScrollView ];
    _menuScrollView = menuScrollView ;
    
    CALayer *itemIndicator = [[CALayer alloc] init];
    [_menuScrollView.layer addSublayer:itemIndicator];
    _itemIndicator = itemIndicator;
    
    UIScrollView *controllerScrollView = [[UIScrollView alloc] init];
    controllerScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    controllerScrollView.pagingEnabled = YES;
    controllerScrollView.delegate = self;
    controllerScrollView.showsHorizontalScrollIndicator = NO;
    controllerScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:controllerScrollView];
    _contollerScrollView = controllerScrollView;
    
    // 设置回调
    LZWeakSelf(weakSelf);
    _menuScrollView.selectedItemBlock = ^(CGRect frame, NSInteger index) {
        [weakSelf tapMenu:frame index:index];
    };
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        CALayer *bottomLine = [[CALayer alloc] init];
        [_menuView.layer addSublayer:bottomLine];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

- (void)configHeaderView {
    // 添加头部
    [self.view insertSubview:self.headerView atIndex:0];
    _headerViewMaximumOffset = self.headerViewHeight * self.headerViewMaxmumOffsetRate;
    
    // 获取UISCrollView
    if (!_subScrollviews) {
        _subScrollviews = [NSMutableDictionary dictionary];
    } else {
        [_subScrollviews removeAllObjects];
    }
    
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *vc = self.viewControllers[i];
        
        [self getScrollViewInView:vc.view index:i];
    }
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        _panGesture.maximumNumberOfTouches = 1;
        [self.view addGestureRecognizer:_panGesture];
        
        [self setupAnimator];
    }
}

- (void)setupAnimator {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animatorItem = [[LZPageMenuDynamicItem alloc] init];
    _inertiaBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_animatorItem]];
    _bounceBehavior = [[UIAttachmentBehavior alloc] initWithItem:_animatorItem attachedToAnchor:CGPointZero];
}
#pragma mark - 指示相关
- (void)setupIndicator {
    if (_propertyManager.menuItemType == LZPageMenuItemTypeCustomView) _propertyManager.showIndicatorInLowestLayer = NO;
    
    _itemIndicator.hidden = !self.needShowSelectionIndicator;
    if (!self.needShowSelectionIndicator) return;
    
    _itemIndicator.backgroundColor = self.selectionIndicatorColor.CGColor;
    if (self.selectionIndicatorImage && self.selectionIndicatorType == LZSelectionIndicatorTypeImage) {
        _itemIndicator.contents = (__bridge id _Nullable)self.selectionIndicatorImage.CGImage;
        _itemIndicator.backgroundColor = [UIColor clearColor].CGColor;
    }
    
    if (self.selectionIndicatorType & LZSelectionIndicatorTypeDot || self.selectionIndicatorType & LZSelectionIndicatorTypeSolidOval || self.selectionIndicatorType & LZSelectionIndicatorTypeSolidHollowOval) _itemIndicator.cornerRadius = self.selectionIndicatorHeight/2.0;
    if (self.selectionIndicatorType & LZSelectionIndicatorTypeSolidHollowOval) {
        _itemIndicator.borderColor = self.selectionIndicatorColor.CGColor;
        _itemIndicator.borderWidth = 1.0;
        _itemIndicator.backgroundColor = [UIColor clearColor].CGColor;
    }
}

- (void)scrollIndicator:(CGRect)itemFrame {
    if (!self.needShowSelectionIndicator) return;
    
    CGFloat width = CGRectGetWidth(itemFrame) - self.selectionIndicatorOffset.left - self.selectionIndicatorOffset.right;
    CGFloat height = self.selectionIndicatorHeight;
    CGFloat x = CGRectGetMinX(itemFrame) + self.selectionIndicatorOffset.left;
    CGFloat y = self.menuHeight - self.menuInset.top - fabs(self.menuInset.bottom) - height;
    if (self.selectionIndicatorOffset.top > 0) {
        y = self.selectionIndicatorOffset.top;
    } else if (self.selectionIndicatorOffset.bottom > 0) {
        y -= self.selectionIndicatorOffset.bottom;
    }
    
    switch (self.selectionIndicatorType) {
        case LZSelectionIndicatorTypeImage:
            width = self.selectionIndicatorImageWidth;
            if (self.selectionIndicatorImageWidth <= 0) width = self.selectionIndicatorImage.size.width;
            // 没有设置X值，则居中
            if (self.selectionIndicatorOffset.left <= 0.0) x = CGRectGetMinX(itemFrame) + (CGRectGetWidth(itemFrame) - width)/2.0;
            if (height <= 0) height = self.selectionIndicatorImage.size.height;
            break;
            
        case LZSelectionIndicatorTypeDot:
            width = self.selectionIndicatorHeight;
            if (self.selectionIndicatorOffset.left <= 0.0) x = CGRectGetMinX(itemFrame) + (CGRectGetWidth(itemFrame) - width)/2.0;
            break;
        case LZSelectionIndicatorTypeBlock:
        case LZSelectionIndicatorTypeSolidOval:
        case LZSelectionIndicatorTypeSolidHollowOval:
            // 莫名其妙指示块会遮住cell。
//            [_menuScrollView.layer insertSublayer:_itemIndicator atIndex:0];
        break;
            
        default:break;
    }
    
    [UIView animateWithDuration:self.scrollAnimationDurationOnMenuItemTap animations:^{
        _itemIndicator.frame = CGRectMake(x, y, width, height);
    }];
}

- (CGRect)getCellFrame:(NSInteger)index {
     UICollectionViewLayoutAttributes *attribute = [_menuScrollView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    CGRect frame = attribute.frame;
    frame = [_propertyManager getSpecialFrame:frame index:index];
    
    return frame;
}

#pragma mark - 显示在导航栏
- (void)showInNavigationBar {
    UIViewController *parentVc = (UIViewController *)self.nextResponder.nextResponder;
    if (!parentVc || ![parentVc isKindOfClass:UIViewController.class]) return;
    
    UINavigationBar *naviBar = parentVc.navigationController.navigationBar;
    if (!naviBar) return;
    
    _menuView.translatesAutoresizingMaskIntoConstraints = YES;
    _menuScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGFloat width = self.menuWidth;
    if (width <= 0) {
        for (NSNumber *titleWidth in _propertyManager.itemUnselectedWidths) {
            width += titleWidth.floatValue;
        }
        width += (_propertyManager.itemUnselectedWidths.count - 1)*self.menuItemSpace;
        width += self.menuInset.left + self.menuInset.right;
        width += self.menuContentInset.left + self.menuContentInset.right;
    }
    
    if (width >= naviBar.lz_width) width = naviBar.lz_width;
    _menuView.frame = CGRectMake(0.0, 0.0, width, self.menuHeight);
    self.menuWidth = width;
    [naviBar addSubview:_menuView];
    parentVc.navigationItem.titleView = _menuView;
}

#pragma mark - 滑动菜单
- (void)tapMenu:(CGRect)itemFrame index:(NSInteger)index {
    // 滚动分割线
    [self scrollIndicator:itemFrame];
    // 滚动控制器
    [self scrollViewController:index];
    
    _propertyManager.startScrollIndex = index;
}

- (void)scrollViewController:(NSInteger)index {
    if (index >= self.viewControllers.count) return;
    
    // 当用户点击的index与先前的选中之间跨度较大时，为了避免白屏，需要进行特殊的处理，将中间初始化过的控制器添加一遍
    if (index - _propertyManager.startScrollIndex > 0) {
        for (NSInteger startIndex = _propertyManager.startScrollIndex; startIndex <= index - 1; startIndex++) {
            [self addHadAddedPageAtIndex:startIndex];
        }
    }
    
    if (index - _propertyManager.startScrollIndex < 0) {
        for (NSInteger startIndex = index + 1; startIndex <= _propertyManager.startScrollIndex - 1; startIndex++) {
            [self addHadAddedPageAtIndex:startIndex];
        }
    }
    
    [self addPageAtIndex:index];
    if (self.headerView) [self resetPanGestureData];
    [UIView animateWithDuration:self.scrollAnimationDurationOnMenuItemTap animations:^{
        _contollerScrollView.contentOffset = CGPointMake(index * self.view.lz_width, 0.0);
    } completion:^(BOOL finished) {
        [self removePage];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_propertyManager.hadTapMenu || scrollView.contentOffset.x <= 0 ||  scrollView.contentOffset.x >= _contollerScrollView.contentSize.width) return;
    
    if (self.headerView) [self resetPanGestureData];
    
    BOOL goNext = NO;
    BOOL goPrevious = NO;
    CGFloat rate = 0.5;
    if (_propertyManager.startScrollIndex * self.view.lz_width < scrollView.contentOffset.x) goNext = YES;
    if (_propertyManager.startScrollIndex * self.view.lz_width > scrollView.contentOffset.x) goPrevious = YES;
    if (!goNext && !goPrevious) return;
    
    NSInteger currentIndex = goNext ? ceil(scrollView.contentOffset.x / _contollerScrollView.lz_width) : floor(scrollView.contentOffset.x / _contollerScrollView.lz_width);
    if (currentIndex >= self.viewControllers.count || currentIndex < 0) return;
    
    // 首先判断对应位置的页面有没有被添加过，有则在滑动之初就添加，避免出现白屏
    [self addHadAddedPageAtIndex:currentIndex];
    
    // 再者判读是否划过了半个屏幕的距离，控制指示条的滚动等
    BOOL needAddNewPage = NO;
    if (goNext) needAddNewPage = fabs((currentIndex - 1) * _contollerScrollView.lz_width - scrollView.contentOffset.x)/_contollerScrollView.lz_width >= rate;
    if (goPrevious) needAddNewPage = fabs((currentIndex + 1) * _contollerScrollView.lz_width - scrollView.contentOffset.x)/_contollerScrollView.lz_width >= rate;
    
    // 处理菜单
    if (!needAddNewPage) {
        [_menuScrollView refreshCell:goNext ? currentIndex - 1 : currentIndex + 1];
        [self scrollIndicator:[self getCellFrame:goNext ? currentIndex - 1 : currentIndex + 1]];
        return;
    } else {
        [_menuScrollView refreshCell:currentIndex];
        [self scrollIndicator:[self getCellFrame:currentIndex]];
    }
    
    // 判断将要添加的视图在图层上
    if ([_showInMemoryIndexs containsObject:@(currentIndex)]) return;
    
    [_menuScrollView refreshCell:currentIndex];
    [self addPageAtIndex:currentIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_propertyManager.hadTapMenu) return;
    _propertyManager.startScrollIndex = _propertyManager.lastSelectedIndex;
    
    [self removePage];
}

#pragma mark - 切换界面
/**
 添加已经被添加过的页面
 */
- (void)addHadAddedPageAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.viewControllers.count) return;
    if (![_showInMemoryIndexs containsObject:@(index)] && [_addedIndexs containsObject:@(index)]) {
        [self addPageAtIndex:index];
    }
}

/**
 添加一个子控制器
 */
- (void)addPageAtIndex:(NSInteger)index {
    UIViewController *currentController = self.viewControllers[index];
    if ([_delegate respondsToSelector:@selector(willMoveToPage:index:)]) {
        [_delegate willMoveToPage:currentController index:index];
    }
    UIViewController *newVC = self.viewControllers[index];
    
    [newVC willMoveToParentViewController:self];
    
    newVC.view.frame = CGRectMake(_contollerScrollView.lz_width * index, 0.0, _contollerScrollView.lz_width, _contollerScrollView.lz_height);
    
    [self addChildViewController:newVC];
    [_contollerScrollView addSubview:newVC.view];
    
    [newVC didMoveToParentViewController:self];
    
    [_addedIndexs addObject:@(index)];
    [_showInMemoryIndexs addObject:@(index)];
}

/**
 保证当前图层中只有一个控制器显示
 */
- (void)removePage {
    for (NSNumber *index in _showInMemoryIndexs) {
        if (index.integerValue == _propertyManager.lastSelectedIndex) continue;
        
        UIViewController *oldVC = self.viewControllers[index.integerValue];
        [oldVC willMoveToParentViewController:nil];
        
        [oldVC.view removeFromSuperview];
        [oldVC removeFromParentViewController];
        
        [oldVC didMoveToParentViewController:nil];
    }
    
    [_showInMemoryIndexs removeAllObjects];
    [_showInMemoryIndexs addObject:@(_propertyManager.lastSelectedIndex)];
    _propertyManager.hadTapMenu = NO;
}

#pragma mark - HeaderView相关
/**
 当来回切换时，需要重置手势的数据
 */
- (void)resetPanGestureData {
    _panEndY = 0;
    _panStartY = 0;
    _panStartPoint = CGPointZero;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = [pan locationInView:self.view];
        _panStartY = _panStartPoint.y;
        _panScrollView = [self getScrollViewAtPoint:_panStartPoint];
        [self forbiddenUserinterface:YES];
        [self removeBounce];
        [self removeInertia:NO];
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        _panEndY = [pan locationInView:self.view].y;
        
        BOOL goUp = _panEndY < _panStartY;
        BOOL goDown = _panEndY >= _panStartY;
        
        if (!goUp && !goDown) return;
        _canNotScrollMenuView = [self wetherCanScrollMenuView];
        [self scrollSubView:goUp offset:(_panEndY - _panStartY) behavior:nil];
      
        _panStartY = _panEndY;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [pan velocityInView:self.view];
        [self addInertia:velocity];
    }
}

- (void)scrollSubView:(BOOL)goUp offset:(CGFloat)offset behavior:(id)behavior {
    // 当有UIScrollView存在偏移，而菜单没有上滑到极限，则在上滑时偏移菜单，下滑时滚动滚动视图
    BOOL onlyScrollMenuView = NO;
    if (_canNotScrollMenuView && ![self headerGoUpToLimit]) {
        if (!goUp) {
            [self setScrollViewContentOffset:goUp ? fabs(offset) : -fabs(offset) scrollView:_panScrollView behavior:behavior];
            return;
        } else {
            onlyScrollMenuView = YES;
        }
    }
    
    // 减缓滑动速度
    offset /= 1.3;
    if (!self.stretchHeaderView && (!_canNotScrollMenuView || onlyScrollMenuView)) {
        if (goUp) {
            if ([behavior isEqual:_bounceBehavior]) offset *= 1.3;
            _headerView_Y.constant -= fabs(offset);
        }
        
        if (!goUp) {
            
            _headerView_Y.constant += offset;
            // 控制下拉临界值
            if (_headerView_Y.constant >= _headerViewMaximumOffset) _headerView_Y.constant = _headerViewMaximumOffset;
        }
        
        if ([_delegate respondsToSelector:@selector(headerViewOffsetY:)]) {
            [_delegate headerViewOffsetY:_headerView_Y.constant - 0];
        }
    }
    
    if (self.stretchHeaderView && (!_canNotScrollMenuView || onlyScrollMenuView)) {
        // 分为只进行缩放和y值更改两种
        if (goUp) {
            if ([behavior isEqual:_bounceBehavior]) offset *= 1.3;
            if (_headerView_Height.constant > self.headerViewHeight) {
                _headerView_Height.constant -= fabs(offset);
                _headerView_Left.constant += fabs(offset)/2;
                _headerView_Right.constant -= fabs(offset)/2;
            } else {
                _headerView_Y.constant -= fabs(offset);
            }
        }
        
        if (!goUp) {
            // 拉伸
            if (_headerView_Y.constant >= 0) {
                _headerView_Y.constant = 0;
                _headerView_Height.constant += fabs(offset);
                // 控制最大的拉伸
                if (_headerView_Height.constant >= self.headerViewHeight + _headerViewMaximumOffset) {
                    _headerView_Height.constant = self.headerViewHeight + _headerViewMaximumOffset;
                } else {
                    _headerView_Left.constant -= fabs(offset)/2;
                    _headerView_Right.constant += fabs(offset)/2;
                }
                
            } else {
                _headerView_Y.constant += fabs(offset);
            }
        }
        
        // 根据高度进行归位操作
        if (_headerView_Height.constant <= self.headerViewHeight) {
            _headerView_Left.constant = 0;
            _headerView_Right.constant = 0;
            _headerView_Height.constant = self.headerViewHeight;
        }
        
        // 进行Y值的误差处理，例如快速滑动
        if (_headerView_Y.constant >= 0) _headerView_Y.constant = 0;
        if (_headerView_Left.constant >= 0) _headerView_Left.constant = 0;
        if (_headerView_Right.constant <= 0) _headerView_Right.constant = 0;
        
        if ([_delegate respondsToSelector:@selector(headerViewOffsetY:heightOffset:)]) {
            [_delegate headerViewOffsetY:_headerView_Y.constant - 0 heightOffset:_headerView_Height.constant - self.headerViewHeight];
        }
    }
    
    // 当已经上滑到了极限时
    if ([self headerGoUpToLimit]) {
        _headerView_Y.constant = -fabs(self.headerViewHeight - self.headerViewTopSafeDistance);
        [self setScrollViewContentOffset:goUp ? fabs(offset) : -fabs(offset) scrollView:_panScrollView behavior:behavior];
    }
    
    // 移除动画 并处理头部的滚动
    BOOL condition1 = fabs(offset) < LZBehaviorLimitValue;
    BOOL condition2 = self.stretchHeaderView && _headerView_Height.constant >= self.headerViewHeight + _headerViewMaximumOffset;
    BOOL condition3 = !self.stretchHeaderView && _headerView_Y.constant >= _headerViewMaximumOffset;
    if (behavior && (condition1 || condition2 || condition3)) {
        [self removeInertia:YES];
    }
}

/**
 递归获取对应控制器的UISCrollView
 */
- (void)getScrollViewInView:(UIView *)view index:(NSInteger)index {
    UIScrollView *scrollView = nil;
    if ([view isKindOfClass: UIScrollView.class]) {
        scrollView = (UIScrollView *)view;
    }
    
    if ([view isKindOfClass: NSClassFromString(@"WKWebView")]) {
        scrollView = [view valueForKey:@"scrollView"];
    }
    
    if (scrollView) {
        scrollView.scrollEnabled = NO;
        scrollView.bounces = NO;
        NSMutableSet *set = _subScrollviews[@(index).stringValue];
        if (!set) {
            set = [NSMutableSet set];
            [_subScrollviews setObject:set forKey:@(index).stringValue];
        }
        [set addObject:scrollView];
    }
    
    for (UIView *subview in view.subviews) {
        [self getScrollViewInView:subview index:index];
    }
}

- (UIScrollView *)getScrollViewAtPoint:(CGPoint)point {
    NSMutableSet *scrollViewSet = _subScrollviews[@(_propertyManager.lastSelectedIndex).stringValue];
    for (UIScrollView *scrollView in scrollViewSet) {
        CGRect covertFrame = [_contollerScrollView convertRect:scrollView.frame toView:self.view];
        // 又是可能因为_contollerScrollView的偏移量使得转换失败
        if (covertFrame.origin.x < 0) covertFrame.origin.x += _contollerScrollView.contentOffset.x;
        if (CGRectContainsPoint(covertFrame, point)) return scrollView;
    }
    
    return nil;
}

- (void)setScrollViewContentOffset:(CGFloat)offsetY scrollView:(UIScrollView *)scrollView behavior:(id)behavior{
    // 如果是执行动画，那么需要重新获取scrollView，而且确定是来是自当前页面的惯性。_panStartPoint在切换页面的过程中将会被清空
    if (behavior && !scrollView && !CGPointEqualToPoint(_panStartPoint, CGPointZero)) {
        scrollView = [self getScrollViewAtPoint:self.view.center];
        _panScrollView = scrollView;
    }
    
    if (!scrollView) return;
    CGPoint oldOffset = scrollView.contentOffset;
    CGFloat newOffset_Y = oldOffset.y + offsetY;
    CGFloat maxContentsizeY = scrollView.contentSize.height - scrollView.lz_height/2.0;
    
    // 添加动画的条件：1、惯性上滑到极限 2、惯性停止且超出了scrollView.contentSize.height - scrollView.lz_height
    if (newOffset_Y >= scrollView.contentSize.height - scrollView.lz_height) {
        BOOL addBounceCondition1 = (newOffset_Y >= maxContentsizeY && ![_animator.behaviors containsObject:_bounceBehavior]);
        BOOL addBounceCondition2 = (offsetY < LZBehaviorLimitValue && offsetY >= 0 && ![_animator.behaviors containsObject:_bounceBehavior]);
        
        // 满足条件一设置偏移并移除动画行为
        if (addBounceCondition1) {
            [self setScrollViewContentOffet:scrollView offset:CGPointMake(0.0, maxContentsizeY)];
            [self removeInertia:NO];
        }
        
        if ([behavior isEqual:_inertiaBehavior] && (addBounceCondition1 || addBounceCondition2)) {
            LZWeakSelf(weakSelf);
            [self addBounce:_panScrollView.contentOffset anchorPoint:CGPointMake(0, _panScrollView.contentSize.height - _panScrollView.lz_height) action:^{
                LZStrongSelf(strongSelf);
                
                if (weakSelf.animatorItem.center.y <= weakSelf.bounceBehavior.anchorPoint.y) {
                    strongSelf.animatorItem.center = weakSelf.bounceBehavior.anchorPoint;
                    if ([weakSelf.delegate respondsToSelector:@selector(subScrollViewDidEndScroll:)] && strongSelf->_panScrollView) {
                        [weakSelf.delegate subScrollViewDidEndScroll:strongSelf->_panScrollView];
                    }
                    [weakSelf removeBounce];
                }
                [weakSelf setScrollViewContentOffet:strongSelf->_panScrollView offset:strongSelf.animatorItem.center];
            }];
        }
    }
    
    // 控制非惯性滑动的极限
    if (newOffset_Y <= 0) newOffset_Y = 0;
    if (!behavior && newOffset_Y >= maxContentsizeY) newOffset_Y = maxContentsizeY;
    
    [self setScrollViewContentOffet:scrollView offset:CGPointMake(0.0, newOffset_Y)];
}

- (void)setScrollViewContentOffet:(UIScrollView *)scrollView offset:(CGPoint)offset {
    scrollView.contentOffset = offset;
    if ([_delegate respondsToSelector:@selector(subScrollViewDidScroll:)]) {
        [_delegate subScrollViewDidScroll:scrollView];
    }
}

/**
 区分上滑和下滑的惯性
 
 上滑，将加速度传递给UISCrollView，当UISCrollView完成惯性滚动后，移除动画行为。
 下滑，当headerView和menuView完成惯性滚动后，移除动画行为，并添加必要的bounce行为
 */
- (void)addInertia:(CGPoint)velocity {
    // 大于零 惯性向下， 小于零 惯性向上
    BOOL goUp = velocity.y < 0 ;
    _animatorItem.center = CGPointZero;
    [_inertiaBehavior addLinearVelocity:CGPointMake(0, velocity.y) forItem:_animatorItem];
    _inertiaBehavior.resistance = 2.0;
    __block CGPoint lastCenter = CGPointZero;
    
    LZWeakSelf(weakSelf);
    _inertiaBehavior.action = ^{
        LZStrongSelf(strongSelf);
        CGFloat currentY = weakSelf.animatorItem.center.y - lastCenter.y;
        // 需要不断重新计算该值
        strongSelf->_canNotScrollMenuView = [weakSelf wetherCanScrollMenuView];
        [weakSelf scrollSubView:goUp offset:currentY behavior:weakSelf.inertiaBehavior];
        lastCenter = weakSelf.animatorItem.center;
    };
    [self.animator addBehavior:_inertiaBehavior];
}

- (void)removeInertia:(BOOL)needBounceheader {
    [self forbiddenUserinterface:NO];
    if ([_animator.behaviors containsObject:_inertiaBehavior]) {
        [_animator removeBehavior:_inertiaBehavior];
        
        if ([_delegate respondsToSelector:@selector(subScrollViewDidEndScroll:)] && _panScrollView && _panScrollView.contentOffset.y < _panScrollView.contentSize.height - _panScrollView.lz_height) {
            [_delegate subScrollViewDidEndScroll:_panScrollView];
        }
    }
    
    // 需要处理头部的偏移
    if (needBounceheader) {
        LZWeakSelf(weakSelf);
        __block CGFloat lastY = 0;
        
        if (self.stretchHeaderView && _headerView_Height.constant > self.headerViewHeight) {
            lastY = _headerView_Height.constant;
            [self addBounce:CGPointMake(0, _headerView_Height.constant) anchorPoint:CGPointMake(0, self.headerViewHeight) action:^{
                LZStrongSelf(strongSelf);
                
                if (weakSelf.animatorItem.center.y <= weakSelf.bounceBehavior.anchorPoint.y) {
                    strongSelf.animatorItem.center = weakSelf.bounceBehavior.anchorPoint;
                    [weakSelf removeBounce];
                }
                
                [weakSelf scrollSubView:YES offset:weakSelf.animatorItem.center.y - lastY behavior:weakSelf.bounceBehavior];
                lastY = weakSelf.animatorItem.center.y;
            }];
        }
        __block CGFloat offset = 0;
        if (!self.stretchHeaderView && _headerView_Y.constant > 0) {
            lastY =  _headerView_Y.constant;
            [self addBounce:CGPointMake(0, _headerView_Y.constant) anchorPoint:CGPointMake(0, 0) action:^{
                
                if (weakSelf.animatorItem.center.y <= 0.0) {
                    weakSelf.animatorItem.center = weakSelf.bounceBehavior.anchorPoint;
                    [weakSelf removeBounce];
                }
                offset = lastY - weakSelf.animatorItem.center.y;
                [weakSelf scrollSubView:YES offset:offset behavior:weakSelf.bounceBehavior];
                lastY = weakSelf.animatorItem.center.y;
            }];
        }
    }
}

- (void)addBounce:(CGPoint)center anchorPoint:(CGPoint)anchorPoint action:(void(^)(void))action {
    _animatorItem.center = center;
    _bounceBehavior.anchorPoint = anchorPoint;
    _bounceBehavior.length = 0;
    _bounceBehavior.damping = 1;
    _bounceBehavior.frequency = 2;
    _bounceBehavior.action = action;
    [_animator addBehavior:_bounceBehavior];
}

- (void)removeBounce {
    [self forbiddenUserinterface:NO];
    if ([_animator.behaviors containsObject:_bounceBehavior]) {
        [_animator removeBehavior:_bounceBehavior];
    }
}

- (void)forbiddenUserinterface:(BOOL)forbid {
    self.headerView.userInteractionEnabled = !forbid;
    self.menuView.userInteractionEnabled = !forbid;
    self.contollerScrollView.userInteractionEnabled = !forbid;
}

- (BOOL)wetherCanScrollMenuView {
    // 滚动视图的偏移不为0时，不能滚动菜单
    
    NSMutableSet *scrollViewSet = _subScrollviews[@(_propertyManager.lastSelectedIndex).stringValue];
    NSInteger hadOffsetScrollviewCount = 0;
    for (UIScrollView *scrollView in scrollViewSet) {
        if (scrollView.contentOffset.y > 0) hadOffsetScrollviewCount++;
    }
    
    return hadOffsetScrollviewCount > 0;
}

- (BOOL)headerGoUpToLimit {
    return _headerView_Y.constant <= -fabs(self.headerViewHeight - self.headerViewTopSafeDistance);
}

#pragma mark - 转发消息
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.propertyManager;
}

- (LZPageMenuPropertyManager *)propertyManager {
    if (!_propertyManager) {
        _propertyManager = [[LZPageMenuPropertyManager alloc] init];
        LZWeakSelf(weakSelf);
        _propertyManager.setIndicatorHierarchy = ^{
          [weakSelf.menuScrollView.layer insertSublayer:weakSelf.itemIndicator atIndex:0];
        };
    }
    return _propertyManager;
}

#pragma mark - 布局
- (void)viewDidLayoutSubviews {
    if (self.showMenuInNavigationBar) {
        _menuScrollView.frame = CGRectMake(self.menuInset.left, self.menuInset.top, self.menuWidth - self.menuInset.left - self.menuInset.right, self.menuHeight - self.menuInset.top - self.menuInset.bottom);
    }
}

- (void)setBaseConstraints {
    CGFloat y = 0, left = 0, right = 0, height = 0;
    
    // 头视图
    if (self.headerView) {
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        y = 0; left = 0; right = 0; height = self.headerViewHeight;
        [self setY:y left:left right:right height:height view:self.headerView superView:self.view];
    }
    
    // menuView
    if (!self.showMenuInNavigationBar) {
        height = self.menuHeight;
        
        [self setTopMargin:y left:left right:right height:height view:_menuView otherView:self.headerView superView:self.view];
    }
    
    // _contollerScrollView
    y = 0;
    CGFloat controllerScrollViewHeight = self.view.lz_height - self.menuHeight - self.headerViewTopSafeDistance - self.headerViewBottomSafeDistance;
    if (self.showMenuInNavigationBar) controllerScrollViewHeight += self.menuHeight;
    [self setTopMargin:y left:left right:right height:controllerScrollViewHeight view:_contollerScrollView otherView:_menuView superView:self.view];
   
    // 设置contentSize
    _contollerScrollView.contentSize = CGSizeMake(self.view.lz_width * self.propertyManager.viewControllers.count, controllerScrollViewHeight);
    
    // _menuScrollView
    if (!self.showMenuInNavigationBar) {
        left = self.menuInset.left;
        y = self.menuInset.top;
        right = -fabs(self.menuInset.right);
        height = self.menuHeight - self.menuInset.top - fabs(self.menuInset.bottom);
        [self setY:y left:left right:right height:height view:_menuScrollView superView:self.menuView];
    }
}

- (void)setY:(CGFloat)y left:(CGFloat)left right:(CGFloat)right height:(CGFloat)height view:(UIView *)view superView:(UIView *)superView {
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:y];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:left];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:right];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    
    [superView addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
    
    if ([view isEqual:self.headerView]) {
        _headerView_Y = constraint1;
        _headerView_Left = constraint2;
        _headerView_Right = constraint3;
        _headerView_Height = constraint4;
    }
}

- (void)setTopMargin:(CGFloat)topMargin left:(CGFloat)left right:(CGFloat)right height:(CGFloat)height view:(UIView *)view otherView:(UIView *)otherView superView:(UIView *)superView {
    NSLayoutConstraint *constraint1 = nil;
    
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:left];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:right];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:height];
    
    if (otherView) {
        constraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:otherView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:topMargin];
    }
    
    // 没有头视图， 为menuView添加约束
    if ([view isEqual:_menuView] && !otherView) {
        constraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:topMargin];
    }
    
    // 当菜单显示在导航栏，为_contollerScrollView添加约束
    if (self.showMenuInNavigationBar && [view isEqual:_contollerScrollView]) {
        constraint1 = [NSLayoutConstraint constraintWithItem:_contollerScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    }
    
    [superView addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
}

#pragma mark - 外部方法
- (void)reloadData {
    // 计算高度
    [self.propertyManager caclulateItemWidth];
    
    // 显示在导航栏
    if (self.showMenuInNavigationBar) [self showInNavigationBar];
    // 存在头部视图
    if (self.headerView && self.headerViewHeight > 0) [self configHeaderView];
    
    self.view.backgroundColor = self.pageMenuBackgroundColor;
    _menuView.backgroundColor = self.menuBackgroundColor;
    _menuScrollView.backgroundColor = self.menuBackgroundColor;
    _contollerScrollView.backgroundColor = self.pageMenuBackgroundColor;
    [self setupIndicator];
    
    if (self.menuBottomLineHeight > 0) {
        self.bottomLine.frame = CGRectMake(0.0, self.menuHeight - self.menuBottomLineHeight, self.view.lz_width, self.menuBottomLineHeight);
        self.bottomLine.backgroundColor = self.menuBottomLineColor.CGColor;
    }
    
    // 设置约束
    [self setBaseConstraints];
    
    // 刷新菜单
    _menuScrollView.propertyManager = self.propertyManager;
    [_menuScrollView reloadData];
}

- (void)updateAllItemTitle {
    [self.propertyManager caclulateItemWidth];
    [_menuScrollView reloadData];
    [self scrollIndicator:[self getCellFrame:_propertyManager.lastSelectedIndex]];
}

@end

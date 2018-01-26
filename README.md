# LZPageMenu
## 简介
LZPageMenu是一个强大的控制器分段，不仅支持多种样式的分段菜单，同时支持携带头部视图，支持OC和[Swift](https://github.com/Randy1993/PageMenu)，并支持CocoaPods。不仅仅只是实现功能，更希望从内存和性能上做优化，例如如何保证当前图层只有一个子控制器显示、又如何完成菜单子视图的复用等。因此LZPageMenu的实现方式与主流的实现大概存在差异，但也许存在更多的问题，项目处于初期阶段，望大家不吝赐教！

在这里要致敬[PageMenu](https://github.com/PageMenu/PageMenu)，一些思想来自于它。但由于自身需求的丰富性，因此进行了重写。

## 基本效果如下
![基本效果.gif](http://upload-images.jianshu.io/upload_images/2077842-aefa600eef091ba4.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 支持的样式

#### 丰富的指示
支持丰富的菜单指示样式：线条、圆点、图片、方块、椭圆等。并能够自定义指示的位置、宽度、高度等。

#### 圆点：
![圆点.PNG](http://upload-images.jianshu.io/upload_images/2077842-794cd2a05a507e0c.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 图片：
![图片.PNG](http://upload-images.jianshu.io/upload_images/2077842-5a0b59d0e2641caf.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 方块：
![方块.PNG](http://upload-images.jianshu.io/upload_images/2077842-bec5ef723289f00b.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 实心椭圆：
![实心椭圆.PNG](http://upload-images.jianshu.io/upload_images/2077842-6cdb5a62797d5e70.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 空心椭圆：
![空心椭圆.PNG](http://upload-images.jianshu.io/upload_images/2077842-77a147ed91626514.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 自定义指示位置：
![定义指示位置.PNG](http://upload-images.jianshu.io/upload_images/2077842-45b530e0fd348595.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 丰富的菜单样式
不仅仅支持普通的文本，还支持属性字符串、导航栏样式，能够随时随刻进行标题的刷新，更重要的是他支持菜单的自定义。不仅允许菜单选项宽度的自定义，更允许菜单宽度等分屏幕等。

#### 导航栏菜单：
![导航栏菜单.PNG](http://upload-images.jianshu.io/upload_images/2077842-05aade4795bff179.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 属性字符串菜单：
![属性字符串.PNG](http://upload-images.jianshu.io/upload_images/2077842-b005027044431cc9.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 宽度等分的菜单：

![宽度等分.PNG](http://upload-images.jianshu.io/upload_images/2077842-5094566d0fad4943.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 自定义宽度的菜单：
![自定义宽度.PNG](http://upload-images.jianshu.io/upload_images/2077842-6aaa6d06005e9fa2.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 更新标题：
![刷新标题.gif](http://upload-images.jianshu.io/upload_images/2077842-7ec4fe9bf6bf6914.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 自定义菜单样式：
![自定义菜单.gif](http://upload-images.jianshu.io/upload_images/2077842-72a923543a81501d.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 支持头视图
目前支持头视图的下拉缩放和下拉偏移两种模式，并支持自控制器多表格模式。

#### 下拉缩放：
![带头视图的下拉缩放.gif](http://upload-images.jianshu.io/upload_images/2077842-01b163fd95f8a71f.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 下拉偏移：
![下拉偏移.gif](http://upload-images.jianshu.io/upload_images/2077842-d986bf6936cca891.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 双表格：
![双表格.PNG](http://upload-images.jianshu.io/upload_images/2077842-e24f118d57f419a9.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 使用
```
 LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.lz_width, self.view.lz_height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
    }
    pageMenu.viewControllers = vcArrays;
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    [self.view addSubview:pageMenu.view];
```
所有共用户使用的属性、方法在LZPageMenuPropertyProtocol协议、LZPageMenu.h文件中提供：

#### 设置PegeMenu基本数据
```
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
```
#### 设置菜单栏Item指示线
```
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

```
#### 设置菜单底部整体线条
```
/// 底部线高度，设置该值大于0，将会显示菜单底部线条
@property (nonatomic, assign) CGFloat menuBottomLineHeight;
/// 底部线颜色
@property (nonatomic, strong) UIColor *menuBottomLineColor;
```
#### 设置菜单样式
```
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
```

#### 设置菜单Item
```
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
```

#### 设置垂直分割线
```
/// 垂直分割线宽度，设置该值大于0将显示垂直分割线
@property (nonatomic, assign) CGFloat verticalSeparatorWidth;
/// 垂直分割线高度
@property (nonatomic, assign) CGFloat verticalSeparatorHeight;
/// 垂直分割线颜色
@property (nonatomic, strong) UIColor *verticalSeparatorColor;
/// 隐藏最后一个Item的分割线，默认为YES
@property (nonatomic, assign) BOOL hideLastVerticalSeparator;
```
#### 将菜单显示在导航栏
```
/// 将菜单显示在导航栏，请在添加PageMenu至父视图后reloadData
@property (nonatomic, assign) BOOL showMenuInNavigationBar;
```

#### 设置头视图
```
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
```

#### 更新数据相关方法
```
/**
 刷新数据，赋值玩所有属性后调用
 */
- (void)reloadData;

/**
 刷新所有的标题, 需要提前设置menuItemTitles属性
 */
- (void)updateAllItemTitle;
```

#### 提供的代理方法
```

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
```

## Pod安装
```
pod 'LZPageMenu'
```
## 欢迎大家提issue、fork。

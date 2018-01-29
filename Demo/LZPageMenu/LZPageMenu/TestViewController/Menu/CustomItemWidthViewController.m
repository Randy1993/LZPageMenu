//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "CustomItemWidthViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"


@interface CustomItemWidthViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation CustomItemWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.frame.size.width, self.view.frame.size.height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    NSMutableArray *itemWidth = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
        [itemWidth addObject: @(60 + i * 5)];
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.menuItemSelectedWidths = itemWidth;
    pageMenu.menuItemUnSelectedWidths = itemWidth;
    pageMenu.menuItemWidthBasedOnTitleTextWidth = NO;
    /// 不希望指示线与文本等宽时，可以不设置该值
    pageMenu.selectionIndicatorWithEqualToTextWidth = NO;
    
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
}

@end



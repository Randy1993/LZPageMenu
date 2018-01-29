//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "NaviMenuViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"


@interface NaviMenuViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation NaviMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.frame.size.width, self.view.frame.size.height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 2; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.menuItemSpace = 10.0;
    pageMenu.menuContentInset = UIEdgeInsetsZero;
    pageMenu.menuInset = UIEdgeInsetsZero;
    pageMenu.menuBackgroundColor = [UIColor clearColor];
    pageMenu.selectedMenuItemLabelColor = [UIColor blueColor];
    pageMenu.unselectedMenuItemLabelColor = [UIColor blackColor];
    pageMenu.selectedMenuItemLabelFont = [UIFont boldSystemFontOfSize:16];
    pageMenu.unselectedMenuItemLabelFont = [UIFont boldSystemFontOfSize:16];
    pageMenu.enableHorizontalBounce = NO;
    pageMenu.selectionIndicatorColor = [UIColor redColor];
    pageMenu.needShowSelectionIndicator = YES;
    pageMenu.showMenuInNavigationBar = YES;
    pageMenu.enableScroll = NO;
    pageMenu.defaultSelectedIndex = 1;
    
    [self.view addSubview:pageMenu.view];
    [pageMenu reloadData];
    _pageMenu = pageMenu;
}

@end


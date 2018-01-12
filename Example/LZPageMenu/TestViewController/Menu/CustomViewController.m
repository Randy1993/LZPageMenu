//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "CustomViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"
#import "LZPageMenuHeader.h"
#import "CustomMenuDelegate.h"

@interface CustomViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;
/// CustomMenuDelegate
@property (nonatomic, strong) CustomMenuDelegate *customMenuDelegate;

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.lz_width, self.view.lz_height - LZ_NavHeight)];
    self.customMenuDelegate = [[CustomMenuDelegate alloc] init];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.defaultSelectedIndex = 2;
    pageMenu.menuHeight = 80;
    pageMenu.menuBackgroundColor = [UIColor whiteColor];
    pageMenu.customDelegate = _customMenuDelegate;
    pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    pageMenu.menuBottomLineColor = [UIColor grayColor];
    pageMenu.menuBottomLineHeight = 1.0;
    pageMenu.verticalSeparatorWidth = 1.0;
    pageMenu.verticalSeparatorColor = [UIColor lightGrayColor];
    pageMenu.verticalSeparatorHeight = 50.0;
    
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
}

@end





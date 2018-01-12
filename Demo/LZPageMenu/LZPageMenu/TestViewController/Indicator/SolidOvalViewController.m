//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "SolidOvalViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"
#import "LZPageMenuHeader.h"

@interface SolidOvalViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation SolidOvalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.lz_width, self.view.lz_height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.menuHeight = 44.0;
    pageMenu.selectionIndicatorType = LZSelectionIndicatorTypeSolidOval;
    pageMenu.selectionIndicatorColor = [UIColor redColor];
    pageMenu.selectedMenuItemLabelColor = [UIColor blueColor];
    pageMenu.selectionIndicatorHeight = 44.0;
    pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, -8.0, 0.0, -8.0);
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
}

@end





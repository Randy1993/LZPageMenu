//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "OffsetHeaderViewController.h"
#import "SubTableViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"
#import "LZPageMenuHeader.h"
#import "LZHeaderView.h"

@interface OffsetHeaderViewController ()<LZPageMenuDelegate>

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation OffsetHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.lz_width, self.view.lz_height - LZ_NavHeight)];
    
    LZHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"LZHeaderView" owner:nil options:nil].firstObject;
    headerView.frame = CGRectMake(0.0, 0.0, self.view.lz_width, 150);
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        if (i % 2 == 0) {
            SubTableViewController *vc = [[SubTableViewController alloc] initWithNibName:@"SubTableViewController" bundle:nil];
            vc.title = [NSString stringWithFormat:@"第%d个", i+1];
            [vcArrays addObject:vc];
        } else {
            ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
            vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
            [vcArrays addObject:vc];
            vc.title = [NSString stringWithFormat:@"第%d个", i+1];
            
        }
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.headerView = headerView;
    pageMenu.headerViewHeight = 150.0;
    pageMenu.headerViewTopSafeDistance = 75;
    pageMenu.enableHorizontalBounce = NO;
    pageMenu.stretchHeaderView = NO;
    pageMenu.delegate = self;
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
}

#pragma mark - LZPageMenuDelegate
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    NSLog(@"将要移动到第%ld个控制器", index);
}

@end



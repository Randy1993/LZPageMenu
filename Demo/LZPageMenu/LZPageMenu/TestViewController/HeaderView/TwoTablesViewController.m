//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "TwoTablesViewController.h"
#import "SubTableViewController1.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"

#import "LZHeaderView.h"

@interface TwoTablesViewController ()<LZPageMenuDelegate>

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;
/// description
@property (nonatomic, weak) LZHeaderView *headerView;

@end

@implementation TwoTablesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:self.view.bounds];
    
    __weak __typeof(self) weakSelf = self;
    LZHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"LZHeaderView" owner:nil options:nil].firstObject;
    headerView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 150);
    headerView.goBackBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        if (i % 2 == 0) {
            SubTableViewController1 *vc = [[SubTableViewController1 alloc] init];
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
    pageMenu.headerViewTopSafeDistance = LZ_NavHeight;
    pageMenu.enableHorizontalBounce = NO;
    pageMenu.delegate = self;
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    _headerView = headerView;
    [self.view addSubview:pageMenu.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - LZPageMenuDelegate
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index {
    NSLog(@"将要移动到第%ld个控制器", index);
}

- (void)headerViewOffsetY:(CGFloat)offsetY heightOffset:(CGFloat)offsetHeight {
    _headerView.barView.hidden = !(offsetY < 0 && fabs(offsetY) >= _pageMenu.headerViewHeight - _pageMenu.headerViewTopSafeDistance);
}
@end



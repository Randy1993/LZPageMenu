//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "UpdateTitleViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"


@interface UpdateTitleViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation UpdateTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.frame.size.width, self.view.frame.size.height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
    }
    pageMenu.viewControllers = vcArrays;
    //    pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 300.0, 100.0, 40.0)];
    [button setTitle:@"更新标题" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(changePageMenuTitles) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)changePageMenuTitles {
    [_pageMenu.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = [NSString stringWithFormat:@"新标题:%ld", idx+1];
    }];
    [_pageMenu updateAllItemTitle];
}

@end


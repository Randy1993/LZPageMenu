//
//  BasicViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "AttributeViewController.h"
#import "ShowViewController.h"
#import "ShowViewController.h"
#import "LZPageMenu.h"
#import "LZPageMenuHeader.h"

@interface AttributeViewController ()

/// pageMenu
@property (nonatomic, strong) LZPageMenu *pageMenu;

@end

@implementation AttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    LZPageMenu *pageMenu = [[LZPageMenu alloc] initWithFrame:CGRectMake(0.0, LZ_NavHeight, self.view.lz_width, self.view.lz_height - LZ_NavHeight)];
    
    NSMutableArray *vcArrays = [NSMutableArray array];
    NSMutableArray *unSelectedAttributes = [NSMutableArray array];
    NSMutableArray *selectedAttributes = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        ShowViewController *vc = [[ShowViewController alloc] initWithNibName:@"ShowViewController" bundle:nil];
        vc.infoText = [NSString stringWithFormat:@"第%d个控制器", i+1];
        [vcArrays addObject:vc];
        vc.title = [NSString stringWithFormat:@"第%d个", i+1];
        
        [unSelectedAttributes addObject:[self getAttributeText:[NSString stringWithFormat:@"第%d个", i] selected:NO]];
        [selectedAttributes addObject:[self getAttributeText:[NSString stringWithFormat:@"第%d个", i] selected:YES]];
    }
    pageMenu.viewControllers = vcArrays;
    pageMenu.selectionIndicatorOffset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 20);
    pageMenu.menuItemUnSelectedTitles = unSelectedAttributes;
    pageMenu.menuItemSelectedTitles = selectedAttributes;
    [pageMenu reloadData];
    _pageMenu = pageMenu;
    
    [self.view addSubview:pageMenu.view];
}

- (NSAttributedString *)getAttributeText:(NSString *)text selected:(BOOL)selected {
    UIColor *firstColor = selected ? [UIColor redColor] : [UIColor whiteColor];
    UIColor *secondColor = selected ? [UIColor blackColor] : [UIColor lightGrayColor];
    
    NSAttributedString *firstAttribute = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{
                                                                                      NSBaselineOffsetAttributeName: @(0),
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:18.0],
                                                                                      NSForegroundColorAttributeName:firstColor }];
    NSAttributedString *secondAttribute = [[NSAttributedString alloc] initWithString:@"(备注)"
                                                                          attributes:@{
                                                                                       NSBaselineOffsetAttributeName     : @(0),
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                                                                       NSForegroundColorAttributeName: secondColor}];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:firstAttribute];
    [mutableStr appendAttributedString:secondAttribute];
    return mutableStr.copy;
}
@end



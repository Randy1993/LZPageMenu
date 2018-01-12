//
//  TableViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "TableViewController.h"
#import "FHHFPSIndicator.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self jumpToViewController:@"BasicViewController"];
                break;
                
            case 1:
                [self jumpToViewController:@"DotViewController"];
                break;
                
            case 2:
                [self jumpToViewController:@"ImageViewController"];
                break;
                
            case 3:
                [self jumpToViewController:@"BlockViewController"];
                break;
                
            case 4:
                [self jumpToViewController:@"SolidOvalViewController"];
                break;
                
            case 5:
                [self jumpToViewController:@"HollowOvalViewController"];
                break;
                
            case 6:
                [self jumpToViewController:@"SpecialBlockViewController"];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                 [self jumpToViewController:@"CustomViewController"];
                break;
            case 1:
                 [self jumpToViewController:@"NaviMenuViewController"];
                break;
            case 2:
                [self jumpToViewController:@"AttributeViewController"];
                break;
            case 3:
                [self jumpToViewController:@"UpdateTitleViewController"];
                break;
            case 4:
                [self jumpToViewController:@"AverageViewController"];
                break;
            case 5:
                [self jumpToViewController:@"CustomItemWidthViewController"];
                break;
            default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self jumpToViewController:@"HeaderViewController"];
                break;
            case 1:
                [self jumpToViewController:@"TwoTablesViewController"];
                break;
            case 2:
                [self jumpToViewController:@"OffsetHeaderViewController"];
                break;
            default:
                break;
        }
    }
}

- (void)jumpToViewController:(NSString *)className {
    [self.navigationController pushViewController:[NSClassFromString(className) new] animated:YES];
}

@end

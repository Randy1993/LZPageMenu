//
//  SubTableViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/8.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "SubTableViewController.h"

@interface SubTableViewController ()

@end

@implementation SubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifire = @"Indentifire";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifire];
    }
 
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell", indexPath.row];
 
    return cell;
}

@end

//
//  SubTableViewController1.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/10.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "SubTableViewController1.h"

@interface SubTableViewController1 ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SubTableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView:1];
    [self createTableView:2];
}

- (void)createTableView:(NSInteger)tag {
    CGRect frame = tag == 1 ? CGRectMake(0.0, 0.0, self.view.frame.size.width/2, self.view.frame.size.height) : CGRectMake(self.view.frame.size.width/2, 0.0, self.view.frame.size.width/2, self.view.frame.size.height);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.tag = tag;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个表格-%ld", tableView.tag, indexPath.row];
    
    return cell;
}

@end

//
//  ShowViewController.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/4.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _infoLabel.text = _infoText;
    
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
    self.view.layer.borderWidth = 1.0;
}

@end

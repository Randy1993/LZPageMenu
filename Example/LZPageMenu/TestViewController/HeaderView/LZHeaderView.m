//
//  LZHeaderView.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/10.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "LZHeaderView.h"
#import "LZPageMenuHeader.h"

@implementation LZHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.layer.borderColor = [UIColor blueColor].CGColor;
    _imageView.layer.borderWidth = 1;
    _barViewHeight.constant = LZ_NavHeight;
}

- (IBAction)backButtonAction:(id)sender {
    !self.goBackBlock ? : self.goBackBlock();
}

@end

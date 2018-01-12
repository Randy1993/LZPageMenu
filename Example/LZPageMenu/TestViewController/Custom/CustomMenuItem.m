//
//  CustomMenuItem.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/3.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "CustomMenuItem.h"

@interface CustomMenuItem()

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation CustomMenuItem

- (void)configData:(id)data index:(NSInteger)index selected:(BOOL)selected {
    _label1.textColor = selected ? [UIColor redColor] : [UIColor orangeColor];
    _label2.textColor = selected ? [UIColor blueColor] : [UIColor lightGrayColor];
    
    if (!data || ![data isKindOfClass:NSDictionary.class]) return;
    
    NSDictionary *dic = data;
    
    _label1.text = dic[@"Title"];
    _label2.text = dic[@"SubTitle"];
}

@end

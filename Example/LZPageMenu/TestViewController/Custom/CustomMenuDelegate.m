//
//  CustomMenuDelegate.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/3.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "CustomMenuDelegate.h"
#import "CustomMenuItem.h"

@implementation CustomMenuDelegate
- (UIView *)menuItemView:(NSInteger)index {
    return [[NSBundle mainBundle] loadNibNamed:@"CustomMenuItem" owner:nil options:nil].firstObject;
}

- (CGFloat)menuItemUnselectedWidth:(NSInteger)index {
    return 130.0;
}

- (id)customViewData:(NSInteger)index {
    return @{@"Title":[NSString stringWithFormat:@"标题：%ld", index],
             @"SubTitle":[NSString stringWithFormat:@"副标题：%ld", index]
             };
}
@end

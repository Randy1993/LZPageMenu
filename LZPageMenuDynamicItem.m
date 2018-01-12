//
//  LZPageMenuDynamicItem.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/10.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import "LZPageMenuDynamicItem.h"

@implementation LZPageMenuDynamicItem

@synthesize center, bounds, transform;

- (instancetype)init {
    if (self = [super init]) {
        bounds = CGRectMake(0, 0, 1, 1);
    }
    return self;
}

@end

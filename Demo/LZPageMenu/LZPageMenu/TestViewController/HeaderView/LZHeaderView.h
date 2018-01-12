//
//  LZHeaderView.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/10.
//  Copyright © 2017年 Randy Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barViewHeight;

@property (nonatomic, strong) void(^goBackBlock)(void);
@end

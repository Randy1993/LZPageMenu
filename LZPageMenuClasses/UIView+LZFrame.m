//
//  UIView+LZFrame.m
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/3.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import "UIView+LZFrame.h"

@implementation UIView (LZFrame)
- (CGFloat)lz_x {
    return CGRectGetMinX(self.frame);
}

- (void)setLz_x:(CGFloat)lz_x {
    CGRect frame = self.frame;
    frame.origin.x = lz_x;
    self.frame = frame;
}

- (CGFloat)lz_y {
    return CGRectGetMinY(self.frame);
}

- (void)setLz_y:(CGFloat)lz_y {
    CGRect frame = self.frame;
    frame.origin.y = lz_y;
    self.frame = frame;
}

- (CGFloat)lz_width {
    return CGRectGetWidth(self.frame);
}

- (void)setLz_width:(CGFloat)lz_width {
    CGRect frame = self.frame;
    frame.size.width = lz_width;
    self.frame = frame;
}

- (CGFloat)lz_height {
    return CGRectGetHeight(self.frame);
}

- (void)setLz_height:(CGFloat)lz_height {
    CGRect frame = self.frame;
    frame.size.height = lz_height;
    self.frame = frame;
}

- (CGFloat)lz_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setLz_right:(CGFloat)lz_right {
    CGRect frame = self.frame;
    frame.origin.x = lz_right - CGRectGetWidth(self.frame);
    self.frame = frame;
}

- (CGFloat)lz_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setLz_bottom:(CGFloat)lz_bottom {
    CGRect frame = self.frame;
    frame.origin.y = lz_bottom - CGRectGetHeight(self.frame);
    self.frame = frame;
}

- (CGFloat)lz_centerX {
    return self.center.x;
}

- (void)setLz_centerX:(CGFloat)lz_centerX {
    self.center = CGPointMake(lz_centerX, self.center.y);
}

- (CGFloat)lz_centerY {
    return self.center.y;
}

- (void)setLz_centerY:(CGFloat)lz_centerY {
    self.center = CGPointMake(self.center.x, lz_centerY);
}

- (CGPoint)lz_origin {
    return self.frame.origin;
}

- (void)setLz_origin:(CGPoint)lz_origin {
    CGRect frame = self.frame;
    frame.origin = lz_origin;
    self.frame = frame;
}

- (CGSize)lz_size {
    return self.frame.size;
}

- (void)setLz_size:(CGSize)lz_size {
    CGRect frame = self.frame;
    frame.size = lz_size;
    self.frame = frame;
}

@end

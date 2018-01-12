//
//  LZPageMenuCustomProtocol.h
//  LZPageMenu
//
//  Created by Randy Liu on 2018/1/2.
//  Copyright © 2018年 Randy Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LZPageMenuCustomProtocol <NSObject>

/**
 自定义视图时进行视图数据的配置

 @param data 视图对应的数据
 @param index 视图对应的下标
 */
//- (void)configData:(id)data index:(NSInteger)index;

/**
 自定义菜单视图

 UIView可实现 -(void)configData:(id)data index:(NSInteger)index selected:(BOOL)selected完成配置
 
 @param index item对应的下标
 @return <#return value description#>
 */
- (UIView *)menuItemView:(NSInteger)index;

/**
 item未选中宽度
 
 @param index item对应的下标
 */
- (CGFloat)menuItemUnselectedWidth:(NSInteger)index;

@optional

/**
 item选中宽度
 
 @param index item对应的下标
 */
- (CGFloat)menuItemSelectedWidth:(NSInteger)index;

/**
 自定义菜单视图，item对应的数据
 
 @param index item对应的下标
 */
- (id)customViewData:(NSInteger)index;

@end

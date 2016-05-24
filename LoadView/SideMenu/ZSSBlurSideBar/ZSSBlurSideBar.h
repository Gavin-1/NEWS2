//
//  ZSSBlurSideBar.h
//  BlurSideBar
//
//  Created by 郑随山 on 16/5/19.
//  Copyright © 2016年 郑随山. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kSidebarWidth
#define kSidebarWidth ([[UIScreen mainScreen] bounds].size.width-114) // 侧栏宽度，设屏宽为320，右侧留一条空白可以看到背后页面内容
#endif

@interface ZSSBlurSideBar : UIViewController

@property (nonatomic, retain) UIView* contentView; // 所有要显示的子控件全添加到这里
@property (nonatomic, assign) BOOL isSidebarShown;

/**
 * @brief 当有pan事件时调用，传入UIPanGestureRecognizer
 */
- (void)panDetected:(UIPanGestureRecognizer *)recoginzer;

/**
 * @brief 执行显示/隐藏Sidebar
 */
- (void)showHideSidebar;

/**
 * @brief 需要时可以在子类中用
 */
- (void)sidebarDidShown;

/**
 * @brief 设置侧栏的背景色，参数为16进制0xffffff的形式
 */
- (void)setBgRGB:(long)rgb;

@end

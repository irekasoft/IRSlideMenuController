//
//  UIViewController+IRSlideMenuController.h
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRSlideMenuController;

@interface UIViewController (IRSlideMenuController)

@property (nonatomic, weak, readonly) IRSlideMenuController *slideMenuController;
@end

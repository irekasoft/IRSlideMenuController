//
//  UIViewController+IRSlideMenuController.m
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "UIViewController+IRSlideMenuController.h"

#import "IRSlideMenuController.h"

@implementation UIViewController (IRSlideMenuController)

- (IRSlideMenuController *)slideMenuController {
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[IRSlideMenuController class]]) {
            return (IRSlideMenuController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end

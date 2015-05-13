//
//  IRSlideMenuController.h
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _IRSlideMenuPanelStyle {
    JASidePanelSingleActive = 0,
    JASidePanelMultipleActive
} IRSlideMenuPanelStyle;

typedef enum _IRSlideMenuPanelState {
    IRSlideMenuPanelCenterVisible = 1,
    IRSlideMenuPanelLeftVisible,
    IRSlideMenuPanelRightVisible
} IRSlideMenuPanelState;

@interface IRSlideMenuController : UIViewController {
    
    CGFloat leftMenuWidth;
    
}


// show the panels
- (void)showLeftPanelAnimated:(BOOL)animated;
- (void)hideLeftPanelAnimated:(BOOL)animated;


- (id)initWithMainVC:(UIViewController *)mainVC leftMenuVC:(UIViewController *)leftMenuVC;

// toggle them opened/closed
- (void)toggleLeftPanel:(id)sender;


@end

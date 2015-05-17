//
//  IRSlideMenuController.h
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>



#define X_MAX_LEFT_START 35
#define pointOfNoReturnWidth 50
#define WANT_SWIPE_GESTURE NO
#define MAX_OPACITY 0.5
#define RATIO_MENU_WIDTH 0.9


typedef enum _IRSlideMenuPanelState {
    IRSlideMenuPanelCenterVisible = 1,
    IRSlideMenuPanelLeftVisible,
    IRSlideMenuPanelRightVisible
} IRSlideMenuPanelState;


@interface IRSlideMenuController : UIViewController <UIGestureRecognizerDelegate>{
    
    CGFloat leftMenuWidth;
    CGFloat leftMenuWidthPercent;
    
    CGRect  frameAtStartOfPan;
    CGPoint startPointOfPan;
    BOOL    wasOpenAtStartOfPan;
    BOOL    wasHiddenAtStartOfPan;

}

@property (strong) UIViewController *mainViewController;
@property (strong) UIViewController *leftMenuViewController;

@property (strong) UIPanGestureRecognizer   *leftPanGesture;
@property (strong) UISwipeGestureRecognizer *swipeRight;


// show the panels
- (void)showLeftPanelAnimated:(BOOL)animated;
- (void)hideLeftPanelAnimated:(BOOL)animated;

- (void)changeMainViewController:(UIViewController*)mainViewController close:(BOOL)close;

    

- (id)initWithMainVC:(UIViewController *)mainVC leftMenuVC:(UIViewController *)leftMenuVC;

// toggle them opened/closed
// - (void)toggleLeftPanel:(id)sender;


@end

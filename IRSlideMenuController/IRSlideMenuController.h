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

//
//struct LeftPanState {
//    static var frameAtStartOfPan: CGRect = CGRectZero
//    static var startPointOfPan: CGPoint = CGPointZero
//    static var wasOpenAtStartOfPan: Bool = false
//    static var wasHiddenAtStartOfPan: Bool = false
//}

#define X_MAX_LEFT_START 35
#define pointOfNoReturnWidth 50

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
- (void)toggleLeftPanel:(id)sender;


@end

//
//  IRSlideMenuController.m
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "IRSlideMenuController.h"

@interface IRSlideMenuController ()

// Current state of panels. Use KVO to monitor state changes
@property (nonatomic, readonly) IRSlideMenuPanelState state;

@property (strong) UIView *opacityView;

@property (nonatomic, strong) UIView *tapView;

@end

@implementation IRSlideMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithMainVC:(UIViewController *)mainVC leftMenuVC:(UIViewController *)leftMenuVC{
    
    if (self = [super init]) {
        
        self.mainViewController     = mainVC;
        self.leftMenuViewController = leftMenuVC;
        
        [self addChildViewController:mainVC];
        [self addChildViewController:leftMenuVC];
        
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) && (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) )) {
            [self _initViewFor_iPad];
            self.isSideBySide = YES;
        }else{
            [self _initView];
        }
        

        [self _addLeftGestures];
    }
    
    
    return self;
}

- (void)_initViewFor_iPad {
    
    leftMenuWidthPercent = RATIO_MENU_WIDTH;
    
    CGFloat leftToMainRatio = 0.3;

    self.isSideBySide_MainFrame = CGRectMake(self.mainViewController.view.frame.size.width *leftToMainRatio, 0,
                                             self.mainViewController.view.frame.size.width * (1- leftToMainRatio),
                                             self.mainViewController.view.frame.size.height);
    self.mainViewController.view.frame = self.isSideBySide_MainFrame;
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    
    leftMenuWidth = self.view.frame.size.width * leftMenuWidthPercent;
    
    
    self.leftMenuViewController.view.frame =  CGRectMake(0, 0, self.view.frame.size.width*leftToMainRatio, self.mainViewController.view.frame.size.height);
;
    self.leftMenuViewController.view.clipsToBounds = YES;
    
    [self.view insertSubview:self.leftMenuViewController.view atIndex:1];
    
    // we dont use transformation as we will have pan gesture
//    self.leftMenuViewController.view.frame = CGRectMake(-self.view.frame.size.width*leftMenuWidthPercent,
//                                                        0,
//                                                        self.leftMenuViewController.view.frame.size.width,
//                                                        self.leftMenuViewController.view.frame.size.height);
    
}

- (void)_initView {
    
    leftMenuWidthPercent = RATIO_MENU_WIDTH;
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    
    leftMenuWidth = self.view.frame.size.width * leftMenuWidthPercent;
    
    self.leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width*leftMenuWidthPercent, self.view.frame.size.height);
    self.leftMenuViewController.view.clipsToBounds = YES;
    
    [self.view insertSubview:self.leftMenuViewController.view atIndex:1];

    // we dont use transformation as we will have pan gesture
    self.leftMenuViewController.view.frame = CGRectMake(-self.view.frame.size.width*leftMenuWidthPercent,
                                                        0,
                                                        self.leftMenuViewController.view.frame.size.width,
                                                        self.leftMenuViewController.view.frame.size.height);
    
}



- (CGRect)_applyLeftTranslation:(CGPoint)translation toFrame:(CGRect)toFrame{
    
    CGFloat newOrigin = toFrame.origin.x;
    newOrigin += translation.x;
    
//    CGFloat minOrigin = leftMenuWidth;
    CGFloat maxOrigin = 0.0;
    CGRect newFrame = toFrame;

    // if we pan more we will ignore it
    if (newOrigin > maxOrigin) {
        newOrigin = maxOrigin;
    }else if (newOrigin < maxOrigin){

    }
    
    newFrame.origin.x = newOrigin;
    
//    NSLog(@"%@: new frame %@",NSStringFromCGPoint(translation), NSStringFromCGRect(newFrame));
    
    return newFrame;
    
}

- (void)_addLeftGestures{
    
    self.swipeRight =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    self.swipeRight.delegate = self;
    self.swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeRight];
    
    
    
    if (self.leftPanGesture == nil) {
        
        self.leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPanGesture:)];
        self.leftPanGesture.delegate = self;
        [self.view addGestureRecognizer:self.leftPanGesture];
    }

    
}

#pragma mark - swipe handler

-(void)swipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if ([self.mainViewController isKindOfClass:[UINavigationController class]]) {
        
        NSArray* vc = [(UINavigationController *)self.mainViewController viewControllers];
        if ([vc count] > 1) {
            return;
        }
    }
    [self showLeftPanelAnimated:YES];
}

#pragma mark - handle pan gesture

- (void)handleLeftPanGesture:(UIPanGestureRecognizer *)panGesture{
   
    if ([self.mainViewController isKindOfClass:[UINavigationController class]]) {
        
        NSArray* vc = [(UINavigationController *)self.mainViewController viewControllers];
        if ([vc count] > 1) {
            return;
        }
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
         
            frameAtStartOfPan = self.leftMenuViewController.view.frame;
            startPointOfPan = [panGesture locationInView:self.view];
            
            [self.leftMenuViewController beginAppearanceTransition:YES animated:YES];
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            
            CGPoint translation = [panGesture translationInView:panGesture.view];
//            NSLog(@"translation %@", NSStringFromCGPoint(translation));
            
            self.leftMenuViewController.view.frame = [self _applyLeftTranslation:translation toFrame:frameAtStartOfPan];
            [self updateOpacityView];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            
            CGFloat thresholdVelocity = 1000.0;
            CGFloat pointOfNoReturn  = floor(leftMenuWidth)/2;
            
            
            CGFloat leftOrigin = self.leftMenuViewController.view.frame.origin.x + self.leftMenuViewController.view.frame.size.width;
            
            BOOL shouldOpen = NO;
            
            if (leftOrigin >= pointOfNoReturn) {
                shouldOpen = YES;
            }else{
                shouldOpen = NO;
            }
            
            if (velocity.x >= thresholdVelocity) {
                shouldOpen = YES;

            } else if (velocity.x <= -1.0 * thresholdVelocity) {
                shouldOpen = NO;
            }
            
            if (shouldOpen==YES) {
                [self showLeftPanelAnimated:YES];
            }else{
                [self hideLeftPanelAnimated:YES];
            }

            [self updateOpacityView];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)addTapGestureToView:(UIView *)view {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerPanelTapped:)];
    [view addGestureRecognizer:tapGesture];
    
}

- (void)centerPanelTapped:(__unused UIGestureRecognizer *)gesture
{
    self.tapView = gesture.view;
    [self showCenterPanel:YES bounce:NO];
    
}

- (void)changeMainViewController:(UIViewController*)mainViewController close:(BOOL)close{
    
    [self.mainViewController willMoveToParentViewController:nil];
    [self.mainViewController removeFromParentViewController];
    [self.mainViewController.view removeFromSuperview];
    
    self.mainViewController = mainViewController;
    
    if (self.isSideBySide) {
        self.mainViewController.view.frame = self.isSideBySide_MainFrame;
    }
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    [self addChildViewController:self.mainViewController];
    
    
    if (close) {
        [self hideLeftPanelAnimated:YES];
    }
    
    
}

#pragma mark - public method actions

- (void)showCenterPanel:(BOOL)animated bounce:(BOOL)shouldBounce {
    
    self.state = IRSlideMenuPanelCenterVisible;
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self hideLeftPanelAnimated:YES];
    
    self.tapView = nil;

}

- (void)hideLeftPanelAnimated:(BOOL)animated{

    if (self.isSideBySide) {
        return;
    }
    
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:0 animations:^{
        self.leftMenuViewController.view.frame = CGRectMake(-self.view.frame.size.width*leftMenuWidthPercent,
                                                            0,
                                                            self.leftMenuViewController.view.frame.size.width,
                                                            self.leftMenuViewController.view.frame.size.height);
    self.opacityView.layer.opacity = 0.0;
       
        
    }completion:^(BOOL finished) {
        
        [self.opacityView removeFromSuperview];
        self.opacityView = nil;
        
        for (UIGestureRecognizer *recognizer in self.mainViewController.view.gestureRecognizers) {
            [self.mainViewController.view removeGestureRecognizer:recognizer];
        }
        for (UIGestureRecognizer *recognizer in self.leftMenuViewController.view.gestureRecognizers) {
            [self.mainViewController.view removeGestureRecognizer:recognizer];
        }
        
    }];
    
}


- (void)showLeftPanelAnimated:(BOOL)animated
{
    
    if (self.isSideBySide) {
        return;
    }
    
    NSLog(@"showLeftPanelAnimated");
    [self _updateOpacityViewMax];
    [self _showLeftPanel:animated bounce:NO];
    
}



#pragma mark - Showing Panels (Private)

- (void)_updateOpacityViewMax{
    
    if (self.opacityView == nil) {
        
        self.opacityView = [[UIView alloc] initWithFrame:self.mainViewController.view.frame];
        self.opacityView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:self.opacityView atIndex:1];
        [self addTapGestureToView:self.opacityView];
    }
    
    CGFloat width = self.leftMenuViewController.view.frame.size.width;
    CGFloat leftViewEdgeFloat = self.leftMenuViewController.view.frame.origin.x + width;
    CGFloat openedLeftRatio = leftViewEdgeFloat/width;
    self.opacityView.layer.opacity = openedLeftRatio*MAX_OPACITY;

    [UIView animateWithDuration:0.5 animations:^{
        self.opacityView.layer.opacity = MAX_OPACITY;
    }];
    

}

- (void)updateOpacityView{
    
    CGFloat width = self.leftMenuViewController.view.frame.size.width;
    CGFloat leftViewEdgeFloat = self.leftMenuViewController.view.frame.origin.x + width;
    CGFloat openedLeftRatio = leftViewEdgeFloat/width;
    
    

    if (self.opacityView == nil) {
        
        self.opacityView = [[UIView alloc] initWithFrame:self.mainViewController.view.frame];
        self.opacityView.backgroundColor = [UIColor blackColor];
        
        [self.view insertSubview:self.opacityView atIndex:1];
        
        [self addTapGestureToView:self.opacityView];
    }
    
    
    self.opacityView.layer.opacity = openedLeftRatio*MAX_OPACITY;

}

- (void)_showLeftPanel:(BOOL)animated bounce:(BOOL)shouldBounce {
    
    self.state = IRSlideMenuPanelLeftVisible;

    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.2 options:0 animations:^{

        self.leftMenuViewController.view.frame = CGRectMake(0,
                                                            0,
                                                            self.leftMenuViewController.view.frame.size.width,
                                                            self.leftMenuViewController.view.frame.size.height);

    } completion:^(BOOL finished) {
        UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeft];

    }];
    
    
}

-(void)swipeLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self hideLeftPanelAnimated:YES];
}

#pragma mark - State

- (void)setState:(IRSlideMenuPanelState)state {
    if (state != _state) {
        
        _state = state;

        switch (_state) {
            case IRSlideMenuPanelCenterVisible: {
                self.leftMenuViewController.view.userInteractionEnabled = NO;
                break;
            }
            case IRSlideMenuPanelLeftVisible: {
                
                self.leftMenuViewController.view.userInteractionEnabled = YES;
                break;
            }
            case IRSlideMenuPanelRightVisible: {
                break;
            }
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == self.leftPanGesture) {
        
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];

        // this is where the min finger can pan out the
        // menu
        if (point.x <= X_MAX_LEFT_START) {
            return YES;
        }else{
            return NO;
        }
        
        
    }else if (gestureRecognizer == self.swipeRight){
        return WANT_SWIPE_GESTURE;
    }
    
    return NO;
    
}


@end

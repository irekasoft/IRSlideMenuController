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
        
        
        [self _initView];
        [self _addLeftGestures];
    }
    
    
    return self;
}

- (void)_initView {
    
    leftMenuWidthPercent = 0.9;
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    
    leftMenuWidth = self.view.frame.size.width * leftMenuWidthPercent;
    
    self.leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width*leftMenuWidthPercent, self.view.frame.size.height);
    self.leftMenuViewController.view.clipsToBounds = YES;
    
    [self.view insertSubview:self.leftMenuViewController.view atIndex:1];
    
//    self.leftMenuViewController.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width*leftMenuWidthPercent, 0);
    
    self.leftMenuViewController.view.frame = CGRectMake(-self.view.frame.size.width*leftMenuWidthPercent,
                                                        0,
                                                        self.leftMenuViewController.view.frame.size.width,
                                                        self.leftMenuViewController.view.frame.size.height);
    

    
    //
    
}



- (CGRect)_applyLeftTranslation:(CGPoint)translation toFrame:(CGRect)toFrame{
    
    NSLog(@"to frame  %@ %f", NSStringFromCGRect(toFrame), leftMenuWidth);
    
    CGFloat newOrigin = toFrame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = leftMenuWidth;
    CGFloat maxOrigin = 0.0;
    CGRect newFrame = toFrame;
    
    if (newOrigin > maxOrigin) {
        newOrigin = maxOrigin;
    }else if (newOrigin < maxOrigin){
//        newOrigin = maxOrigin;
    }
    
    newFrame.origin.x = newOrigin;
    
    NSLog(@"%@: new frame %@",NSStringFromCGPoint(translation), NSStringFromCGRect(newFrame));
    
    return newFrame;
    
}

- (void)_addLeftGestures{
    
    //
    
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

- (BOOL)isRightOpen{
    return NO;
}

#pragma mark - handle pan gesture

- (void)handleLeftPanGesture:(UIPanGestureRecognizer *)panGesture{
    
    if ([self isRightOpen] == YES){
        return;
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
            

            
            NSLog(@"translation %@", NSStringFromCGPoint(translation));
            
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
                NSLog(@"to2 open");

                shouldOpen = YES;
            }else{
                NSLog(@"to2 close");

                shouldOpen = NO;
            }
            
            NSLog(@"velocity %f",velocity);
            
            if (velocity.x >= thresholdVelocity) {
                shouldOpen = YES;
                NSLog(@"thresholdVelocity open");

                
            } else if (velocity.x <= -1.0 * thresholdVelocity) {
                NSLog(@"thresholdVelocity close");

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

- (void)centerPanelTapped:(__unused UIGestureRecognizer *)gesture {

    NSLog(@"hrer");
    
    self.tapView = gesture.view;
    [self showCenterPanel:YES bounce:NO];
    
}

- (void)changeMainViewController:(UIViewController*)mainViewController close:(BOOL)close{
    
    [self.mainViewController willMoveToParentViewController:nil];
    [self.mainViewController removeFromParentViewController];
    [self.mainViewController.view removeFromSuperview];
    
    self.mainViewController = mainViewController;
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    [self addChildViewController:self.mainViewController];
    
    
    if (close) {
        [self hideLeftPanelAnimated:YES];
    }
    
    
}

- (void)showCenterPanel:(BOOL)animated bounce:(BOOL)shouldBounce {

    
    self.state = IRSlideMenuPanelCenterVisible;
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self hideLeftPanelAnimated:YES];
    
    self.tapView = nil;

}

- (void)hideLeftPanelAnimated:(BOOL)animated{

    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.6 options:0 animations:^{
        self.leftMenuViewController.view.frame = CGRectMake(-self.view.frame.size.width*leftMenuWidthPercent,
                                                            0,
                                                            self.leftMenuViewController.view.frame.size.width,
                                                            self.leftMenuViewController.view.frame.size.height);
        self.opacityView.layer.opacity = 0.0;
    } completion:^(BOOL finished) {
        
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

#pragma mark - public method action

- (void)showLeftPanelAnimated:(BOOL)animated {
    
    NSLog(@"showLeftPanelAnimated");
    [self _showLeftPanel:animated bounce:NO];
    
}



#pragma mark - Showing Panels

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
    self.opacityView.layer.opacity = openedLeftRatio*0.5;
    NSLog(@"%f",openedLeftRatio);
}

- (void)_showLeftPanel:(BOOL)animated bounce:(BOOL)shouldBounce {
    
    self.state = IRSlideMenuPanelLeftVisible;

    
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.2 options:0 animations:^{
        
//        self.leftMenuViewController.view.transform = CGAffineTransformMakeTranslation(-leftMenuWidth, 0);
        self.leftMenuViewController.view.frame = CGRectMake(0,
                                                            0,
                                                            self.leftMenuViewController.view.frame.size.width,
                                                            self.leftMenuViewController.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeft];
    }];
    
//    [self _loadLeftPanel];
//    [self _adjustCenterFrame];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == self.leftPanGesture) {
        
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        NSLog(@"point %@", NSStringFromCGPoint(point));
        
        if (point.x <= X_MAX_LEFT_START) {
            return YES;
        }else{
            return NO;
        }
        
        
    }else if (gestureRecognizer == self.swipeRight){
        return NO;
    }
    
    return NO;
    
}


@end

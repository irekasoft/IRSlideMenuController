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
        
        
        [self initView];
        
    }
    
    
    return self;
}

- (void)initView {
    
    [self.view insertSubview:self.mainViewController.view atIndex:0];
    
    leftMenuWidth = self.view.frame.size.width * 0.3;
    
    self.leftMenuViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view insertSubview:self.leftMenuViewController.view atIndex:1];
    
    self.leftMenuViewController.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
    
    
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
        self.leftMenuViewController.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
        self.opacityView.layer.opacity = 0.0;
    } completion:^(BOOL finished) {
        
        [self.opacityView removeFromSuperview];
        
        for (UIGestureRecognizer *recognizer in self.mainViewController.view.gestureRecognizers) {
            [self.mainViewController.view removeGestureRecognizer:recognizer];
        }
        
    }];
    
}

#pragma mark - public method action

- (void)showLeftPanelAnimated:(BOOL)animated {
    
    NSLog(@"hii");
    [self _showLeftPanel:animated bounce:NO];
    
}



#pragma mark - Showing Panels

- (void)_showLeftPanel:(BOOL)animated bounce:(BOOL)shouldBounce {
    
    self.state = IRSlideMenuPanelLeftVisible;
    
    self.opacityView = [[UIView alloc] initWithFrame:self.mainViewController.view.frame];
    self.opacityView.backgroundColor = [UIColor blackColor];
    
    [self.view insertSubview:self.opacityView atIndex:1];
    self.opacityView.layer.opacity = 0.5;
    
    [self addTapGestureToView:self.opacityView];
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.2 options:0 animations:^{
        
        self.leftMenuViewController.view.transform = CGAffineTransformMakeTranslation(-leftMenuWidth, 0);
        
    } completion:^(BOOL finished) {
        
    }];
    
//    [self _loadLeftPanel];
//    [self _adjustCenterFrame];
    
    
    

    
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

@end

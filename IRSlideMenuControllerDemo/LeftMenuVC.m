//
//  LeftMenuVC.m
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 14/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "LeftMenuVC.h"
#import "IRSlideMenuController.h"
#import "UIViewController+IRSlideMenuController.h"

@interface LeftMenuVC ()

@property (strong) UIViewController *mainViewController;
@property (strong) UIViewController *vc2;
@property (strong) UIViewController *vc3;
@property (strong) UIViewController *settingsVC;



@end

@implementation LeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainViewController = self.slideMenuController.mainViewController;
    self.vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"VC2"];
    self.vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"VC3"];
    
    self.settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    
    [self.slideMenuController changeMainViewController:self.mainViewController close:YES];
}

- (IBAction)menu2:(id)sender {
    

    [self.slideMenuController changeMainViewController:self.vc2 close:YES];
    
    
}

- (IBAction)menu3:(id)sender {

    
    [self.slideMenuController changeMainViewController:self.vc3 close:YES];
    
}

- (IBAction)settings:(id)sender {
    
    self.settingsVC.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:self.settingsVC animated:YES completion:nil];
    
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

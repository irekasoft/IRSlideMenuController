//
//  MyVC.m
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 14/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "MyVC.h"
#import "IRSlideMenuController.h"
#import "UIViewController+IRSlideMenuController.h"

@interface MyVC ()

@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menu:(id)sender {
    [self.slideMenuController showLeftPanelAnimated:YES];
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

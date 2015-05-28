//
//  ViewController.m
//  IRSlideMenuControllerDemo
//
//  Created by Hijazi on 13/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "ViewController.h"
#import "IRSlideMenuController.h"
#import "UIViewController+IRSlideMenuController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.slideMenuController.isSideBySide == NO){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(menu:)];
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    [self.slideMenuController showLeftPanelAnimated:YES];
    
}

@end

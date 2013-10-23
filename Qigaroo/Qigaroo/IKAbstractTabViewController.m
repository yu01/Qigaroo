//
//  IKAbstractTabViewController.m
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKAbstractTabViewController.h"
#import "IKHomeViewController.h"
#import "IKConnectionViewController.h"
#import "IKMyViewController.h"

@interface IKAbstractTabViewController ()

@end

@implementation IKAbstractTabViewController {
    dispatch_once_t onceToken;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    dispatch_once(&onceToken, ^{
        //NSLog(@"一度だけ呼ばれると思ってたけど画面遷移すると必ず一度呼ばれるらしい");
        connectionManager = [[IKConnectionManager alloc] init];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabHome
{
    IKHomeViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IKHomeViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)tabTagroo
{
    IKConnectionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IKTagrooViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}

- (void)tabMy
{
    IKMyViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IKMyViewController"];
    [self presentViewController:viewController animated:NO completion:nil];
}




@end

//
//  IKProfEditTextViewController.m
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/25.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKProfEditTextViewController.h"
#import "WUTextSuggestionController.h"
#import "WUTextSuggestionDisplayController.h"

@interface IKProfEditTextViewController ()<WUTextSuggestionDisplayControllerDataSource>

@end

@implementation IKProfEditTextViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

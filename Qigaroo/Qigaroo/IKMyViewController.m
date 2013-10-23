//
//  IKMyViewController.m
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKMyViewController.h"
#import "IKHomeViewController.h"
#import "IKConnectionViewController.h"

@interface IKMyViewController ()

@end

@implementation IKMyViewController

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
    
    // OFFの画像設定
    [_TagrooBtnImage setImage:[UIImage imageNamed:@"connect_off.png"] forState:UIControlStateNormal];
    // OFFでボタンをタップ中の画像設定
    [_TagrooBtnImage setImage:[UIImage imageNamed:@"connect_on@2x.png"] forState:UIControlStateHighlighted];
    // ONの画像設定
    [_TagrooBtnImage setImage:[UIImage imageNamed:@"connect_off.png"] forState:UIControlStateNormal | UIControlStateSelected];
    // ONでボタンをタップ中の画像設定
    [_TagrooBtnImage setImage:[UIImage imageNamed:@"connect_off.png"] forState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HomeBtn:(id)sender {
    [self tabHome];
}

- (IBAction)TagrooBtn:(id)sender {
    [self tabTagroo];
}

- (IBAction)MyBtn:(id)sender {
}
- (void)viewDidUnload {
    [self setTagrooBtnImage:nil];
    [super viewDidUnload];
}
@end

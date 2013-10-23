//
//  IKConnectionViewController.m
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKAppDelegate.h"
#import "IKConnectionViewController.h"
#import "IKHomeViewController.h"
#import "IKMyViewController.h"
//#import "IKTagrooActionViewController.h"

@interface IKConnectionViewController ()
    
@end

@implementation IKConnectionViewController

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
    connectionManager = [IKConnectionManager sharedManager];
    connectionManager.delegate = self;
    if (connectionManager.isConnecting){
        [connectionManager disconnect];
    } else {
        [connectionManager connect];
    }
    
    
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


#pragma touch

//// 画面に指を一本以上タッチしたときに実行されるメソッド
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches count : %d (touchesBegan:withEvent:)", [touches count]);
//    CGPoint p = [[touches anyObject] locationInView:self.view];
//    biginPoint = CGPointMake(p.x, p.y);
//}
//
//// 画面に触れている指が一本以上移動したときに実行されるメソッド
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches count : %d (touchesMoved:withEvent:)", [touches count]);
//    // 1.anyObjectメソッドでいずれか1つのタッチを取得
//    // 2.locationViewメソッドで対象となるビューのタッチした座標を取得
//    CGPoint p = [[touches anyObject] locationInView:self.view];
//    int x = p.x;    // X座標
//    int y = p.y;    // Y座標
//    NSLog(@"(%d,%d)",x,y);
//    if (biginPoint.y > y) {
//        
//    }
//    [UIView animateWithDuration:0.5f
//                          delay:0.5f
//                        options:UIViewAnimationCurveEaseInOut
//                     animations:^{
//                         // アニメーションをする処理
//                     } completion:^(BOOL finished) {
//                         // アニメーションが終わった後実行する処理
//                     }];
//
//    //self.view.transform = CGAffineTransformMakeTranslation(0 , biginPoint.y-y);
//    
//}
//
//// 指を一本以上画面から離したときに実行されるメソッド
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches count : %d (touchesEnded:withEvent:)", [touches count]);
//}
//
//// システムイベントがタッチイベントをキャンセルしたときに実行されるメソッド
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touches count : %d (touchesCancelled:withEvent:)", [touches count]);
//}



#pragma Bluetooth

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)connectionManager:(ConnectionManager *)manager
           didReceiveData:(NSData *)data
                 fromPeer:(NSString *)peer
{
    // 他のピアから受信したデータをデコード
//    NSString *sendToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"sendToken:%@",sendToken);
//    
//    if([@"sendToken" isEqualToString:sendToken]) {
//        [UIView animateWithDuration:0.3f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             // アニメーションをする処理
//                             self.tabbarView.transform = CGAffineTransformMakeTranslation(0 , 83);
//                             self.TagrooBtnImage.transform = CGAffineTransformMakeTranslation(0 , 83);
//                         } completion:^(BOOL finished) {
//                             // アニメーションが終わった後実行する処理
//                             IKTagrooActionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IKTagrooActionViewController"];
//                             [self presentModalViewController:viewController animated:NO];
//                             self.tabbarView.transform = CGAffineTransformMakeTranslation(0 , 0);
//                             self.TagrooBtnImage.transform = CGAffineTransformMakeTranslation(0 , 0);
//                         }];
//    }
    
}

- (void)connectionManagerDidConnect:(ConnectionManager *)manager
{
    //connectButton.title = @"切断";
}

- (void)connectionManagerDidDisconnect:(ConnectionManager *)manager
{
    //connectButton.title = @"接続";
}


- (IBAction)HomeBtn:(id)sender {
    [self tabHome];
}

- (IBAction)TagrooBtn:(id)sender {
    if (connectionManager.isConnecting){
        [connectionManager disconnect];
    } else {
        [connectionManager connect];
    }
}

- (IBAction)MyBtn:(id)sender {
    [self tabMy];
}
- (void)viewDidUnload {
    [self setTagrooBtnImage:nil];
    [self setTabbarView:nil];
    [self setTabbarView:nil];
    [self setTabbarView:nil];
    [super viewDidUnload];
}
@end

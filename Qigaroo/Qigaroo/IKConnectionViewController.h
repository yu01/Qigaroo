//
//  IKConnectionViewController.h
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKAbstractTabViewController.h"
#import "IKConnectionManager.h"

@interface IKConnectionViewController : IKAbstractTabViewController <ConnectionManagerDelegate>{
    CGPoint biginPoint;
}

//Tabbar
- (IBAction)HomeBtn:(id)sender;
- (IBAction)TagrooBtn:(id)sender;
- (IBAction)MyBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *TagrooBtnImage;
@property (weak, nonatomic) IBOutlet UIView *tabbarView;


@end

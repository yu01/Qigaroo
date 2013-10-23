//
//  IKMyViewController.h
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKAbstractTabViewController.h"

@interface IKMyViewController : IKAbstractTabViewController

//Tabbar
- (IBAction)HomeBtn:(id)sender;
- (IBAction)TagrooBtn:(id)sender;
- (IBAction)MyBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *TagrooBtnImage;
@end

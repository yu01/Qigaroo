//
//  IKInputTextViewController.h
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKInputTextViewCell.h"

@interface IKInputTextViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>{
    NSMutableArray *cellCount, *suggestArr;
    NSMutableString *inputStr;
}
- (IBAction)pushAddBtn:(id)sender;
- (IBAction)pushCancelBtn:(id)sender;

@end

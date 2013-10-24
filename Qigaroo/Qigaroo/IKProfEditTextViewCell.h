//
//  IKProfEditTextViewCell.h
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/25.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKInputTextViewCell.h"

@interface IKProfEditTextViewCell : IKInputTextViewCell

@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@end

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"profEditCell";
    IKInputTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.inputTextField.delegate = self;
    cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    [cell.inputTextField addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.inputTextField.hidden = NO;
    cell.inputTextView.hidden = NO;
    cell.addBtn.hidden = YES;
    
    cell.inputTextView.delegate = self;
    
    if (indexPath.row >= [self->cellCount count]) {
        cell.inputTextField.hidden = YES;
        cell.inputTextView.hidden = YES;
        cell.addBtn.hidden = NO;
    }
    if (indexPath.section == 0) {
        cell.addBtn.hidden = YES;
        cell.inputTextField.hidden = NO;
        cell.inputTextView.hidden = NO;
    }
    
    WUTextSuggestionDisplayController *suggestionDisplayController = [[WUTextSuggestionDisplayController alloc] init];
    suggestionDisplayController.dataSource = self;
    
    WUTextSuggestionController *suggestionController = [[WUTextSuggestionController alloc] initWithTextView:cell.inputTextView suggestionDisplayController:suggestionDisplayController];
    
    suggestionController.suggestionType = WUTextSuggestionTypeAt | WUTextSuggestionTypeHashTag;
    
    
    return cell;
}

@end

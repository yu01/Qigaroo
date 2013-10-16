//
//  IKInputTextViewController.m
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKInputTextViewController.h"
#import "IKServerAdaptor.h"

@interface IKInputTextViewController ()

@end

@implementation IKInputTextViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    
    self->cellCount = [[NSMutableArray alloc] initWithObjects:@"1", @"2",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self->cellCount count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InputCell";
    IKInputTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.inputTextField.delegate = self;
    cell.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    [cell.inputTextField addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.inputTextField.hidden = NO;
    cell.addBtn.hidden = YES;
    
    if (indexPath.row >= [self->cellCount count]) {
        cell.inputTextField.hidden = YES;
        cell.addBtn.hidden = NO;
    }
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)pushAddBtn:(id)sender {
    [self->cellCount addObject:[NSString stringWithFormat:@"%d",[self->cellCount count]]];
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    // TODO: Viewを上にずらす
    int y = [[textField superview] superview].frame.origin.y;
    NSLog(@"y:%d",y);
    NSLog(@"self.view:%@",self.tableView);
//    if (y > 150) {
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             int height = 80;
//                             self.tableView.frame = CGRectMake(0, -height, self.tableView.frame.size.width, self.tableView.frame.size.height);
//                         }];
//    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    
    // TODO: Viewがずれているなら戻す
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.tableView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
                     }];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self->inputStr = [textField.text mutableCopy];
    [self->inputStr replaceCharactersInRange:range withString:string];
    NSLog(@"入力：%@",self->inputStr);
    [[IKServerAdaptor sharedManager] getCategories:self->inputStr success:^(NSArray *words){
        NSLog(@"候補: %@",words);
    }];
    
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField*)textField{
    [self->inputStr setString:@""];
    return YES;
}
@end

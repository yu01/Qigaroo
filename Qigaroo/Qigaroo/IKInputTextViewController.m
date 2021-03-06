//
//  IKInputTextViewController.m
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKInputTextViewController.h"
#import "IKServerAdaptor.h"
#import "WUTextSuggestionController.h"
#import "WUTextSuggestionDisplayController.h"
#import "IKRegisterCheckViewController.h"

@interface IKInputTextViewController ()<WUTextSuggestionDisplayControllerDataSource>
@property NSUserDefaults *defaults;
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
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    if ([self.defaults objectForKey:@""]) {
        
    }else{
        self->cellAnswer = [[NSMutableArray alloc] initWithObjects:@"0",nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 4 : [self->cellAnswer count]+1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"基本情報" : @"オプション";
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return section == 0 ? 30 : 65;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IKInputTextViewCell *cell;
    
    if ((indexPath.row >= [self->cellAnswer count]) && indexPath.section != 0) {
        NSString *CellIdentifier = @"addCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else{
        NSString *CellIdentifier = @"InputCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.inputTextView.delegate = self;
        if ( indexPath.section == 0) {
            cell.inputTextView.tag = indexPath.row;
        }else{
            cell.inputTextView.tag = 100 + indexPath.row;   // 基本情報が100を越えることはないので+100で識別する
        }
        
        
        WUTextSuggestionDisplayController *suggestionDisplayController = [[WUTextSuggestionDisplayController alloc] init];
        suggestionDisplayController.dataSource = self;
        
        WUTextSuggestionController *suggestionController = [[WUTextSuggestionController alloc] initWithTextView:cell.inputTextView suggestionDisplayController:suggestionDisplayController];
        
        suggestionController.suggestionType = WUTextSuggestionTypeAt | WUTextSuggestionTypeHashTag;
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
    [self->cellAnswer addObject:[NSString stringWithFormat:@"%d",[self->cellAnswer count]]];
    [self.tableView reloadData];
}

- (IBAction)pushCancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LOG(@"segue identfier: %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"pushToRegister"]) {
        IKRegisterCheckViewController *rc = (IKRegisterCheckViewController *)[segue destinationViewController];
        [self transferData];
        rc.cellAnswer = self->cellAnswer;
    }
}

- (void)transferData{
    IKInputTextViewCell *cell;
    NSString *CellIdentifier = @"InputCell";
    for (int i=0; i>[self->cellAnswer count]; i++) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        [self->cellAnswer replaceObjectAtIndex:i withObject:cell.inputTextView.text];
        LOG(@"inputTextView:%@",cell.inputTextView.text);
    }
    
}

#pragma mark - textView
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    LOG(@"-----------:%@",textView.text);
    LOG_PRINTF(@"Tag:%d",textView.tag);
    if (textView.tag >= 100) {
        [self->cellAnswer replaceObjectAtIndex:textView.tag - 100 withObject:textView.text];
    }
    [textView resignFirstResponder];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    self->inputStr = [textView.text mutableCopy];
    [self->inputStr replaceCharactersInRange:range withString:text];
    LOG_PRINTF(@"入力：%@",self->inputStr);
    [[IKServerAdaptor sharedManager] getCategories:self->inputStr success:^(NSArray *words){
        LOG_PRINTF(@"候補: %@",words);
        self->suggestArr = [[NSMutableArray alloc] initWithArray:words];
    }];
    
    return YES;
}


#pragma mark - WUTextSuggestionDisplayControllerDataSource
- (NSArray *)textSuggestionDisplayController:(WUTextSuggestionDisplayController *)textSuggestionDisplayController suggestionDisplayItemsForSuggestionType:(WUTextSuggestionType)suggestionType query:(NSString *)suggestionQuery
{
    if (suggestionType == WUTextSuggestionTypeAt) {
        NSMutableArray *suggestionDisplayItems = [NSMutableArray array];
        for (NSString *name in [self filteredNamesUsingQuery:suggestionQuery]) {
            WUTextSuggestionDisplayItem *item = [[WUTextSuggestionDisplayItem alloc] initWithTitle:name];
            [suggestionDisplayItems addObject:item];
        }
        return [suggestionDisplayItems copy];
    }
    return nil;
}

#pragma mark - names

- (NSArray *)filteredNamesUsingQuery:(NSString *)query {
    NSArray *filteredNames = [self.names filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[evaluatedObject lowercaseString] hasPrefix:[query lowercaseString]]) {
            return YES;
        } else {
            return NO;
        }
    }]];
    return filteredNames;
}

- (NSArray *)names {
    LOG(@"SuggestArray: %@",self->suggestArr);
    return self->suggestArr;
    
//    return @[@"あああ",@"あやや",@"Abigail",@"Ada",@"Adela",@"Adelaide",@"Afra",@"Agatha",@"Agnes",@"Alberta",@"Alexia",@"Alice",@"Alma",@"Althea",@"Alva",@"Amanda",@"Amelia",@"Amy",@"Anastasia",@"Andrea",@"Angela",@"Ann",@"Anna",@"Annabelle",@"Antonia",@"April",@"Arabela",@"Arlene",@"Astrid",@"Atalanta",@"Athena",@"Audrey",@"Aurora",@"Barbara",@"Beatrice",@"Belinda",@"Bella",@"Belle",@"Bernice",@"Bertha",@"Beryl",@"Bess",@"Betsy",@"Betty",@"Beulah",@"Beverly",@"Blanche",@"Bblythe",@"Bonnie",@"Breenda",@"Bridget",@"Brook",@"Camille",@"Candance",@"Candice",@"Cara",@"Carol",@"Caroline",@"Catherine",@"Cathy",@"Cecilia",@"Celeste",@"Charlotte",@"Cherry",@"Cheryl",@"Chloe",@"Christine",@"Claire",@"Clara",@"Clementine",@"Constance",@"Cora",@"Coral",@"Cornelia",@"Crystal",@"Cynthia",@"Daisy",@"Dale",@"Dana",@"Daphne",@"Darlene",@"Dawn",@"Debby",@"Deborah",@"Deirdre",@"Delia",@"Denise",@"Diana",@"Dinah",@"Dolores",@"Dominic",@"Donna",@"Dora",@"Doreen",@"Doris",@"Dorothy",@"Eartha",@"Eden",@"Edith",@"Edwina",@"Eileen",@"Elaine",@"Eleanore",@"Elizabeth",@"Ella",@"Ellen",@"Elma",@"Elsa",@"Elsie",@"Elva",@"Elvira",@"Emily",@"Emma",@"Enid",@"Erica",@"Erin",@"Esther",@"Ethel",@"Eudora",@"Eunice",@"Evangeline",@"Eve",@"Evelyn",@"Faithe",@"Fanny",@"Fay",@"Flora",@"Florence",@"Frances",@"Freda",@"Frederica",@"Gabrielle",@"Gail",@"Gemma",@"Genevieve",@"Georgia",@"Geraldine",@"Gill",@"Giselle",@"Gladys",@"Gloria",@"Grace",@"Griselda",@"Gustave",@"Gwendolyn",@"Hannah",@"Harriet",@"Hazel",@"Heather",@"Hedda",@"Hedy",@"Helen",@"Heloise",@"Hermosa",@"Hilda",@"Hilary",@"Honey",@"Hulda",@"Ida",@"Ina",@"Ingrid",@"Irene",@"Iris",@"Irma",@"Isabel",@"Ivy",@"Jacqueline",@"Jamie",@"Jane",@"Janet",@"Janice",@"Jean",@"Jennifer",@"Jenny",@"Jessie",@"Jessica",@"Jill",@"Jo",@"Joa",@"Joanna",@"Joanne",@"Jocelyn",@"Jodie",@"Josephine",@"Joy",@"Joyce",@"Judith",@"Judy",@"Julia",@"Julie",@"Juliet",@"June",@"Kama",@"Karen",@"Katherine",@"Kay",@"Kelly",@"Kimberley",@"Kitty",@"Kristin",@"Laura",@"Laurel",@"Lauren",@"Lee",@"Leila",@"Lena",@"Leona",@"Lesley",@"Letitia",@"Lilith",@"Lillian",@"Linda",@"Lindsay",@"Lisa",@"Liz",@"Lorraine",@"Louise",@"Lucy",@"Lydia",@"Lynn",@"Mabel",@"Madeline",@"Madge",@"Maggie",@"Mamie",@"Mandy",@"Marcia",@"Margaret",@"Marguerite",@"Maria",@"Marian",@"Marina",@"Marjorie",@"Martha",@"Martina",@"Mary",@"Maud",@"Maureen",@"Mavis",@"Maxine",@"Mag",@"May",@"Megan",@"Melissa",@"Meroy",@"Meredith",@"Merry",@"Michelle",@"Michaelia",@"Mignon",@"Mildred",@"Mirabelle",@"Miranda",@"Miriam",@"Modesty",@"Moira",@"Molly",@"Mona",@"Monica",@"Muriel",@"Murray",@"Myra",@"Myrna",@"Nancy",@"Naomi",@"Natalie",@"Natividad",@"Nelly",@"Nicola",@"Nicole",@"Nina",@"Nora",@"Norma",@"Novia",@"Nydia",@"Octavia",@"Odelette",@"Odelia",@"Olga",@"Olive",@"Olivia",@"Ophelia",@"Pag",@"Page",@"Pamela",@"Pandora",@"Patricia",@"Paula",@"Pearl",@"Penelope",@"Penny",@"Philipppa",@"Phoebe",@"Phoenix",@"Phyllis",@"Polly",@"Poppy",@"Prima",@"Priscilla",@"Prudence",@"Queena",@"Quintina",@"Rachel",@"Rae",@"Rebecca",@"Regina",@"Renata",@"Renee",@"Rita",@"Riva",@"Roberta",@"Rosalind",@"Rose",@"Rosemary",@"Roxanne",@"Ruby",@"Ruth",@"Sabina",@"Sally",@"Sabrina",@"Salome",@"Samantha",@"Sandra",@"Sandy",@"Sara",@"Sarah",@"Sebastiane",@"Selena",@"Sharon",@"Sheila",@"Sherry",@"Shirley",@"Sibyl",@"Sigrid",@"Simona",@"Sophia",@"Spring",@"Stacey",@"Setlla",@"Stephanie",@"Susan",@"Susanna",@"Susie",@"Suzanne",@"Sylvia",@"Tabitha",@"Tammy",@"Teresa",@"Tess",@"Thera",@"Theresa",@"Tiffany",@"Tina",@"Tobey",@"Tracy",@"Trista",@"Truda",@"Ula",@"Una",@"Ursula",@"Valentina",@"Valerie",@"Vanessa",@"Venus",@"Vera",@"Verna",@"Veromca",@"Veronica",@"Victoria",@"Vicky",@"Viola",@"Violet",@"Virginia",@"Vita",@"Vivien",@"Wallis",@"Wanda",@"Wendy",@"Winifred",@"Winni",@"Xanthe",@"Xaviera",@"Xenia",@"Yedda",@"Yetta",@"Yvette",@"Yvonne",@"Zara",@"Zenobia",@"Zoe",@"Zona",@"Zora"];
    
}

@end

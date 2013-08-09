//
//  MainViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.

#import "MainViewController.h"
#import "SmartTableViewController.h"
#import "RecordViewController.h"
@interface MainViewController ()
{
    IBOutlet UIButton *MoveRecButton;
    IBOutlet UIButton *MoveListButtton;
    //    IBOutlet UIActionSheet *actionSheet;
    IBOutlet UIButton *Acbutton;
}
@end

@implementation MainViewController

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
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveRec:(id)sender {

    RecordViewController *Recview = [RecordViewController new];
    [self.navigationController pushViewController:Recview animated:YES];

}
- (IBAction)moveList:(id)sender {
        //    VMFDTableViewController *vmfdTaview = [VMFDTableViewController new];
    SmartTableViewController *Taview = [SmartTableViewController new];
    [self.navigationController pushViewController:Taview animated:YES];
}
- (IBAction)choiceBGM:(id)sender {
    //-(void)BtnPush:Acbutton{
    NSLog(@"Pushed");
    //ActionSheet Setting
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    //deligate set
    sheet.delegate = self;
    //sheet detail
    sheet.title = @"Choice BGM!!";
    [sheet addButtonWithTitle:@"Nothing"];
    [sheet addButtonWithTitle:@"Classic"];
    [sheet addButtonWithTitle:@"Dance"];
    [sheet addButtonWithTitle:@"Rock"];
    [sheet addButtonWithTitle:@"DnB"];
    //Button0=Red
    sheet.destructiveButtonIndex = 0;
    //Button3=Cancel
    //sheet.cancelButtonIndex = 5;
    //Sheet's style
    //sheet.actionSheetStyle = UIActionSheetStyleDefault;
    //Sheet view!!
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            NSLog(@"1");
            self.view.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            NSLog(@"2");
            self.view.backgroundColor = [UIColor redColor];
            break;
        case 3:
            NSLog(@"3");
            self.view.backgroundColor = [UIColor blueColor];
            break;
        case 4:
            NSLog(@"4");
            self.view.backgroundColor = [UIColor yellowColor];
            break;
    }
}



@end

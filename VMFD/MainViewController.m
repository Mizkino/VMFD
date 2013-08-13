//
//  MainViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.

#import "MainViewController.h"
#import "SmartTableViewController.h"
#import "RecordViewController.h"
#import "ListViewController.h"

@interface MainViewController ()
{
    IBOutlet UIButton *MoveRecButton;
    IBOutlet UIButton *MoveListButtton;
    //    IBOutlet UIActionSheet *actionSheet;
    IBOutlet UIButton *Acbutton;
    int kari;
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
    self.title = @"main";
    
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon.png"]];

    //kari=3;
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveRec:(id)sender {

    RecordViewController *Recview = [RecordViewController new];
    Recview.bgmNum = kari * -1;
    [self.navigationController pushViewController:Recview animated:YES];

}
- (IBAction)moveList:(id)sender {
//    
//    SmartTableViewController *Taview = [SmartTableViewController new];
    ListViewController *Taview = [ListViewController new];
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
    [sheet addButtonWithTitle:@"Techno"];
    [sheet addButtonWithTitle:@"HipHop"];
    [sheet addButtonWithTitle:@"DnB"];
    [sheet addButtonWithTitle:@"Jazz"];
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
            kari=1;
            break;
        case 2:
            NSLog(@"2");
            self.view.backgroundColor = [UIColor redColor];
            kari=2;
            break;
        case 3:
            NSLog(@"3");
            self.view.backgroundColor = [UIColor blueColor];
            kari=3;
            break;
        case 4:
            NSLog(@"4");
            self.view.backgroundColor = [UIColor yellowColor];
            kari=4;
            break;
    }
}



@end

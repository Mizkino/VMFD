//
//  MainViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.

#import "MainViewController.h"
//#import "SmartTableViewController.h"
#import "RecordViewController.h"
#import "ListViewController.h"
#import "DataManager.h"

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
    [self.tabBarController setSelectedIndex:1];
}
- (IBAction)moveList:(id)sender {

    [self.tabBarController setSelectedIndex:2];
}
- (IBAction)choiceBGM:(id)sender {
    //-(void)BtnPush:Acbutton{
    NSLog(@"Pushed");
    //ActionSheet Setting
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    //deligate set
    sheet.delegate = self;
    //sheet detail
    sheet.title = @"Choose BGM!!";
    [sheet addButtonWithTitle:@"Nothing"];
    [sheet addButtonWithTitle:@"Techno"];
    [sheet addButtonWithTitle:@"HipHop"];
    [sheet addButtonWithTitle:@"DnB"];
    [sheet addButtonWithTitle:@"Jazz"];
    sheet.destructiveButtonIndex = 0;

    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"nothing");
            [DataManager sharedManager].unko=0;
            break;
        case 1:
            NSLog(@"1");
            [DataManager sharedManager].unko=-1;
            break;
        case 2:
            NSLog(@"2");
            [DataManager sharedManager].unko=-2;
            break;
        case 3:
            NSLog(@"3");
            [DataManager sharedManager].unko=-3;
            break;
        case 4:
            NSLog(@"4");
            [DataManager sharedManager].unko=-4;
            break;
    }
}
@end

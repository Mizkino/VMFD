//
//  ListViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//
#import "ListViewController.h"
#import "SmartCell.h"
#import "AppDelegate.h"
#import "RecordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataManager.h"
#import "DataClass.h"

#define kCellIdentifier @"CellIdentifier"


@interface ListViewController ()
{
    IBOutlet UITableView *tableMenu;
    IBOutlet UITableView *jambo;
    IBOutlet UIView *renameView;
    IBOutlet UITextField *renameText;
    IBOutlet UIButton *acceptButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *toHomeButton;
    IBOutlet UIImageView *outsideImage;
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tapG1;
    UITapGestureRecognizer *tapG2;
    NSString *toPath;
    NSString *fromPath;
    NSIndexPath *touchIndex;
    NSIndexPath *playIndex;
    NSInteger MenuNum;
    
    BOOL renameButton;
}

@end

@implementation ListViewController {
@private
    //    NSArray *dataSource_;
}
@synthesize player;

//@synthesize dataSource = dataSource_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//
//- (id)initWithStyle:(UITableViewStyle)style {
//    self = [super initWithStyle:style];
//    if (!self){
//        return nil;
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.view addSubview:jambo];
    NSLog(@"view didload");
    //WaytoWrite otameshi
    tableMenu.delegate = self;
    tableMenu.dataSource = self;
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector (panAction:)];
    tapG1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction :)];
    tapG2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction :)];
    [jambo registerNib:[UINib nibWithNibName:@"SmartCell" bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Update Navigation
    [self updateNavigationItemAnimated:animated];
    // deselect cell
    [jambo deselectRowAtIndexPath:[jambo indexPathForSelectedRow] animated:YES];
    //  update visible cells
    //[self updateVisibleCells];
    [jambo reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//--------------------------------------------------------------//
#pragma mark -- ViewOutlets Update --
//--------------------------------------------------------------//

- (void)updateNavigationItemAnimated:(BOOL)animated {
}
#pragma mark - Cell Operation
- (void)updateVisibleCells {
    // cell visual update
    for (UITableViewCell *cell in [jambo visibleCells]){
        [self updateCell:cell atIndexPath:[jambo indexPathForCell:cell]];
    }
    NSLog(@"update");
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //NSUInteger section = (NSUInteger) [indexPath section];
    NSUInteger row = (NSUInteger) [indexPath row];
    // Update Cells
    SmartCell *customCell = (SmartCell *) cell;
    //    [customCell toggle];
    //customCell.countLabel.text = [NSString stringWithFormat:@"%@", _musicList[row]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    DataClass *data = [DataManager sharedManager].dataList[row];
    //customCell.backgroundColor = [UIColor colorWithRed:0.118 green:0.118 blue:0.110 alpha:1];
    customCell.countLabel.text = data.fileName;
    customCell.dateLabel.text = [formatter stringFromDate:data.makeDate];
    //int minutes = floor(data.dataTime / 60);
    //int second = round(data.dataTime - minutes * 60);
    int minutes = (int)(data.dataTime/(44100*60));
    int second = (int)((data.dataTime/44100) - minutes * 60);
    int decSec = (int)((data.dataTime/441) - minutes * 6000 - second * 100);
    NSString *Time = [[NSString alloc]initWithFormat:@"%02d:%02d:%02d", minutes, second, decSec];
    customCell.songTime.text = Time;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
//テーブルビューのセクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//テーブルビューのrowの数
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (!tableView.tag==0) {
        return 4;
    }else{
        return [[DataManager sharedManager].dataList count];}
}
//テーブルビューに表示されるセルの設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = kCellIdentifier;
    SmartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[SmartCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(tableView.tag ==0){
        //set event
        [cell.RB addTarget:self action:@selector(handleTouchButton:event:) forControlEvents:UIControlEventTouchUpInside];
        [cell.LB addTarget:self action:@selector(handleTouchButton2:event:) forControlEvents:UIControlEventTouchUpInside];
        
        // Configure the cell...
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self updateCell:cell atIndexPath:indexPath];;
    }else{
        NSArray *MenuTexts = @[@"Rename",@"OverRec",@"Delete",@"Cancel"];
        NSString *MenuText = MenuTexts[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = MenuText;
        cell.textLabel.font = [UIFont systemFontOfSize:25];
        cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1.0 alpha:1];
    }
    return cell;
}
// Set IndexPath at TouchPoint from UIControlEvent
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:jambo];
    NSIndexPath *indexPath = [jambo indexPathForRowAtPoint:p];
    return indexPath;
}
//テーブルビュー押したら発動
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag ==1){
        MenuNum=indexPath.row;
        [self Menu];
        [tableMenu removeFromSuperview];
    }
}
//Left Button Function!!
- (void)handleTouchButton2:(UIButton *)sender event:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    DataClass *data = [DataManager sharedManager].dataList[indexPath.row];
    NSLog(@"%@", [data.filePath lastPathComponent]);
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSArray *cells = [jambo visibleCells];
    for (SmartCell *cell in cells) {
        [cell setStop];
    }
    SmartCell *customCell = (SmartCell *)[jambo cellForRowAtIndexPath:indexPath];
    [customCell toggle];
    if ( playIndex.row==indexPath.row && self.player.playing)
    {
        [self.player pause];
        [customCell setStop];
    }
    else
    {//SetFile -> ErrorKakunin
        NSLog(@"%@",data.filePath);
        NSURL *url = [NSURL fileURLWithPath:data.filePath];
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
        {
            NSLog(@"unko");
            NSError *error = nil;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            if ( error != nil )
            {
                NSLog(@"Error %@", [error localizedDescription]);
            }
            playIndex = indexPath;
            [self.player prepareToPlay];
            [self.player setDelegate:self];
            [self.player play];
        }
        //[RB setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

//Right Button Function!!
- (void)handleTouchButton:(UIButton *)sender event:(UIEvent *)event {
    touchIndex = [self indexPathForControlEvent:event];
    DataClass *data = [DataManager sharedManager].dataList[touchIndex.row];
    //NSLog(@"%@", _musicList[touchIndex.row]);
    NSLog(@"%@", [data.filePath lastPathComponent]);
    tableMenu.center = CGPointMake(jambo.center.x, tableMenu.center.y);
    CGRect rect = tableMenu.frame;
    tableMenu.alpha = 0.7;
    //rect.origin.y = jambo.frame.size.height - rect.size.height;
    rect.origin.y = rect.size.height;
    tableMenu.frame = rect;
    
    [self.view addSubview:tableMenu];
    [tableMenu addGestureRecognizer:pan];
    [jambo addGestureRecognizer:tapG1];
    [outsideImage addGestureRecognizer:tapG2];
    tableMenu.layer.shadowOpacity = 0.9; // 濃さを指定
    tableMenu.layer.shadowOffset = CGSizeMake(5.0, 5.0); // 影までの距離を指定
    tableMenu.layer.masksToBounds = NO;

    //    [self UpTableMenu:tableMenu];
    //[self FunctionMenu];
}


//右側のボタン押したら出るメニュー
-(void)Menu{
    if (MenuNum==0) {//Rename!!!!!!
        NSLog(@"NameChange");
        //        renameText.text = _musicList[touchIndex.row];
        DataClass *data = [DataManager sharedManager].dataList[touchIndex.row];
        renameText.text = [data.fileName lastPathComponent];
        renameView.center = self.view.center;
        [self.view addSubview:renameView];
        renameView.layer.shadowOpacity = 0.9; // 濃さを指定
        renameView.layer.shadowOffset = CGSizeMake(5.0, 5.0); // 影までの距離を指定
        renameView.layer.masksToBounds = NO;
        [renameText setDelegate:self];
        [renameView addGestureRecognizer:pan];
    }else if (MenuNum==1){//OverRec!!!!!!!!
        NSLog(@"OverRec");
        [DataManager sharedManager].unko = touchIndex.row + 1;
        [self.tabBarController setSelectedIndex:1];
    }else if (MenuNum==2){//Delete!!!
        NSLog(@"Delete");
        DataClass *Data = [DataManager sharedManager].dataList[touchIndex.row];
        [[DataManager sharedManager] removeData:Data];
        [jambo deleteRowsAtIndexPaths:@[touchIndex] withRowAnimation:UITableViewRowAnimationTop];
    }else{
        return;
    }
}
//リネームビューのドラッグアクション
- (void)panAction : (UIPanGestureRecognizer *)sender {
    CGPoint p = [sender translationInView:self.view];
    CGPoint movedPoint = CGPointMake(sender.view.center.x + p.x, sender.view.center.y + p.y);
    sender.view.center = movedPoint;
    [sender setTranslation:CGPointZero inView:self.view];
}
- (void)tapAction : (UITapGestureRecognizer *)sender {
    [tableMenu removeFromSuperview];
    [jambo removeGestureRecognizer:tapG1];
    [outsideImage removeGestureRecognizer:tapG2];
}

//text入力でリターン押したら
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [renameText resignFirstResponder];
    [self PushAccept:nil];
    return YES;
}

- (IBAction)PushAccept:(id)sender {
    [renameView removeFromSuperview];
    NSString *NewName = renameText.text;
    DataClass *data = [DataManager sharedManager].dataList[touchIndex.row];
    //    if([NewName isEqualToString:_musicList[touchIndex.row]])    return;
    if([NewName isEqualToString:[data.fileName lastPathComponent]])    return;
    [[DataManager sharedManager] Rename:data :NewName ];
    [[DataManager sharedManager] save];
    [jambo reloadData];
}
- (IBAction)PushCancel:(id)sender {
    [renameView removeFromSuperview];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if ( flag )    {
        NSLog(@"Done");
        NSArray *cells = [jambo visibleCells];
        for (SmartCell *cell in cells) {
            [cell setStop];
        }
        // Can start next audio?
    }
}
- (IBAction)toGoHome:(id)sender {
    NSLog(@"HOME!");
    [self.tabBarController setSelectedIndex:0];
}
@end

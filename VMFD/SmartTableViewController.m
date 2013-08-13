//
//  SmartTableViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "SmartTableViewController.h"
#import "SmartCell.h"
#import "AppDelegate.h"
#import "RecordViewController.h"
#define kCellIdentifier @"CellIdentifier"

#import "DataManager.h"
#import "DataClass.h"

@interface SmartTableViewController ()
{
    IBOutlet UITableView *tableMenu;
    IBOutlet UITableView *jambo;
    IBOutlet UIView *renameView;
    IBOutlet UITextField *renameText;
    IBOutlet UIButton *acceptButton;
    IBOutlet UIButton *cancelButton;
    NSString *musPath;
    NSString *toPath;
    NSString *fromPath;
    NSIndexPath *touchIndex;
    NSIndexPath *playIndex;
    NSInteger MenuNum;
    CGRect defaultTableViewFrame;

    BOOL renameButton;
}

@end

@implementation SmartTableViewController {
@private
    //    NSArray *dataSource_;
}
@synthesize player;

//@synthesize dataSource = dataSource_;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (!self){
        return nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //WaytoWrite otameshi
    tableMenu.delegate = self;
    tableMenu.dataSource = self;
    renameView.center = self.view.center;
    NSFileManager *fileManager;
    fileManager = [[NSFileManager alloc]init];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    musPath = [docPath stringByAppendingPathComponent:@"Music"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SmartCell" bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Update Navigation
    [self updateNavigationItemAnimated:animated];
    // deselect cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    //  update visible cells
    [self updateVisibleCells];
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
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //NSUInteger section = (NSUInteger) [indexPath section];
    NSUInteger row = (NSUInteger) [indexPath row];
    // Update Cells
    SmartCell *customCell = (SmartCell *) cell;
    //    [customCell toggle];
    //customCell.countLabel.text = [NSString stringWithFormat:@"%@", _musicList[row]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY/MM/dd HH:mm:ss"];
    DataClass *data = [DataManager sharedManager].dataList[row];
    customCell.countLabel.text = data.fileName;
    customCell.dateLabel.text = [formatter stringFromDate:data.makeDate];
    //int minutes = floor(data.dataTime / 60);
    //int second = round(data.dataTime - minutes * 60);
    int minutes = (int)(data.dataTime/(44100*60));
    int second = (int)((data.dataTime/44100) - minutes * 60);
    NSString *Time = [[NSString alloc]initWithFormat:@"%02d:%02d",minutes,second ];
    customCell.songTime.text = Time;
}

//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (!tableView.tag==0) {
        return 4;
    }else{
        return [[DataManager sharedManager].dataList count];}
}

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
        [self updateCell:cell atIndexPath:indexPath];
    }else{
        NSArray *MenuTexts = @[@"Rename",@"OverRec",@"Delete",@"Cancel"];
        NSString *MenuText = MenuTexts[indexPath.row];
        cell.textLabel.text = MenuText;
        cell.textLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1.0 alpha:1];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag ==1){
        MenuNum=indexPath.row;
        [self Menu];
        [tableMenu removeFromSuperview];
    }
}
-(void)Menu{
    if (MenuNum==0) {
        NSLog(@"NameChange");
//        renameText.text = _musicList[touchIndex.row];
        DataClass *data = [DataManager sharedManager].dataList[touchIndex.row];
        renameText.text = [data.fileName lastPathComponent];
        [self.view addSubview:renameView];
        [renameText setDelegate:self];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction :)];
        [renameView addGestureRecognizer:pan];
    }else if (MenuNum==1){
        NSLog(@"OverRec");
        RecordViewController *recCon = [RecordViewController new];
        recCon.bgmNum = touchIndex.row + 1;
        [self presentViewController:recCon animated:YES completion:nil];
    }else if (MenuNum==2){
        NSLog(@"Delete");
        DataClass *Data = [DataManager sharedManager].dataList[touchIndex.row];
        [[DataManager sharedManager] removeData:Data];
        [self.tableView deleteRowsAtIndexPaths:@[touchIndex] withRowAnimation:UITableViewRowAnimationTop];
    }else{
        return;
    }
}
- (void)panAction : (UIPanGestureRecognizer *)sender {
    CGPoint p = [sender translationInView:self.view];
    CGPoint movedPoint = CGPointMake(renameView.center.x + p.x, renameView.center.y + p.y);
    renameView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:self.view];
}
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
    [self.tableView reloadData];
}
- (IBAction)PushCancel:(id)sender {
    [renameView removeFromSuperview];
}

//Left Button Function!!
- (void)handleTouchButton2:(UIButton *)sender event:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    DataClass *data = [DataManager sharedManager].dataList[indexPath.row];
    NSLog(@"%@", [data.filePath lastPathComponent]);
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSArray *cells = [self.tableView visibleCells];
    for (SmartCell *cell in cells) {
        [cell setStop];
    }
    SmartCell *customCell = (SmartCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if ( flag )    {
        NSLog(@"Done");
        NSArray *cells = [self.tableView visibleCells];
        for (SmartCell *cell in cells) {
            [cell setStop];
        }
        // Can start next audio?
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
    //rect.origin.y = jambo.frame.size.height - rect.size.height;
    rect.origin.y = rect.size.height;
    tableMenu.frame = rect;
    [self.view addSubview:tableMenu];
//    [self UpTableMenu:tableMenu];
    //[self FunctionMenu];
}

// Set IndexPath at TouchPoint from UIControlEvent
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    return indexPath;
}
@end

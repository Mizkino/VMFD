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

@interface SmartTableViewController ()
{
    IBOutlet UITableView *tableMenu;
    IBOutlet UITableView *jambo;
    IBOutlet UIView *renameView;
    IBOutlet UITextField *renameText;
    IBOutlet UIButton *acceptButton;
    IBOutlet UIButton *cancelButton;
    NSString *musPath;
    NSIndexPath *touchIndex;
    NSInteger MenuNum;
    CGRect defaultTableViewFrame;
    NSString *toPath;
    NSString *fromPath;
    BOOL renameButton;
}

@property (nonatomic, strong) NSMutableArray *musicList;

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
    [self.player prepareToPlay];
    [self.player setDelegate:self];
    renameView.center = self.view.center;
    NSFileManager *fileManager;
    fileManager = [[NSFileManager alloc]init];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    musPath = [docPath stringByAppendingPathComponent:@"Music"];
    
    NSError *error = nil;
    _musicList = [NSMutableArray array];
    NSArray *arraya = [NSArray array];
    arraya = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:musPath error:&error];
    _musicList = [arraya mutableCopy];
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
    customCell.countLabel.text = [NSString stringWithFormat:@"%@", _musicList[row]];
    
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
        return [_musicList count];}
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
        renameText.text = _musicList[touchIndex.row];
        [self.view addSubview:renameView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction :)];
        [renameView addGestureRecognizer:pan];
    }else if (MenuNum==1){
        NSLog(@"OverRec");
        RecordViewController *recCon = [RecordViewController new];
        recCon.bgmNum = touchIndex.row;
        [self presentViewController:recCon animated:YES completion:nil];
    }else if (MenuNum==2){
        NSLog(@"Delete");
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *filePath = [musPath stringByAppendingPathComponent:_musicList[touchIndex.row]];
        [fileManager removeItemAtPath:filePath error:NULL];
        NSError *error = nil;
        _musicList = [NSMutableArray array];
        NSArray *arraya = [NSArray array];
        arraya = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:musPath error:&error];
        _musicList = [arraya mutableCopy];
        //        [self.tableView reloadData];
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
- (IBAction)PushAccept:(id)sender {
    NSString *NewName = renameText.text;
    if([NewName isEqualToString:_musicList[touchIndex.row]])
    {    [renameView removeFromSuperview];
        return;}
    [self Rename1:NewName];

}
- (IBAction)PushCancel:(id)sender {
    [renameView removeFromSuperview];
}

- (void)Rename1:(NSString *)NewName {
    [renameView removeFromSuperview];
    NSFileManager * fm = [[NSFileManager alloc] init];
    fromPath = [musPath stringByAppendingPathComponent:_musicList[touchIndex.row]];
    toPath = [musPath stringByAppendingPathComponent:NewName];
    if([fm fileExistsAtPath:toPath]){
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Same name file Exist!"
                                   message:@"Over write??"
                                  delegate:self cancelButtonTitle:@"OK◎" otherButtonTitles:@"NO!!", nil];
        [alert show];
        }else{
            [self Rename2];
        }
}
- (void)Rename2{
    NSLog(@"Rename2");
    NSError *err =nil;
    NSFileManager *fm = [[NSFileManager alloc] init];
    BOOL result = [fm moveItemAtPath:fromPath toPath:toPath error:&err];
    if(!result)NSLog(@"moveError: %@", err.description);
    _musicList = [NSMutableArray array];
    NSArray *arraya = [NSArray array];
    arraya = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:musPath error:&err];
        //NSLog(@"seiriError: %@", err.description);
    _musicList = [arraya mutableCopy];
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
            NSFileManager *fm = [[NSFileManager alloc]init];
        NSError *err;
            [fm removeItemAtPath:toPath error:&err];
            //NSLog(@"error:%@",err.description);
            [self Rename2];
    }
}

//Left Button Function!!
- (void)handleTouchButton2:(UIButton *)sender event:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    NSLog(@"%@", _musicList[indexPath.row]);
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSArray *cells = [self.tableView visibleCells];
    for (SmartCell *cell in cells) {
        [cell setStop];
    }
    SmartCell *customCell = (SmartCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [customCell toggle];
    if ( self.player.playing )
    {
        [self.player pause];
    }
    else
    {//SetFile -> errorkakunin
        NSError *error = nil;
        NSString *filePath = [musPath stringByAppendingPathComponent:_musicList[indexPath.row]];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
        {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            
            if ( error != nil )
            {
                NSLog(@"Error %@", [error localizedDescription]);
            }
            //            self.player.delegate = self;
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
    NSLog(@"%@", _musicList[touchIndex.row]);
    tableMenu.center = CGPointMake(jambo.center.x, tableMenu.center.y);
    CGRect rect = tableMenu.frame;
    rect.origin.y = jambo.frame.size.height - rect.size.height;
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

//
//-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==0) {
//        NSLog(@"NameChange");
//        NSString *NewName;
//        
//        nameField.text = _musicList[touchIndex.row];
//        [self.view addSubview:nameField];
//        NewName = nameField.text;
//        [nameField removeFromSuperview];
//        
//        if([NewName isEqualToString:_musicList[touchIndex.row]])
//            return;
//        NSError * err = nil;
//        NSFileManager * fm = [[NSFileManager alloc] init];
//        
//        NSString *fromPath = [musPath stringByAppendingPathComponent:_musicList[touchIndex.row]];
//        NSString *toPath = [musPath stringByAppendingPathComponent:NewName];
//        check = YES;
//        if([fm fileExistsAtPath:toPath]){
//            UIAlertView *alert =
//            [[UIAlertView alloc] initWithTitle:@"Same name file Exist!"
//                                       message:@"Over write??"
//                                      delegate:self cancelButtonTitle:@"OK◎" otherButtonTitles:@"NO!!", nil];
//            [alert show];
//        }
//        if (!check){
//            check = YES;
//            return;
//        }
//        BOOL result = [fm moveItemAtPath:fromPath toPath:toPath error:&err];
//        if(!result)
//            NSLog(@"Error: %@", err);
//        
//    }else if (buttonIndex==1){
//        NSLog(@"OverRec");
//        RecordViewController *recCon = [RecordViewController new];
//        recCon.bgmNum = touchIndex.row;
//        [self presentViewController:recCon animated:YES completion:nil];
//    }else if (buttonIndex==2){
//        NSLog(@"Delete");
//        NSFileManager *fileManager = [[NSFileManager alloc] init];
//        NSString *filePath = [musPath stringByAppendingPathComponent:_musicList[touchIndex.row]];
//        
//        [fileManager removeItemAtPath:filePath error:NULL];
//        NSError *error = nil;
//        _musicList = [NSMutableArray array];
//        NSArray *arraya = [NSArray array];
//        arraya = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:musPath error:&error];
//        _musicList = [arraya mutableCopy];
//        //        [self.tableView reloadData];
//        [self.tableView deleteRowsAtIndexPaths:@[touchIndex] withRowAnimation:UITableViewRowAnimationTop];
//    }
//    
//}


//右側のボタンを有効にするかしないかを決定する。ここでは入力があれば有効にしているが、例えばより複雑に、入力できない無い文字や、文字数制限を設けることも出来そう。
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
//{
//    NSString *inputText = [[alertView textFieldAtIndex:0] text];
//    if( [inputText length] >= 1 )
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//通常のdelegateですが、textFieldAtIndexを使ってテキストを取得する
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex==1) {
//        trip_title = [[alertView textFieldAtIndex:0] text];
//        [trip_title retain];
//        [self tripArea];
//    }
//}


//--------------------------------------------------------------//
#pragma mark -- UITableViewDelegate --
//--------------------------------------------------------------//

//- (void)tableView:(UITableView *)tableView
//        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [UIView animateWithDuration:1.0 animations:^{
//        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//        appDelegate.window.rootViewController = [[EmbedTableViewController alloc] init];
//    }];
//    // ハイライトを外す
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//- (void)dealloc {
//    dataSource_, dataSource_ = nil;
//}
@end

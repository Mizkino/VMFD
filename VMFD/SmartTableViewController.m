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
#define kCellIdentifier @"CellIdentifier"

@interface SmartTableViewController ()

@property (nonatomic, strong) NSMutableArray *musicList;

@end

@implementation SmartTableViewController {
@private
    //    NSArray *dataSource_;
    NSArray *array;
}

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
    
    // 配列の初期化
    _musicList = [NSMutableArray array];
    for (int i=0; i<1000; i++) {
        [_musicList addObject:[NSString stringWithFormat:@"%d", i]];
    }
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    NSString *musPath = [docPath stringByAppendingPathComponent:@"Music"];
    NSError *error = nil;
    array = [[NSFileManager defaultManager]                       contentsOfDirectoryAtPath:musPath error:&error];
    for (int i=0; i<5; i++) {
        NSLog(@"%@",[array objectAtIndex:i]);
    };
    
    // DataSource init
    // iOS5からは最初に一度だけnibファイルを登録すればいい
    
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
    // セルの表示更新
    for (UITableViewCell *cell in [self.tableView visibleCells]){
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    //NSUInteger section = (NSUInteger) [indexPath section];
    NSUInteger row = (NSUInteger) [indexPath row];
    // Update Cells
    SmartCell *customCell = (SmartCell *) cell;
    //customCell.countLabel.text = [NSString stringWithFormat:@"%d-%d", section, row];
    customCell.countLabel.text = [NSString stringWithFormat:@"%@", array[row]];
    
}
//--------------------------------------------------------------//
#pragma mark -- UITableViewDataSource --
//--------------------------------------------------------------//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //return [_musicList count];
    return [array count];
}
- (IBAction)PushRB:(id)sender{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = kCellIdentifier;
    SmartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[SmartCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // イベントを付ける
    [cell.RB addTarget:self action:@selector(handleTouchButton:event:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)handleTouchButton:(UIButton *)sender event:(UIEvent *)event {
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    
    
    NSLog(@"%@", _musicList[indexPath.row]);
//    NSLog(@"%@", array[indexPath.row]);
    
    //    NSString *messageString = [NSString stringWithFormat:@"Button at section %d row %d was tapped.", indexPath.section, indexPath.row];
    //    UIAlertView *alert = [[UIAlertView alloc]
    //                                       initWithTitle:@"Button tapped!" message:messageString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
}

// UIControlEventからタッチ位置のindexPathを取得する
- (NSIndexPath *)indexPathForControlEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint p = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    return indexPath;
}
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

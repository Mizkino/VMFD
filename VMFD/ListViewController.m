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
    IBOutlet UIView *Prosessing;
    CMTime durationF;
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tapG1;
    UITapGestureRecognizer *tapG2;
    NSMutableArray *audioMixParams;
    NSIndexPath *touchIndex;
    NSIndexPath *playIndex;
    //NSInteger MenuNum;
    
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
    [self.view addSubview:Prosessing];
    Prosessing.center = self.view.center;
    UIActivityIndicatorView *Quruli = [UIActivityIndicatorView new];
    Quruli.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [Quruli.layer setValue:[NSNumber numberWithFloat:1.39f] forKeyPath:@"transform.scale"];
    Quruli.center = Prosessing.center;
    [Prosessing addSubview:Quruli];
    [Quruli startAnimating];
    Prosessing.alpha = 0;
    //[self.view addSubview:jambo];
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"ViewUpdate");
    // Update Navigation
    [self updateNavigationItemAnimated:animated];
    // deselect cell
    [jambo deselectRowAtIndexPath:[jambo indexPathForSelectedRow] animated:YES];
    //  update visible cells
    //[self updateVisibleCells];
    [jambo reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (SmartCell *cell in [jambo visibleCells]) {
        [cell setStop];
    }
    if ( self.player.playing)
    {
        [self.player pause];
    }
    [tableMenu removeFromSuperview];
    [renameView removeFromSuperview];
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music"];
    NSError *err;
    if ([[NSFileManager defaultManager] fileExistsAtPath:mergeCache]) {
        NSLog(@"Cache発見削除する！");
        [[NSFileManager defaultManager] removeItemAtPath:mergeCache error:&err];
        if ( err != nil ) NSLog(@"DataDeleteError:%@",[err localizedDescription]);
    }
    
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
    NSUInteger row = (NSUInteger)([[DataManager sharedManager].dataList count] - [indexPath row] - 1);
    //NSUInteger rows = [[DataManager sharedManager].dataList count];
    //NSUInteger antiRow = rows - row -1;
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
    NSArray *bgTagName= @[@"NO BGM",@"Techno",@"HipHop",@"Drum'n Bass",@"Jazz"];
//    NSString *Bgmtagss = [NSString stringWithFormat:@"BGM : %@",bgTagName[data.BGMnumber]];
    customCell.bgmTag.text = bgTagName[data.BGMnumber];
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
        return 3;
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
        NSArray *MenuTexts = @[@"Rename",@"OverRec",@"Delete"];
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
//        MenuNum=indexPath.row;
        [self Menu:indexPath.row];
        [tableMenu removeFromSuperview];
    }
}

//Left Button Function!!
- (void)handleTouchButton2:(UIButton *)sender event:(UIEvent *)event {
    //Prosessing.alpha = 3.0f;
    NSIndexPath *indexPath = [self indexPathForControlEvent:event];
    NSUInteger row = (NSUInteger)([[DataManager sharedManager].dataList count] - [indexPath row] - 1);
    DataClass *data = [DataManager sharedManager].dataList[row];
    NSLog(@"%@", [data.filePath lastPathComponent]);
    //    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    for (SmartCell *cell in [jambo visibleCells]) {
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
        Prosessing.alpha = 0.3f;
        NSLog(@"Let'sPlay!!!!!%@",data.filePath);
//        NSURL *url = [NSURL fileURLWithPath:data.filePath];
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(playMusic:) userInfo:@{@"INDEXPATH":indexPath, @"DATA":data} repeats:NO];
//        if ( [[NSFileManager defaultManager] fileExistsAtPath:data.filePath] )
//        {
//            NSLog(@"FileExist");
//            playIndex = indexPath;
//            NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *cacheMusic = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music"];
//            NSError *err;
//            if (![[NSFileManager defaultManager] fileExistsAtPath:cacheMusic]) {
//                NSLog(@"CacheMusic作成！");
//                [[NSFileManager defaultManager] createDirectoryAtPath:cacheMusic withIntermediateDirectories:YES attributes:nil error:&err];
//                if ( err != nil ) NSLog(@"CreateError:%@",[err localizedDescription]);
//            }
//            NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music/%d.caf",indexPath.row];
//            //NSString *mergeCache = [merge stringByAppendingPathExtension:@"caf"];
//            NSLog(@"mergeCache:%@",mergeCache);
//            NSURL *setmusic;
//                if([[NSFileManager defaultManager] fileExistsAtPath:mergeCache])
//                {
//                    NSLog(@"CacheExist");
//                    setmusic = [NSURL fileURLWithPath:mergeCache];
//                }else{
//                    NSLog(@"Let's Merge");
//                    setmusic = [self audioMerge:data];
//                }
//                NSError *error = nil;
//                self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:setmusic error:&error];
//                if ( error != nil ) NSLog(@"Error %@", [error localizedDescription]);
//            [self.player prepareToPlay];
//            [self.player setDelegate:self];
//            [self.player play];
//            //Prosessing.alpha = 0;
//            NSLog(@"processingare");
//        }else{NSLog(@"File is not there");}
//        //Prosessing.alpha = 0.0f;
//
//        //[RB setTitle:@"Pause" forState:UIControlStateNormal];
    }

}
- (void)playMusic :(NSTimer *)timer{
    NSDictionary *unko = timer.userInfo;
    NSIndexPath *indexPath = unko[@"INDEXPATH"];
    DataClass *data = unko[@"DATA"];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:data.filePath] )
    {
        NSLog(@"FileExist");
        playIndex = indexPath;
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cacheMusic = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music"];
        NSError *err;
        if (![[NSFileManager defaultManager] fileExistsAtPath:cacheMusic]) {
            NSLog(@"CacheMusic作成！");
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheMusic withIntermediateDirectories:YES attributes:nil error:&err];
            if ( err != nil ) NSLog(@"CreateError:%@",[err localizedDescription]);
        }
        NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music/%d.caf",indexPath.row];
        //NSString *mergeCache = [merge stringByAppendingPathExtension:@"caf"];
        NSLog(@"mergeCache:%@",mergeCache);
        NSURL *setmusic;
        if([[NSFileManager defaultManager] fileExistsAtPath:mergeCache])
        {
            NSLog(@"CacheExist");
            setmusic = [NSURL fileURLWithPath:mergeCache];
        }else{
            NSLog(@"Let's Merge");
            setmusic = [self audioMerge:data];
        }
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:setmusic error:&error];
        if ( error != nil ) NSLog(@"Error %@", [error localizedDescription]);
        [self.player prepareToPlay];
        [self.player setDelegate:self];
        [self.player play];
        Prosessing.alpha = 0;
        NSLog(@"processingare");
    }else{NSLog(@"File is not there");}
}

//Right Button Function!!
- (void)handleTouchButton:(UIButton *)sender event:(UIEvent *)event {
    [tableMenu removeFromSuperview];
    [renameView removeFromSuperview];
    
    touchIndex = [self indexPathForControlEvent:event];
    NSUInteger row = (NSUInteger)([[DataManager sharedManager].dataList count] - [touchIndex row] - 1);
    DataClass *data = [DataManager sharedManager].dataList[row];
    //NSLog(@"%@", _musicList[touchIndex.row]);
    NSLog(@"%@", [data.filePath lastPathComponent]);
    tableMenu.center = CGPointMake(jambo.center.x+jambo.center.x/2, self.view.center.y+self.view.center.y/2);
    //CGRect rect = tableMenu.frame;
    tableMenu.alpha = 0.7;
    //rect.origin.y = jambo.frame.size.height - rect.size.height;
    //rect.origin.y = rect.size.height;
    //tableMenu.frame = rect;
    
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
-(void)Menu:(NSInteger) MenuNum{
    NSUInteger row = (NSUInteger)([[DataManager sharedManager].dataList count] - [touchIndex row] - 1);
    if (MenuNum==0) {//Rename!!!!!!
        NSLog(@"NameChange");
        //        renameText.text = _musicList[touchIndex.row];
        DataClass *data = [DataManager sharedManager].dataList[row];
        renameText.text = [data.fileName lastPathComponent];
        renameView.center = self.view.center;
        [self.view addSubview:renameView];
        renameView.layer.shadowOpacity = 0.9; // 濃さを指定
        renameView.layer.shadowOffset = CGSizeMake(5.0, 5.0); // 影までの距離を指定
        renameView.layer.masksToBounds = NO;
        [jambo addGestureRecognizer:tapG1];
        [outsideImage addGestureRecognizer:tapG2];
        [renameText setDelegate:self];
        [renameView addGestureRecognizer:pan];
    }else if (MenuNum==1){//OverRec!!!!!!!!
        NSLog(@"OverRec");
        [DataManager sharedManager].unko = row + 1;
        [self.tabBarController setSelectedIndex:1];
    }else if (MenuNum==2){//Delete!!!
        NSLog(@"Delete");
        DataClass *Data = [DataManager sharedManager].dataList[row];
        [[DataManager sharedManager] removeData2:Data];
        [[DataManager sharedManager] save];
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music"];
        NSError *err;
        if ([[NSFileManager defaultManager] fileExistsAtPath:mergeCache]) {
            NSLog(@"Cache発見削除する！");
            [[NSFileManager defaultManager] removeItemAtPath:mergeCache error:&err];
            if ( err != nil ) NSLog(@"DataDeleteError:%@",[err localizedDescription]);
        }
        [jambo deleteRowsAtIndexPaths:@[touchIndex] withRowAnimation:UITableViewRowAnimationTop];
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
    [renameView removeFromSuperview];
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
    NSUInteger row = (NSUInteger)([[DataManager sharedManager].dataList count] - [touchIndex row] - 1);
    DataClass *data = [DataManager sharedManager].dataList[row];
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
- (void) setUpAndAddAudioAtPath:(NSURL*)assetURLs toComposition:(AVMutableComposition *)composition :(BOOL)which
{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURLs options:nil];
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    NSError *error = nil;
    BOOL ok = NO;
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
    CMTime trackDuration = songAsset.duration;
    //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
    CMTimeRange tRange;
    if(which){
       tRange = CMTimeRangeMake(startTime, trackDuration);
        if(durationF.value < trackDuration.value){durationF=trackDuration;}
    }else{
        tRange = CMTimeRangeMake(startTime, durationF);
    }
    if (!which) {
        NSLog(@"BGM入れてる！");
    }
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:0.9f atTime:startTime];
    [audioMixParams addObject:trackMix];
    //Insert audio into track
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
    if ( error != nil ) NSLog(@"Error %@", [error localizedDescription]);
    if(ok)NSLog(@"入った！");
}
-(NSURL *) audioMerge:(DataClass *)data{
    AVMutableComposition *composition = [AVMutableComposition composition];
    audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
    //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
    //Add Audio Tracks to Composition
    for (NSString *path in data.filePaths) {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        [self setUpAndAddAudioAtPath:pathURL   toComposition:composition :1];
    }
    if(data.BGMnumber){
        NSLog(@"BGM入れるよ！");
        NSString *asset = [[NSString alloc]initWithFormat:@"BGM%d",-data.BGMnumber];
        NSString *URLPath = [[NSBundle mainBundle] pathForResource:asset ofType:@"m4a"];
        NSURL *URL = [NSURL fileURLWithPath:URLPath];
        [self setUpAndAddAudioAtPath:URL   toComposition:composition :0];
    }
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    //If you need to query what formats you can export to, here's a way to find out
    NSLog (@"compatible presets for songAsset: %@",
           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName: AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType = @"com.apple.m4a-audio";
    //exporter.outputFileType = @"com.microsoft.waveform-audio";
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingFormat:@"/Music/%d.caf",playIndex.row];
    //NSString *mergeCache = [merge stringByAppendingPathExtension:@"caf"];
    NSURL *mergeCacheURL = [NSURL fileURLWithPath:mergeCache];
    exporter.outputURL = mergeCacheURL;
    // do the export
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        NSError *exportError = exporter.error;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted");
                dispatch_semaphore_signal(semaphore);
                break;
            case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
            case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
            case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
            case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
            default:  NSLog (@"didn't get export status"); break;
        }
        if ( exportError != nil )
        {
            NSLog(@"exportError %@", [exportError localizedDescription]);
        }
    }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //Prosessing.alpha = 0.0f;
    return mergeCacheURL;
}
@end

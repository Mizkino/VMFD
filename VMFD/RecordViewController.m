//
//  RecordViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/06.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "RecordViewController.h"
#import "DataClass.h"
#import "DataManager.h"

@interface RecordViewController ()
{
    IBOutlet UIButton *recordButton;
    IBOutlet UIImageView *REC;
    IBOutlet UIImageView *Stop;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *recTimeLabel;
    IBOutlet UILabel *setBGMLabel;
    IBOutlet UILabel *BGMnameLabel;
    NSString *musPath;
    NSDate *stdate;
    NSURL *recordURL;
    NSURL *assetURL;
    NSMutableArray *audioMixParams;
    NSTimer *timer;
    CMTime song1;
    CMTimeValue durationF;
    NSTimeInterval TIME;
}
@end

@implementation RecordViewController

@synthesize session;
@synthesize recorder;
@synthesize player;
@synthesize bgmNum;
BOOL timeflg = NO;

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
    [timeLabel setFont:[UIFont fontWithName:@"DS-Digital" size:35]];
    [recTimeLabel setFont:[UIFont fontWithName:@"DS-Digital" size:35]];
    [setBGMLabel setFont:[UIFont fontWithName:@"DS-Digital" size:35]];
    [BGMnameLabel setFont:[UIFont fontWithName:@"DS-Digital" size:32]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction :)];
    [Stop addGestureRecognizer:tap];
    REC.alpha = 0;
    Stop.alpha = 0;
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    musPath = [docPath stringByAppendingPathComponent:@"Music"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:musPath]) {
        [fileManager createDirectoryAtPath:musPath  withIntermediateDirectories:YES  attributes:nil  error:nil];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:(0.01) target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    timeLabel.text = @"00:00:00";
    bgmNum = [DataManager sharedManager].unko;
    NSLog(@"%d",bgmNum);
    if(bgmNum)
    {
        if (bgmNum < 0) {
            //int unko = bgmNum * (-1);
            if (bgmNum==-1) {BGMnameLabel.text = @"Techno";
            }else if(bgmNum==-2){BGMnameLabel.text = @"HipHop";
            }else if(bgmNum==-3){BGMnameLabel.text = @"Drum'N Bass";
            }else if(bgmNum==-4){BGMnameLabel.text = @"Jazz";}
            NSString *asset = [[NSString alloc]initWithFormat:@"BGM%d",bgmNum];
            NSString *URLPath = [[NSBundle mainBundle] pathForResource:asset ofType:@"aif"];
            assetURL = [NSURL fileURLWithPath:URLPath];
        }else if(bgmNum > 0){
            DataClass *data = [DataManager sharedManager].dataList[bgmNum-1];
            assetURL = [self audioMerge:data];
            BGMnameLabel.text = data.fileName;
        }
        NSError *error;
        {self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:assetURL error:&error];
            [self.player setDelegate:self];
            if ( error != nil )
            {
                NSLog(@"Error %@", [error localizedDescription]);
            }
            [self.player prepareToPlay];}
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    timeLabel.text=nil;
    timeflg = FALSE;
    // Release any retained subviews of the main view.
    [timer invalidate];//★タイマー解放忘れずに
    if ( self.recorder != nil && self.recorder.isRecording ) [self stopRecord];
    REC.alpha = 0;
    Stop.alpha = 0;
}
- (void)setLabelstext{
    
}
- (void)onTimer:(NSTimer*)timer {
    //startボタンが押されたら常に真となり下記処理が実行される
    if(timeflg){
        NSDate *now = [NSDate date];
        float nowTime = [now timeIntervalSinceDate:stdate];
        int minutes = nowTime / 60;
        int seconds = (int)nowTime - minutes*60;
        int decsec = (nowTime - minutes*60.0 - seconds)*100.0;
        timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",minutes , seconds ,decsec];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpers

-(NSMutableDictionary *)setAudioRecorder
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    return settings;
}

-(void)recordFile
{
    // Prepare recording(Audio session)
    NSError *error = nil;
    self.session = [AVAudioSession sharedInstance];
    
    if ( session.inputAvailable )   // for iOS6 [session inputIsAvailable]  iOS5
    {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    }
    
    if ( error != nil )
    {
        NSLog(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    [session setActive:YES error:&error];
    if ( error != nil )
    {
        NSLog(@"Error when enabling audio session :%@", [error localizedDescription]);
        return;
    }
    recorder = [[AVAudioRecorder alloc] initWithURL:recordURL settings:[self setAudioRecorder] error:&error];
    //recorder.meteringEnabled = YES;
    if ( error != nil )
    {
        NSLog(@"Error when preparing audio recorder :%@", [error localizedDescription]);
        return;
    }
    [recorder record];
}

-(void)stopRecord
{
    //if ( self.recorder != nil && self.recorder.isRecording )
    //{
    [recorder stop];
    if (bgmNum)[self.player stop];
    [self dataSave];
    self.recorder = nil;
    //}
}

- (IBAction)recordClick:(id)sender
{
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [self stopRecord];
    }
    else
    {
        timeflg = TRUE;
        stdate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM_dd_HH_mm_ss"];
        NSString *dateStr = [formatter stringFromDate:stdate];
        NSString *filePath = [musPath stringByAppendingPathComponent:dateStr];
        NSString *filename = [NSString stringWithFormat:@"%@.caf",filePath];
        recordURL = [NSURL fileURLWithPath:filename];
        REC.alpha = 1;
        Stop.alpha = 1;
        [self recordFile];
        if (bgmNum) [self.player play];
    }
}
- (void)tapAction:(UIPanGestureRecognizer *)sender{
    [self recordClick:nil];
}

//Combine!!

- (void) setUpAndAddAudioAtPath:(NSURL*)assetURLs toComposition:(AVMutableComposition *)composition
{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURLs options:nil];
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    NSError *error = nil;
    BOOL ok = NO;
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
    CMTime trackDuration = songAsset.duration;
    //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:0.9f atTime:startTime];
    [audioMixParams addObject:trackMix];
    //Insert audio into track
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
}

-(NSURL *) audioMerge:(DataClass *)data{
    AVMutableComposition *composition = [AVMutableComposition composition];
    audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
    //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
    //Add Audio Tracks to Composition
    for (NSString *path in data.filePaths) {
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        [self setUpAndAddAudioAtPath:pathURL   toComposition:composition];
    }
    if(data.BGMnumber){
        NSString *asset = [[NSString alloc]initWithFormat:@"BGM%d",bgmNum];
        NSString *URLPath = [[NSBundle mainBundle] pathForResource:asset ofType:@"aif"];
        NSURL *URL = [NSURL fileURLWithPath:URLPath];
        [self setUpAndAddAudioAtPath:URL   toComposition:composition];
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
    NSString *mergeCache = [[array objectAtIndex:0] stringByAppendingPathComponent:@"Merge.caf"];
    NSURL *mergeCacheURL = [NSURL fileURLWithPath:mergeCache];
    exporter.outputURL = mergeCacheURL;
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        NSError *exportError = exporter.error;
        
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                break;
            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted");
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
    return mergeCacheURL;
}
-(void)dataSave{
    DataClass *dataClass = [DataClass new];
    DataClass *bgData = [DataManager sharedManager].dataList[bgmNum-1];
    [dataClass.filePaths addObject:[recordURL absoluteString]];
    for (NSString *path in bgData.filePaths) {
        [dataClass.filePaths addObject:path];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM_dd_HH_mm_ss"];
    NSString *dateStr = [formatter stringFromDate:stdate];
    dataClass.filePath = [recordURL absoluteString];
    dataClass.fileName = dateStr;
    dataClass.makeDate = stdate;
    dataClass.dataTime = self.player.duration;
    if(bgmNum <= 0){dataClass.BGMnumber = -bgmNum;}
    else{dataClass.BGMnumber = bgData.BGMnumber; }

    [[DataManager sharedManager] addData:dataClass];
    [[DataManager sharedManager] save];
    [DataManager sharedManager].unko = 0;
    [self.tabBarController setSelectedIndex:2];
}
//- (void) setUpAndAddAudioAtPath:(NSURL*)assetURLs toComposition:(AVMutableComposition *)composition :(NSInteger )which
//{
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURLs options:nil];
//    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
//    NSError *error = nil;
//    BOOL ok = NO;
//
//    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
//    //    CMTime trackDuration = songAsset.duration;
//    //if(which || bgmNum > 0){
//    NSLog(@"nuhuhu");
//    NSLog(@"%d",bgmNum);
//    song1 = songAsset.duration;
//    //}
//    if((int)durationF < (int)song1.value ){
//        NSLog(@"入ってるよぉ！");
//        durationF = song1.value;}// @@@@
//    //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
//    //    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
//    NSLog(@"%f",(double)song1.value);
//    CMTimeRange tRange = CMTimeRangeMake(startTime, song1);
//
//    //Set Volume
//    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
//    [trackMix setVolume:0.9f atTime:startTime];
//    [audioMixParams addObject:trackMix];
//
//    //Insert audio into track
//    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
//}

//-(void)saveRecording{
//    AVMutableComposition *composition = [AVMutableComposition composition];
//    audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
//    //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
//    //Add Audio Tracks to Composition
//    [self setUpAndAddAudioAtPath:cache   toComposition:composition :1];
//    if (bgmNum) [self setUpAndAddAudioAtPath:assetURL   toComposition:composition :0];
//    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
//    audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
//
//    //If you need to query what formats you can export to, here's a way to find out
//    NSLog (@"compatible presets for songAsset: %@",
//           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
//
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
//                                      initWithAsset: composition
//                                      presetName: AVAssetExportPresetAppleM4A];
//    exporter.audioMix = audioMix;
//    exporter.outputFileType = @"com.apple.m4a-audio";
//    //exporter.outputFileType = @"com.microsoft.waveform-audio";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MM_dd_HH_mm_ss"];
//    NSDate *date = [NSDate date];
//    NSString *dateStr = [formatter stringFromDate:date];
//    NSString *filePath = [musPath stringByAppendingPathComponent:dateStr];
//    NSString *filename = [NSString stringWithFormat:@"%@.caf",filePath];
//    //NSString *filePath = [musPath stringByAppendingPathComponent:filename];
//    NSURL *url = [NSURL fileURLWithPath:filename];
//    exporter.outputURL = url;
//    // do the export
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        int exportStatus = exporter.status;
//        NSError *exportError = exporter.error;
//
//        switch (exportStatus) {
//            case AVAssetExportSessionStatusFailed:
//                break;
//            case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted");
//                break;
//            case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
//            case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
//            case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
//            case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
//            default:  NSLog (@"didn't get export status"); break;
//        }
//        if ( exportError != nil )
//        {
//            NSLog(@"exportError %@", [exportError localizedDescription]);
//        }
//    }];
//    //@@@@
//    DataClass *dataClass = [DataClass new];
//    dataClass.filePath = filename;
//    dataClass.fileName = dateStr;
//    dataClass.makeDate = date;
//    dataClass.dataTime = durationF;
//    NSLog(@"%f",(double)durationF);
//    [[DataManager sharedManager] addData:dataClass];
//    [[DataManager sharedManager] save];
//    [DataManager sharedManager].unko = 0;
//    [self.tabBarController setSelectedIndex:2];
//}


@end

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
    IBOutlet UIButton *playButton;
    NSString *musPath;
    NSURL *cache;
    NSURL *assetURL;
    NSMutableArray *audioMixParams;
    BOOL Loop;
    BOOL BGM;
    CMTime song1;
    CMTimeValue durationF;
}
@end

@implementation RecordViewController

@synthesize session;
@synthesize recorder;
@synthesize player;
@synthesize bgmNum;

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
    self.title = @"Rec";
    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon.png"]];
    // Do any additional setup after loading the view.
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cash = [[array objectAtIndex:0] stringByAppendingPathComponent:@"kuzu.wav"];
    cache = [NSURL fileURLWithPath:cash];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    musPath = [docPath stringByAppendingPathComponent:@"Music"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(bgmNum)
    {
        if (bgmNum<<0) {
            //int unko = bgmNum * (-1);
            NSString *asset = [[NSString alloc]initWithFormat:@"BGM%d",bgmNum];
            NSString *URLPath = [[NSBundle mainBundle] pathForResource:asset ofType:@"aif"];
            assetURL = [NSURL fileURLWithPath:URLPath];
        }else if(bgmNum>>0){
            DataClass *data = [DataManager sharedManager].dataList[bgmNum-1];
            assetURL = [NSURL fileURLWithPath:data.filePath];
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
    if (![fileManager fileExistsAtPath:musPath]) {
    [fileManager createDirectoryAtPath:musPath  withIntermediateDirectories:YES  attributes:nil  error:nil];
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
    recorder = [[AVAudioRecorder alloc] initWithURL:cache settings:[self setAudioRecorder] error:&error];
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
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [recorder stop];
        if (bgmNum)[self.player stop];
        [self saveRecording];
        self.recorder = nil;
    }
}

//-(void)playRecord
//{
//        [self.player play];
//    
//}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
        [self.player play];
}
- (IBAction)recordClick:(id)sender
{
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [self stopRecord];
        [recordButton setTitle:@"Rec" forState:UIControlStateNormal];
    }
    else
    {
        [self recordFile];
        if (bgmNum) [self.player play];
        [recordButton setTitle:@"stop" forState:UIControlStateNormal];
    }
}
- (IBAction)playClick:(id)sender
{
    if ( self.recorder != nil && self.recorder.isRecording )
    {
        [self stopRecord];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    //[self playRecord];
}

//Combine!!

- (void) setUpAndAddAudioAtPath:(NSURL*)assetURLs toComposition:(AVMutableComposition *)composition :(NSInteger )which
{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURLs options:nil];
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    BOOL ok = NO;
    
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
//    CMTime trackDuration = songAsset.duration;
    if(which || bgmNum>>0)song1 = songAsset.duration;
    if(durationF << song1.value ) durationF = song1.value;// @@@@
    //CMTime longestTime = CMTimeMake(848896, 44100); //(19.24 seconds)
//    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    CMTimeRange tRange = CMTimeRangeMake(startTime, song1);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:1.2f atTime:startTime];
    [audioMixParams addObject:trackMix];
    
    //Insert audio into track
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
}
//- (void) setUpAndAddAudioAtPath2:(NSURL*)assetURLs toComposition:(AVMutableComposition *)composition
//{
//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURLs options:nil];
//    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
//    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
//    NSError *error = nil;
//    CMTime startTime = CMTimeMakeWithSeconds(duration2, 44100);
//    CMTime trackDuration = songAsset.duration;
//    duration2 += trackDuration.value;
//    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
//    //Set Volume
//    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
//    [trackMix setVolume:0.8f atTime:startTime];
//    [audioMixParams addObject:trackMix];
//    //Insert audio into track
//    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:CMTimeMake(0, 44100) error:&error];
//}

//- (IBAction)saveRecording
-(void)saveRecording
{
    AVMutableComposition *composition = [AVMutableComposition composition];
    audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
    //IMPLEMENT FOLLOWING CODE WHEN WANT TO MERGE ANOTHER AUDIO FILE
    //Add Audio Tracks to Composition
    [self setUpAndAddAudioAtPath:cache   toComposition:composition :1];
    if (bgmNum) [self setUpAndAddAudioAtPath:assetURL   toComposition:composition :0];
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM_dd_HH_mm_ss"];
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *filePath = [musPath stringByAppendingPathComponent:dateStr];
    NSString *filename = [NSString stringWithFormat:@"%@.caf",filePath];
    //NSString *filePath = [musPath stringByAppendingPathComponent:filename];
    NSURL *url = [NSURL fileURLWithPath:filename];
    exporter.outputURL = url;
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
    
    //@@@@
    DataClass *dataClass = [DataClass new];
    dataClass.filePath = filename;
    dataClass.fileName = dateStr;
    dataClass.makeDate = date;
    dataClass.dataTime = durationF;
    NSLog(@"%f",(double)durationF);
    [[DataManager sharedManager] addData:dataClass];
    [[DataManager sharedManager] save];
}


@end

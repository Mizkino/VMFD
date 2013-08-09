//
//  RecordViewController.m
//  VMFD
//
//  Created by pcuser on 2013/08/06.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
{
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *playButton;
    NSString *musPath;
}
@end

@implementation RecordViewController

@synthesize session;
@synthesize recorder;
@synthesize player;


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
    // Do any additional setup after loading the view.
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [pathArray objectAtIndex:0];
    musPath = [docPath stringByAppendingPathComponent:@"Music"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL created = [fileManager createDirectoryAtPath:musPath                          withIntermediateDirectories:YES
                                           attributes:nil
                                                error:&error];
    // 作成に失敗した場合は、原因をログに出します。
    if (!created) {
        NSLog(@"failed to create directory. reason is %@ - %@", error, error.userInfo);
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
    
    // File Path
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM_dd_HH_mm_ss"];
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *filename = [NSString stringWithFormat:@"%@.caf",dateStr];
//    NSString *filePath = [dir stringByAppendingPathComponent:filename];
//    NSURL *url = [NSURL fileURLWithPath:filePath];

    
    NSString *filePath = [musPath stringByAppendingPathComponent:filename];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //    -(BOOL)fileExistsAtPath:(NSString*)path
    //    {
    //        NSFileManager* fileManager = [[NSFileManager alloc] init];
    //        /* ファイルが存在するか */
    //        if ([fileManager fileExistsAtPath:path]) {
    //            return YES;
    //        } else {
    //            return NO;
    //        }
    //    }
    
    NSLog(@"namaekaita");
    
    // recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self setAudioRecorder] error:&error];
    
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
        self.recorder = nil;
    }
}

-(void)playRecord
{
    NSError *error = nil;
    
    // File Path
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
    {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if ( error != nil )
        {
            NSLog(@"Error %@", [error localizedDescription]);
        }
        [self.player prepareToPlay];
        [self.player play];
    }
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
    [self playRecord];
}

@end

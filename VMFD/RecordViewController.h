//
//  RecordViewController.h
//  VMFD
//
//  Created by pcuser on 2013/08/06.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RecordViewController : UIViewController
<AVAudioPlayerDelegate>

@property (nonatomic)AVAudioRecorder *recorder;
@property (nonatomic)AVAudioSession *session;
@property (nonatomic)AVAudioPlayer *player;
@property (nonatomic)NSInteger bgmNum;
-(void)setBgmNum:(NSInteger)bgmNum;
//@property (weak, nonatomic) IBOutlet UIButton *recordButton;
//- (IBAction)recordClick:(id)sender;

//@property (weak, nonatomic) IBOutlet UIButton *playButton;
//- (IBAction)playClick:(id)sender;
@end

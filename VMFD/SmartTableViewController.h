//
//  SmartTableViewController.h
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SmartTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    
}

//@property(nonatomic, retain) NSArray *dataSource;

@property(nonatomic) AVAudioPlayer *player;

@end

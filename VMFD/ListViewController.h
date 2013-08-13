//
//  ListViewController.h
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    
}

//@property(nonatomic, retain) NSArray *dataSource;

@property(nonatomic) AVAudioPlayer *player;

@end

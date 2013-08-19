//
//  Created by azu on 12/10/24.
//


#import <Foundation/Foundation.h>


@interface SmartCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UILabel *countLabel;
@property(strong, nonatomic) IBOutlet UILabel *dateLabel;
@property(strong, nonatomic) IBOutlet UILabel *songTime;
@property(strong, nonatomic) IBOutlet UILabel *bgmTag;
@property(strong, nonatomic) IBOutlet UIButton *RB;
@property(strong, nonatomic) IBOutlet UIButton *LB;

- (void)setPlay;
- (void)setStop;
- (void)toggle;
@end
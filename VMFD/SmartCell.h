//
//  Created by azu on 12/10/24.
//


#import <Foundation/Foundation.h>


@interface SmartCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UILabel *countLabel;
@property(strong, nonatomic) IBOutlet UIButton *RB;
- (IBAction)PushRB:(id)sender;

@end
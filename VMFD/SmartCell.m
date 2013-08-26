//
//  Created by azu on 12/10/24.
//


#import "SmartCell.h"


@implementation SmartCell{
    BOOL isPlaying;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        self.selectionStyle= UITableViewCellSelectionStyleNone;
    isPlaying=NO;
    }
    return self;
}

// オブジェクトの配置等はここで操作する
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPlay {
    [self.LB setImage:[UIImage imageNamed:@"pause.png"] forState:normal];

// [self.LB setTitle:@"Stop" forState:UIControlStateNormal];
    isPlaying = YES;
}

- (void)setStop {
    [self.LB setImage:[UIImage imageNamed:@"playButtonInList.png"] forState:normal];
 //[self.LB setTitle:@"Play" forState:UIControlStateNormal];
    isPlaying = NO;
}

-(void)toggle{
    if (isPlaying) {
        [self setStop];
    }else{
        [self setPlay];
    }
}
@end
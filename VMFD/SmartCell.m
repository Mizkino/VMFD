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
    isPlaying=NO;
    }
    return self;
}

// オブジェクトの配置等はここで操作する
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPlay {
 [self.LB setTitle:@"Stop" forState:UIControlStateNormal];
    isPlaying = YES;
}

- (void)setStop {
 [self.LB setTitle:@"Play" forState:UIControlStateNormal];
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
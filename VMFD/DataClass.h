//
//  DataClass.h
//  VMFD
//
//  Created by pcuser on 2013/08/12.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject

@property(nonatomic) NSDate *makeDate;
@property(nonatomic) NSString *filePath;
@property(nonatomic) NSString *fileName;
@property(nonatomic) NSTimeInterval dataTime;
@property(nonatomic) NSMutableArray *filePaths;
@property(nonatomic) int BGMnumber;
@end

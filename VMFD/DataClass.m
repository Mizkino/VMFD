//
//  DataClass.m
//  VMFD
//
//  Created by pcuser on 2013/08/12.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "DataClass.h"

#define FILENAMEKEY @"fileName"
#define FILEPATHKEY @"filePath"
#define MAKEDATEKEY @"makeDate"
#define DATATIMEKEY @"dataTime"
#define FILEPATHSKY @"filepaths"
#define BGMNUMBERKY @"BGMnumber"

@implementation DataClass

- (id)init {
    self = [super init];
    if (self) {
        
        _fileName = @"";
        _filePath = @"";
        _makeDate = [NSDate date];
        _dataTime = 0;
        _filePaths = [NSMutableArray array];
        _BGMnumber = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    // インスタンス変数をデコードする
    _fileName = [decoder decodeObjectForKey:FILENAMEKEY];
    _filePath = [decoder decodeObjectForKey:FILEPATHKEY];
    _makeDate = [decoder decodeObjectForKey:MAKEDATEKEY];
    _dataTime = [decoder decodeDoubleForKey:DATATIMEKEY];
    _filePaths = [decoder decodeObjectForKey:FILEPATHSKY];
    _BGMnumber = [decoder decodeIntForKey:BGMNUMBERKY];

    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
    // インスタンス変数をエンコードする
    [encoder encodeObject:_fileName forKey:FILENAMEKEY];
    [encoder encodeObject:_filePath forKey:FILEPATHKEY];
    [encoder encodeObject:_makeDate forKey:MAKEDATEKEY];
    [encoder encodeDouble:_dataTime forKey:DATATIMEKEY];
    [encoder encodeObject:_filePaths forKey:FILEPATHSKY];
    [encoder encodeInt:_BGMnumber forKey:BGMNUMBERKY];
}

@end
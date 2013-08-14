//
//  DataManager.h
//  VMFD
//
//  Created by pcuser on 2013/08/12.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataClass;

@interface DataManager : NSObject{
    NSMutableArray *_dataList;
}

@property (nonatomic, readonly) NSArray *dataList;
@property (nonatomic, assign) NSInteger unko;
// 初期化
+ (DataManager *)sharedManager;

// PDFの操作
- (void)addData:(DataClass *)Data;
- (void)insertData:(DataClass *)Data atIndex:(unsigned int)index;
- (void)moveDataAtIndex:(unsigned int)fromIndex toIndex:(unsigned int)toIndex;
- (void)removeData:(DataClass *)Data;
- (void)removeDatabyPath:(NSString *)Path;
- (void)MovePath:(DataClass *)Data :(NSString *)toPath;
- (void)Rename:(DataClass *)Data :(NSString *)NewName;

// 永続化
- (void)load;
- (void)save;

@end
//
//  DataManager.m
//  VMFD
//
//  Created by pcuser on 2013/08/12.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "DataManager.h"
#import "DataClass.h"

@implementation DataManager
@synthesize dataList = _dataList;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

static DataManager*  _sharedInstance = nil;

+ (DataManager *)sharedManager
{
    // インスタンスを作成する
    if (!_sharedInstance) {
        _sharedInstance = [[DataManager alloc] init];
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // 配列を初期化する
    _unko = 0;
    _dataList = [NSMutableArray array];
    return self;
}

//--------------------------------------------------------------//
#pragma mark -- PDFの操作 --
//--------------------------------------------------------------//

- (void)addData:(DataClass *)data
{
    // 引数を確認する
    if (!data) {
        return;
    }
    
    // dataを追加する
    [_dataList addObject:data];
}

- (void)insertData:(DataClass *)data atIndex:(unsigned int)index
{
    // 引数を確認する
    if (!data) {
        return;
    }
    // if (index < 0 || index > [_blogs count]) {
    if (index > [_dataList count]) {
        return;
    }
    // pdfを挿入する
    [_dataList insertObject:data atIndex:index];
}

- (void)moveDataAtIndex:(unsigned int)fromIndex toIndex:(unsigned int)toIndex
{
    // 引数を確認する
    // if (fromIndex < 0 || fromIndex > [_blogs count] - 1) {
    if (fromIndex > [_dataList count] - 1) {
        return;
    }
    // if (toIndex < 0 || toIndex > [_blogs count]) {
    if (toIndex > [_dataList count]) {
        return;
    }
    // pdfを移動する
    NSString* data;
    data = [_dataList objectAtIndex:fromIndex];
    [_dataList removeObject:data];
    [_dataList insertObject:data atIndex:toIndex];
}

- (void)removeData:(DataClass *)data {
    // ファイル自体を削除する
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:data.filePath]) {
        [fileManager removeItemAtPath:data.filePath error:nil];
    }
    // 指定されたdataを削除
    [_dataList removeObject:data];
    
}
- (void)removeDatabyPath:(NSString *)Path {
    DataClass *Data;
    for (DataClass *data in _dataList) {
        if ([data.filePath isEqualToString:Path]) {
            Data = data;
            [self removeData:data];
            break;
        }
    }
}
- (void)MovePath:(DataClass *)Data :(NSString *)toPath{
    Data.filePath = toPath;
}
- (void)Rename:(DataClass *)Data :(NSString *)NewName{
    Data.fileName = NewName;
}
//--------------------------------------------------------------//
#pragma mark -- 永続化 --
//--------------------------------------------------------------//

- (NSString*)_blogDir
{
    // ドキュメントパスを取得する
    NSArray*    paths;
    NSString*   path;
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] < 1) {
        return nil;
    }
    path = [paths objectAtIndex:0];
    
    // .blogディレクトリを作成する
    path = [path stringByAppendingPathComponent:@".pdf"];
    return path;
}

- (NSString*)_blogPath
{
    // blog.datパスを作成する
    NSString*   path;
    path = [[self _blogDir] stringByAppendingPathComponent:@"pdf.dat"];
    return path;
}

- (void)load
{
    // ファイルパスを取得する
    NSString*   blogPath;
    blogPath = [self _blogPath];
    if (!blogPath || ![[NSFileManager defaultManager] fileExistsAtPath:blogPath]) {
        return;
    }
    
    // チャンネルの配列を読み込む
    NSArray*    blogs;
    blogs = [NSKeyedUnarchiver unarchiveObjectWithFile:blogPath];
    if (!blogs) {
        return;
    }
    
    // チャンネルの配列を設定する
    [_dataList setArray:blogs];
}

- (void)save
{
    // ファイルマネージャを取得する
    NSFileManager*  fileMgr;
    fileMgr = [NSFileManager defaultManager];
    
    // .blogディレクトリを作成する
    NSString*   blogDir;
    blogDir = [self _blogDir];
    if (![fileMgr fileExistsAtPath:blogDir]) {
        NSError*    error;
        [fileMgr createDirectoryAtPath:blogDir
           withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    // チャンネルの配列を保存する
    NSString*   blogPath;
    blogPath = [self _blogPath];
    [NSKeyedArchiver archiveRootObject:_dataList toFile:blogPath];
}


@end

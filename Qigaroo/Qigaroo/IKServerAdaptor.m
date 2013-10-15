//
//  IKServerAdaptor.m
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/16.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKServerAdaptor.h"

@interface IKServerAdaptor()

@property (readonly) IKHTTPClient *client;
@property (strong, nonatomic) NSString *userToken;

@end

@implementation IKServerAdaptor

+(IKServerAdaptor *)sharedManager {
    static IKServerAdaptor *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceTokenNotification:) name:@"UpdateDeviceToken" object:nil];
    }
    return self;
}

- (IKHTTPClient *)client
{
    return [IKHTTPClient sharedClient];
}

#pragma mark

- (void)getUsersNewURL:(NSString *)accessToken success:(void (^)(NSString *urlString))completionBlock
{
    void (^_completionBlock)(NSArray*) = [completionBlock copy];
    NSString *path = [NSString stringWithFormat:@"v1/api/user/new"];
    NSLog(@"get %@",path);
    [self.client getPath:path
              parameters:@{@"access_token": accessToken}
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"success");
                     _completionBlock(responseObject);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"error:%@",error);
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"FailureReport" object:nil];
                 }];
}

- (void)getUserToken:(NSString *)accessToken success:(void (^)(NSString *userToken))completionBlock
{
    void (^_completionBlock)(NSArray*) = [completionBlock copy];
    NSString *path = [NSString stringWithFormat:@"v1/api/user/token"];
    NSLog(@"get %@",path);
    [self.client getPath:path
              parameters:@{@"access_token": accessToken}
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     NSLog(@"success");
                     _completionBlock(responseObject[@"user_token"]);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"error:%@",error);
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"FailureReport" object:nil];
                 }];
}

//今使ってない
- (void)getEvents:(NSString *)insectID success:(void (^)(NSArray *detailPictures))completionBlock
{
    void (^_completionBlock)(NSArray*) = [completionBlock copy];
    NSString *path = [NSString stringWithFormat:@"v1/api/users/events.json"];
    
    [self.client getPath:path
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     _completionBlock(responseObject);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"FailureReport" object:nil];
                 }];
}

- (void)getQuestionsWithToken:(NSString *)connectionToken friendID:(NSString *)friendID success:(void (^)(NSArray *questions))completionBlock
{
    void (^_completionBlock)(NSDictionary *) = [completionBlock copy];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:@{@"user_token":@""},@{@"friend_id":friendID},@{@"connection_token":connectionToken}, nil];
    
    [self.client getPath:@"v1/api/questions"
              parameters:param
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     _completionBlock(responseObject[@"questions"]);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"FailureReport" object:nil];
                 }];
}

//オートコンプリート
- (void)getCategories:(NSString *)inputStr success:(void (^)(NSArray *words))completionBlock
{
    void (^_completionBlock)(NSArray*) = [completionBlock copy];
    NSString *path = [NSString stringWithFormat:@"v1/api/categories.json"];
    NSDictionary *dict = @{ @"category": inputStr };
    
    [self.client getPath:path
              parameters:dict
                 success:^(AFHTTPRequestOperation *operation, id responseObject){
                     _completionBlock(responseObject[@"categories"]);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"FailureReport" object:nil];
                 }];
}


@end

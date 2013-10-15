//
//  IKServerAdaptor.h
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/16.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKHTTPClient.h"

@interface IKServerAdaptor : NSObject

@property (readonly) NSString *userToken;
@property (readonly) NSString *userID;

+(IKServerAdaptor *)sharedManager;
- (void)getUsersNewURL:(NSString *)accessToken success:(void (^)(NSString *urlString))completionBlock;
- (void)getUserToken:(NSString *)accessToken success:(void (^)(NSString *userToken))completionBlock;
- (void)getEvents:(NSString *)insectID success:(void (^)(NSArray *detailPictures))completionBlock;
- (void)getQuestionsWithToken:(NSString *)connectionToken friendID:(NSString *)friendID success:(void (^)(NSArray *questions))completionBlock;
- (void)getCategories:(NSString *)inputStr success:(void (^)(NSArray *words))completionBlock;


@end

//
//  IKHTTPClient.h
//  Qigaroo
//
//  Created by 閑野 伊織 on 13/10/16.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"

static NSString * const kMTLBaseURLString = @"http://tagroo.yuutetu.org/";

@interface IKHTTPClient : AFHTTPClient

+(IKHTTPClient *) sharedClient;
- (void)setAuthorizationHeaderWithUserToken:(NSString *)token;
- (NSURL*)relativeURLWithPathComponent:(NSString*)pathComponent;

@end
@interface IKJSONNullToNilRequestOperation : AFJSONRequestOperation

@end
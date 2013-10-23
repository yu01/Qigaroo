//
//  IKConnectionManager.h
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/17.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
@class ConnectionManager;

@protocol ConnectionManagerDelegate <NSObject>

@optional
// データ受信時に呼び出される
- (void)connectionManager:(ConnectionManager *)manager
           didReceiveData:(NSData *)data
                 fromPeer:(NSString *)peer;
// P2P接続完了時に呼び出される
- (void)connectionManagerDidConnect:(ConnectionManager *)manager;
// P2P接続切断時に呼び出される
- (void)connectionManagerDidDisconnect:(ConnectionManager *)manager;

@end

//static int const send_id = 2;

@interface IKConnectionManager : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate>

@property (nonatomic, strong) id<ConnectionManagerDelegate> delegate;
@property (nonatomic) BOOL isConnecting;
//@property (nonatomic) int sendID;

+ (IKConnectionManager *)sharedManager;
- (void)connect;
- (void)disconnect;
- (void)sendDataToAllPeers:(NSData *)data;

@end

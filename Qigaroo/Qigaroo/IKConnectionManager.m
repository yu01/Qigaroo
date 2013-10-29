//
//  IKConnectionManager.m
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/17.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import "IKConnectionManager.h"

@interface IKConnectionManager () {
    GKSession *currentSession;
}

@end
@implementation IKConnectionManager

@synthesize delegate;
@synthesize isConnecting = _isConnecting;


+ (IKConnectionManager *)sharedManager{
    static IKConnectionManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        //sharedManager.sendID = send_id;  //TODO: 対処する
    });
    
    return sharedManager;
}

#pragma mark - GKPeerPickerControllerDelegate methods

- (void)peerPickerController:(GKPeerPickerController *)picker
              didConnectPeer:(NSString *)peerID
                   toSession:(GKSession *)session
{
    // セッションを保管
    currentSession = session;
    // デリゲートのセット
    session.delegate = self;
    // データ受信時のハンドラを設定
    [session setDataReceiveHandler:self withContext:nil];
    
    // ピアピッカーを閉じる
    picker.delegate = nil;
    [picker dismiss];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
}

#pragma mark - GKSession methods

- (void)session:(GKSession *)session
           peer:(NSString *)peerID
 didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateAvailable:
            LOG(@"%@", @"Peer state changed - available");
            break;
            
        case GKPeerStateConnecting:
            LOG(@"%@", @"Peer state changed - connecting");
            break;
            
        case GKPeerStateConnected:
            LOG(@"%@", @"Peer state changed - connected");
            [self sendDataToAllPeers:[[NSString stringWithFormat:@"sendToken"] dataUsingEncoding:NSUTF8StringEncoding]];
            // 接続完了を通知
            self.isConnecting = YES;
            [self.delegate connectionManagerDidConnect:self];
            break;
            
        case GKPeerStateDisconnected:
            LOG(@"%@", @"Peer state changed - disconnected");
            // 切断を通知
            currentSession = nil;
            self.isConnecting = NO;
            [self.delegate connectionManagerDidDisconnect:self];
            break;
            
        case GKPeerStateUnavailable:
            LOG(@"%@", @"Peer state changed - unavailable");
            break;
            
        default:
            break;
    }
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context
{
    // データ受信を通知
    [self.delegate connectionManager:self
                      didReceiveData:data
                            fromPeer:peer];
}

#pragma mark - Public methods

- (void)connect
{
    // ピアピッカーを作成
    GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
    //[picker setAccessibilityLabel:@"テスト"];
    picker.delegate = self;
    // 接続タイプはBluetoothのみ
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    // ピアピッカーを表示
    [picker show];
}

- (void)disconnect
{
    if (currentSession)
    {
        // P2P接続を切断する
        [currentSession disconnectFromAllPeers];
        currentSession = nil;
    }
    self.isConnecting = NO;
    // 切断を通知
    [self.delegate connectionManagerDidDisconnect:self];
}

- (void)sendDataToAllPeers:(NSData *)data
{

    LOG(@"送信するよー！%@",data);
    
    if (currentSession)
    {
        NSError *error = nil;
        // 接続中の全てのピアにデータを送信
        [currentSession sendDataToAllPeers:data
                              withDataMode:GKSendDataReliable
                                     error:&error];
        if (error)
        {
            LOG(@"%@", [error localizedDescription]);
        }
    }
}
/* 必要なかった
 - (void)receiveData:(NSData *)data fromPeer:(NSString *)peer
 inSession: (GKSession *)session{
 // 他のピアから受信したデータをデコード
 NSString *fidData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 //[NSKeyedUnarchiver unarchiveObjectWithData:data];
 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 [defaults setObject:fidData forKey:@"other_fid"];
 LOG(@"通信成功！ data:%@",fidData);
 }*/

@end

//
//  IKAbstractTabViewController.h
//  FirstContact
//
//  Created by 閑野 伊織 on 13/10/15.
//  Copyright (c) 2013年 IPLAB-Kanno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKConnectionManager.h"

@interface IKAbstractTabViewController : UIViewController <ConnectionManagerDelegate>{
    IKConnectionManager *connectionManager;
}

- (void)tabHome;
- (void)tabTagroo;
- (void)tabMy;

@end

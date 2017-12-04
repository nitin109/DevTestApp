//
//  SongsObject.h
//  DevTestApp
//
//  Created by Nitin Maheshwari on 11/25/17.
//  Copyright © 2017 NitinTestApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongsObject : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* songlink;


-(instancetype)initWithName:(NSString *)pName Songlink:(NSString *)link;

@end

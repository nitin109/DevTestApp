//
//  SongsObject.m
//  DevTestApp
//
//  Created by Nitin Maheshwari on 11/25/17.
//  Copyright © 2017 NitinTestApp. All rights reserved.
//

#import "SongsObject.h"

@implementation SongsObject

-(instancetype)initWithName:(NSString *)sName Songlink:(NSString *)link {
    self.name = sName;
    self.songlink = link;
    
    return self;
}

@end

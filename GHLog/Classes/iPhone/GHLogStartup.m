//
//  GHLogStartup.m
//  GHLogService
//
//  Created by abiaoyo on 2024/12/30.
//

#import "GHLogStartup.h"
#import "GHLog-Swift.h"

@implementation GHLogStartup

+ (void)load{
    [GHLogService.shared startup];
}

@end

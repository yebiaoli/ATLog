#import "GHLogStartup.h"
#import "GHLog-Swift.h"

@implementation GHLogStartup

+ (void)load{
    [GHLogService.shared startup];
}

@end

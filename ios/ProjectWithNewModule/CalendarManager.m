//
//  CalendarManager.m
//  ProjectWithNewModule
//
//  Created by vtrulyaev on 12/19/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "CalendarManager.h"
#import "RCTLog.h"

@implementation CalendarManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
  
  successCallback(@[@"addEvent method called"]);
}

@end

//
//  CalendarManager.m
//  ProjectWithNewModule
//
//  Created by vtrulyaev on 12/19/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarManager.h"
#import "RCTLog.h"
#import "RCTConvert.h"

#import "FrameworksProxy.h"

@implementation CalendarManager

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name
                  location:(NSString *)location
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback)
{
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
  
  successCallback(@[@"addEvent method called"]);
}


RCT_EXPORT_METHOD(processImageToGrey:(NSDictionary *)imageDataDict
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback)
{
  RCTLogInfo(@"Pretending image to grey color");
  
  NSString *imagePath = imageDataDict[@"uri"];
  UIImage *imageToProcess = [UIImage imageWithContentsOfFile:[NSURL URLWithString:imagePath].path];
  
  FrameworksProxy *cvFrameworkProxy = [[FrameworksProxy alloc] init];
  UIImage *processedImage = [cvFrameworkProxy UIImageFromCVMat:[cvFrameworkProxy cvMatFromUIImage:imageToProcess]];
  NSString *imagePathProcessed =  [self saveImageOnDisk:processedImage];
  
  successCallback(@[[RCTConvert NSString:imagePathProcessed]]);
  
}

- (NSString*) saveImageOnDisk:(UIImage*) imageToSave {
  NSData *imageData = UIImageJPEGRepresentation(imageToSave, 1.0);
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"processed"]];
  
  NSLog(@"pre writing to file");
  if (![imageData writeToFile:imagePath atomically:NO])
  {
    NSLog(@"Failed to cache image data to disk");
    return nil;
  }
  else
  {
    NSLog(@"the cachedImagedPath is %@",imagePath);
    return imagePath;
  }
  
}

@end

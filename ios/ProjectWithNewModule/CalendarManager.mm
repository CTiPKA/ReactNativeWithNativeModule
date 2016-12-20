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
#import "UIImage+OpenCV.h"
#import "PelletDetector.h"

@interface CalendarManager (){
  vector<KeyPoint> _keyPoints;
}

@property (nonatomic,strong) UIImage *imageForProcess;
@property (nonatomic,strong) UIImage *secondaryImage;

@end

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
  NSString *imagePathProcessed =  [self saveImageOnDisk:processedImage withName:@"fileFirst"];
  
  successCallback(@[[RCTConvert NSString:imagePathProcessed]]);
  
}


#pragma mark Markers

//- (void) createMarkers {
//  [self removeAllMarkers];
//  
//  if (_imageView.image.size.width) {
//    double scale = [self scale];
//    for (int i = 0; i < _keyPoints.size(); i++) {
//      KeyPoint keyPoint = _keyPoints[i];
//      CGPoint center = CGPointMake(keyPoint.pt.x * scale, keyPoint.pt.y * scale);
//      CGFloat radius = keyPoint.size * scale;
//      [self createMarkerAtPoint:center radius:radius];
//    }
//  }
//}
//
//- (void) createMarkerAtPoint: (CGPoint) center radius: (CGFloat) radius {
//  CAShapeLayer *marker = [CAShapeLayer layer];
//  
//  marker.frame = CGRectMake(center.x - radius, center.y - radius, 2 * radius, 2 * radius);
//  marker.path = [UIBezierPath bezierPathWithOvalInRect:marker.bounds].CGPath;
//  marker.strokeColor = _strokeColor.CGColor;
//  marker.fillColor = _fillColor.CGColor;
//  
//  [_markers addObject:marker];
//  [_markersView.layer addSublayer:marker];
//}
//
//- (void) removeAllMarkers {
//  for (CAShapeLayer *marker in self.markers) {
//    [marker removeFromSuperlayer];
//  }
//}


#pragma mark Detection

RCT_EXPORT_METHOD(detectPelletsOnImage:(NSDictionary *)imageDataDict
//                   completion: (void(^)(NSString *imagePath, NSInteger blobsCount, double evaluation, double averageSize, NSTimeInterval calculationTime)) completion)
                  errorCallback:(RCTResponseSenderBlock)failureCallback
                  callback:(RCTResponseSenderBlock)successCallback)
{
  NSString *imagePath = imageDataDict[@"uri"];
  UIImage *image = [UIImage imageWithContentsOfFile:[NSURL URLWithString:imagePath].path];
  
  if (image) {
    self.imageForProcess = image;
    //        Swi
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSDate *startDate = [NSDate date];
      Mat input = image.cvMat;

      _keyPoints = PelletDetector::detectBlobs(input);
      
      double evaluation = PelletDetector::evaluateDistribution(_keyPoints, input);
      double averageSize = PelletDetector::averageSize(_keyPoints);
      NSTimeInterval calculationTime = [[NSDate date] timeIntervalSinceDate:startDate];
      Mat binaryMat = PelletDetector::filterBlue(input);
      dispatch_async(dispatch_get_main_queue(), ^{
        self.imageForProcess = image;
        self.secondaryImage = [UIImage imageWithCVMat:binaryMat];
        //                self.image = self.secondaryImage;
//        [self createMarkers];
        if (successCallback) {
          NSString *imagePath = [self saveImageOnDisk:self.imageForProcess withName:@"fileFirst"];
          NSString *secondaryImagePath = [self saveImageOnDisk:self.secondaryImage withName:@"fileSecond"];
//          completion(imagePath, _keyPoints.size(), evaluation, averageSize, calculationTime);
          successCallback(@[[RCTConvert NSArray:@[
                                                  imagePath,
                                                  secondaryImagePath,
                                                  [NSNumber numberWithFloat:_keyPoints.size()],
                                                  [NSNumber numberWithDouble:evaluation],
                                                  [NSNumber numberWithDouble:averageSize],
                                                  [NSNumber numberWithDouble:calculationTime]
                                                  ]
                             ]
                            ]);
        }
      });
    });
  }
}

#pragma mark - Helpers

- (NSString*) saveImageOnDisk:(UIImage*) imageToSave withName:(NSString*)imageName {
  NSData *imageData = UIImageJPEGRepresentation(imageToSave, 1.0);
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageName]];
  
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

//- (cv::Point) imagePoint: (CGPoint) point {
//  CGPoint convertedPoint = [self convertPoint:point toView:_markersView];
//  return cv::Point(convertedPoint.x/self.scale, convertedPoint.y/self.scale);
//}


@end

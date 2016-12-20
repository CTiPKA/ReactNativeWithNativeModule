//
//  FrameworksProxy.h
//  ProjectWithNewModule
//
//  Created by vtrulyaev on 12/19/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>

@interface FrameworksProxy : NSObject

-(cv::Mat)cvMatFromUIImage:(UIImage *)image;
-(cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end

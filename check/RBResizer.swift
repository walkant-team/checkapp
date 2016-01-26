//
//  RBResizer.swift
//  check
//
//  Created by angelito on 1/23/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import UIKit

extension UIImage {
  
  func RBSquareImageTo(size: CGSize) -> UIImage? {
    return self.RBSquareImage()?.RBResizeImage(size)
  }
  
  func RBSquareImage() -> UIImage? {
    let originalWidth  = self.size.width
    let originalHeight = self.size.height
    
    var edge: CGFloat
    if originalWidth > originalHeight {
      edge = originalHeight
    } else {
      edge = originalWidth
    }
    
    let posX = (originalWidth  - edge) / 2.0
    let posY = (originalHeight - edge) / 2.0
    
    let cropSquare = CGRectMake(posX, posY, edge, edge)
    
    let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare);
    return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: self.imageOrientation)
  }
  
  func RBResizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    
    let widthRatio  = targetSize.width  / self.size.width
    let heightRatio = targetSize.height / self.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
      newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    } else {
      newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.mainScreen().scale)
    self.drawInRect(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
}
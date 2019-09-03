//
//  UIImage+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/10.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

/// 用于缓存圆形边框
private var cacheImageBg = [String: UIImage]()

public extension UIImage {
    /// 截取图片的一部分
    ///
    /// - parameter inRect: 指定截取图片的区域
    ///
    /// - returns: 截取的图片
    func zz_crop(inRect rect: CGRect) -> UIImage? {
        let scale = UIScreen.zz_scale
        let dotRect = CGRect(x: rect.zz_x * scale, y: rect.zz_y * scale, width: rect.width * scale, height: rect.height * scale)
        
        guard let cgimg = cgImage?.cropping(to: dotRect) else {
            return nil
        }
        
        return UIImage(cgImage: cgimg, scale: scale, orientation: .up)
    }
    
    /// 根据颜色生成指定大小的方图
    ///
    /// - parameter color:     图片颜色
    /// - parameter imageSize: 图片大小
    ///
    /// - returns: 生成的图片
    static func zz_image(withColor color: UIColor, imageSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 异步回执图片，主线程返回图片
    ///
    /// - parameter size:      图片的大小
    /// - parameter isCircle:  是否圆形图
    /// - parameter backColor: 图片的北京色
    /// - parameter finished:  回调返回图片的闭包
    func zz_asyncDrawImage(size: CGSize, isCircle: Bool = false, backColor: UIColor? = UIColor.white, finished: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.global().async {
            let key = "" + size.width.description + size.height.description + (backColor != nil ? backColor!.description : UIColor.clear.description)
            var backImg = cacheImageBg[key]
            let rect = CGRect(origin: CGPoint.zero, size: size)
            if backImg == nil && isCircle {
                backImg = UIImage.zz_clearCircleImage(inSize: size)
                cacheImageBg[key] = backImg
            }
            UIGraphicsBeginImageContextWithOptions(size, backColor != nil, 0.0)
            self.draw(in: rect)
            backImg?.draw(in: rect)
            let result = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                finished(result)
            }
        }
    }
    
    /// 根据指定大小和边部颜色生成一张中间是透明圆形的图片
    ///
    /// - parameter size:      图片大小，根据该大小设置中间
    /// - parameter backColor: 透明圆形与矩形四边之间的颜色
    ///
    /// - returns: 中间是透明圆形的图片
    class func zz_clearCircleImage(inSize size: CGSize, backColor: UIColor? = UIColor.white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        if let backColor = backColor {
            backColor.setFill()
            UIRectFill(rect)
        }
        
        // 透明圆
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        UIColor.clear.setFill()
        UIRectFill(rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// 生成一张渐变色图片
    ///
    /// - Parameters:
    ///   - fromColor: 起始颜色
    ///   - toColor: 终点颜色
    ///   - size: 图片大小
    /// - Returns: UIImage
    class func zz_gradientImage(fromColor: UIColor, toColor: UIColor, size: CGSize = CGSize(width: 100, height: 1)) -> UIImage {
        let frame = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
        UIRectClip(frame)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0)
        gradientLayer.frame = frame
        
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage {
    /// 压缩图片，降低质量
    ///
    /// - Parameters:
    ///   - sourceImage:
    ///   - maxSize: 最大的大小，KB
    ///   - maxWidth: 最大的宽度
    ///   - maxHeight: 最大的高度
    /// - Returns: 图片数据
    func zz_resetToSize(_ maxSize: Int, maxWidth: CGFloat, maxHeight: CGFloat) -> Data {
        // 先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = jpegData(compressionQuality: 1)!
        let sizeOrigin = finallImageData.count
        let sizeOriginKB = sizeOrigin / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData
        }
        
        // 获取原图片宽高比
        let sourceImageAspectRatio = size.width / size.height
        // 最大的宽高比
        let maxImageAspectRatio = maxWidth / maxHeight
        
        // 先调整分辨率
        var targetSize: CGSize
        if size.width < maxWidth && size.height < maxHeight {
            targetSize = size
        } else if sourceImageAspectRatio > maxImageAspectRatio {
            targetSize = CGSize(width: maxWidth, height: maxWidth * sourceImageAspectRatio)
        } else {
            targetSize = CGSize(width: maxHeight * sourceImageAspectRatio, height: maxHeight)
        }
        
        
        let newImage = zz_newSize(targetSize)
        
        finallImageData = newImage.jpegData(compressionQuality: 1.0)!
        
        if finallImageData.count / 1024 <= maxSize {
            return finallImageData
        }
        
        // 保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/50)
        var value = avg
        var i = 50
        
        repeat {
            i -= 1
            value = CGFloat(i) * avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        // 思路：使用二分法搜索
        finallImageData = zz_halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData, maxSize: maxSize)
        
        if finallImageData.count <= maxSize * 1024 {
            return finallImageData
        }

        // 如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData.count >= maxSize * 1024 {
            // 每次降100分辨率
            let reduceWidth = 100.0
            let reduceHeight = 100.0 / sourceImageAspectRatio
            
            if (targetSize.width - CGFloat(reduceWidth)) <= 0 || (targetSize.height - CGFloat(reduceHeight)) <= 0 {
                break
            }
            targetSize = CGSize(width: (targetSize.width - CGFloat(reduceWidth)), height: (targetSize.height - CGFloat(reduceHeight)))
            
            let image = UIImage(data: finallImageData)!.zz_newSize(targetSize)
            
            finallImageData = zz_halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData:image.jpegData(compressionQuality: 1)!, maxSize: maxSize)
        }
        
        return finallImageData
    }
    
    // 调整图片分辨率/尺寸（等比例缩放）
    func zz_newSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // 二分法压缩
    func zz_halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data {
        var tempFinallImageData = finallImageData
        
//        var tempData = Data()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
//        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = image.jpegData(compressionQuality: arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)KB\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            }
//            else if sizeOriginKB < maxSize {
//                if maxSize - sizeOriginKB < difference {
//                    difference = maxSize - sizeOriginKB
//                    tempData = tempFinallImageData
//                }
//                if index <= 0 {
//                    break
//                }
//                end = index - 1
//            }
            else {
                break
            }
        }
        return tempFinallImageData
    }
}

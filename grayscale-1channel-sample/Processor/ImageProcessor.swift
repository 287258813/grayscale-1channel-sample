//
//  ImageProcessor.swift
//  grayscale-1channel-sample
//
//  Created by What on 2018/12/21.
//  Copyright © 2018 dumbass. All rights reserved.
//

import CoreMedia.CMSampleBuffer

func sampleBufferCreatePlanar8(
    _ sampleBuffer: CMSampleBuffer)
    -> UnsafeMutablePointer<CUnsignedChar>? {
        
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        defer {
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        }
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer) else {
            return nil
        }
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let channels = 4
        let data = Data(bytesNoCopy: baseAddress, count: width * height, deallocator: .none)
        let size = data.count / channels
        
        let buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: size)
        
        stride(from: 0, to: data.count, by: channels).forEach {
            /// `G = (R + G + B) / 3`
            buffer.advanced(by: $0 / channels).pointee = ((data[$0].uint16 + data[$0 + 1].uint16 + data[$0 + 2].uint16) / 3).uint8
            //        buffer.advanced(by: $0 / channels).pointee = ($0..<$0 + 3).map({ data[$0].uint16 }).average().uint8
        }
        
        return buffer
        
        
//        let releaseData: CGDataProviderReleaseDataCallback = {
//            (info, buffer, length) in
//        }
//
//        return CGDataProvider(
//                dataInfo: nil,
//                data: buffer,
//                size: size,
//                releaseData: releaseData)
//            .flatMap {
//                CGImage(
//                width: width,
//                height: height,
//                bitsPerComponent: 8,
//                bitsPerPixel: 8,
//                bytesPerRow: width,
//                space: CGColorSpaceCreateDeviceGray(),
//                bitmapInfo: CGBitmapInfo(rawValue: 0),
//                provider: $0,
//                decode: nil,
//                shouldInterpolate: true,
//                intent: .defaultIntent)
//            }
//            .flatMap(UIImage.init)
        
}

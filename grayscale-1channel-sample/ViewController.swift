//
//  ViewController.swift
//  grayscale-1channel-sample
//
//  Created by What on 2018/12/21.
//  Copyright © 2018 dumbass. All rights reserved.
//

import UIKit
import Accelerate.vImage

class ViewController: UIViewController {
    
    var capture: VideoCapture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capture = try! .init(preview: view)
        capture.previewLayer.frame = view.bounds
        
    }
    
    @IBAction func vImageTapped(_ sender: Any) {
        
        let processQueue = DispatchQueue(label: "com.dumbass.sampleBuffer-vImageProcessor-queue")
        let start = Date.now
        var count = 60
        view.isUserInteractionEnabled = false
        
        capture.didOutputSampleBuffer = { [weak capture, unowned self] _, sampleBuffer, _ in
            processQueue.sync {
                if count <= 0 {
                    self.view.isUserInteractionEnabled = true
                    print(Date.now - start)
                    capture?.stop();
                    return
                }
                var buffer: vImage_Buffer = .init()
                vImageConvert_SampleBufferToPlanar8(sampleBuffer, &buffer)
                free(buffer.data); count -= 1
            }
        }
        
        capture.start()
    }
    
    @IBAction func normalTapped(_ sender: Any) {
        
        let processQueue = DispatchQueue(label: "com.dumbass.sampleBuffer-processor-queue")
        let start = Date.now
        var count = 60
        view.isUserInteractionEnabled = false
        
        capture.didOutputSampleBuffer = { [weak capture, unowned self] _, sampleBuffer, _ in
            processQueue.sync {
                if count <= 0 {
                    self.view.isUserInteractionEnabled = true
                    print(Date.now - start);
                    capture?.stop();
                    return
                }
                let buffer = sampleBufferCreatePlanar8(sampleBuffer)
                free(buffer); count -= 1
            }
        }
        
        capture.start()
    }
    
}


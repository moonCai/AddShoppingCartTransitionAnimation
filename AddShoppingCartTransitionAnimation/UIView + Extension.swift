//
//  UIView + Extension.swift
//  AddShoppingCartTransitionAnimation
//
//  Created by 蔡钰 on 2018/4/5.
//  Copyright © 2018年 moonCai. All rights reserved.
//

import UIKit

extension UIView {
    
    func toRetinaImage() -> (UIImage) {
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        self.drawHierarchy(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), afterScreenUpdates: false)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenShotImage!
    }
}

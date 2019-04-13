//
//  CalendarCollectionView.swift
//  BasketballHelper
//
//  Created by 王克平 on 2019/4/13.
//  Copyright © 2019 李宜銓. All rights reserved.
//

import UIKit

class CalendarCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

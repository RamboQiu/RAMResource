//
//  String+LocalizeImage.swift
//  YJSResource
//
//  Created by 裘俊云 on 2023/8/22.
//

import Foundation

/// 新增组件进行丰富即可
public extension String {
    // MARK: 图片
    func Component() -> UIImage? {
        return RAMResource.resource(with: "Component").image(self)
    }
    func Component2() -> UIImage? {
        return RAMResource.resource(with: "Component2").image(self)
    }
}

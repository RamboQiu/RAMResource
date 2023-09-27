//
//  String+Localize.swift
//  RAMResource
//
//  Created by 裘俊云 on 2023/8/22.
//

import Foundation


/// 新增组件进行丰富即可
public extension String {
    // MARK: 字符串
    func Component() -> String {
        return RAMResource.resource(with: "Component").string(self)
    }
    func Component2() -> String {
        return RAMResource.resource(with: "Component2").string(self)
    }
}

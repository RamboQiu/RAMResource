//
//  RAMResource.swift
//  RAMResource
//
//  Created by 裘俊云 on 2023/7/5.
//

import Foundation

/// App级别的当前语言存储的key
let RAMCurrentLanguageKey = "RAMCurrentLanguageKey"
/// 是否跟随系统
let RAMFollowSystemLanguageKey = "RAMFollowSystemLanguageKey"

/// 默认中文
let RAMDefaultLanguage = "en"//"zh-Hans"

let RAMBaseBundle = "Base"

/// 默认语言，跟随系统
public let RAMSystemLanguage = "system"

/// 语言切换时候的通知消息
public let RAMLanguageChangeNotification = "RAMLanguageChangeNotification"

/**
 * 组件的pod资源管理请参考
 *
 * ```
 * # resource_bundles可以避免多组件之间的图片同名问题 https://juejin.cn/post/6844903559931117581
 * # s.resource = ['YJHomePage/**/*.xcassets']
 * s.resource_bundles = {
 *   'YJHomePage' => ['YJHomePage/Resources/**/*']
 * }
 * ```
 */
public class RAMResource {
    public var moduleBundle = Bundle.main
    public var lanBundle = Bundle.main
    public var moduleName = ""
    public var module2res: [String: RAMResource] = [:]
    public var supportLan: [String] = ["zh-Hans", "en"]
    /// 是否跟随系统，默认跟随
    public var followSys = true
    
    public static let shared = RAMResource()

    /// main bundle里面设置的strings配置的语言
    public static func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: RAMBaseBundle) , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
    
    static func defaultLanguage() -> String {
        var defaultLanguage = RAMDefaultLanguage
        // 手机通用设置里面的语言列表，会带地区码 zh-Hans-CN en-CN ja-CN
        guard let systemLanguage = Locale.preferredLanguages.first else {
           return RAMDefaultLanguage
        }

        // 根据bundle里面的资源，选中的一个默认语言，不可控，如果设置中设置的是没有配置的日语，这里的值会是en
//        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
//           return RAMDefaultLanguage
//        }
        
        let availableLanguages: [String] = self.availableLanguages()
        for al in availableLanguages {
            if let _ = systemLanguage.range(of: al) {
                defaultLanguage = al
                break;
            }
        }
        return defaultLanguage
    }
    
    public static func followSystemLanguage() -> Bool {
       if let followSystemLanguage = UserDefaults.standard.object(forKey: RAMFollowSystemLanguageKey) as? String {
           if followSystemLanguage == "true" {
               return true
           } else {
               return false
           }
       } else {
           // 第一次安装没有设置过语言的情况下，默认是跟随系统
           return true
       }
    }

    public static func currentLanguage() -> String {
        if followSystemLanguage() {
            return defaultLanguage()
        } else if let currentLanguage = UserDefaults.standard.object(forKey: RAMCurrentLanguageKey) as? String {
           return currentLanguage
        }
        return defaultLanguage()
    }
    
    public static func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            UserDefaults.standard.set(selectedLanguage, forKey: RAMCurrentLanguageKey)
            UserDefaults.standard.set(language == RAMSystemLanguage ? "true" : "false", forKey: RAMFollowSystemLanguageKey)
            UserDefaults.standard.synchronize()

            for (module, lan) in RAMResource.shared.module2res {
                lan.lanBundle = RAMResource.bundle(with: module).1
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: RAMLanguageChangeNotification), object: nil)
        }
    }
    
    public static func resetCurrentLanguageToDefault() {
       setCurrentLanguage(self.defaultLanguage())
    }

    public static func displayNameForLanguage(_ language: String) -> String {
       let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
       if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
           return displayName
       }
       return String()
    }
    
    /// 每一个组件对应的资源
    public static func resource(with module: String) -> RAMResource {
        if let res = RAMResource.shared.module2res[module] {
            return res
        }
        let res = RAMResource()
        // 组件名可以使用入参传入的形式和固定的形式
        res.moduleName = module
        let bundle = bundle(with: res.moduleName)
        res.moduleBundle = bundle.0
        res.lanBundle = bundle.1
        RAMResource.shared.module2res[module] = res
        return res
    }
    
    /// 获取资源bundle和文件国际化的lproj bundle
    static func bundle(with module: String) -> (Bundle, Bundle) {
        var moduleBundle = Bundle.main
        var lanBundle = Bundle.main
        let lanType = RAMResource.currentLanguage()
        if let path = Bundle.main.path(forResource: module, ofType: "bundle") {
            moduleBundle = Bundle.init(path: path) ?? Bundle.main
            if let lprojpath = Bundle.init(path: path)?.path(forResource: lanType, ofType: "lproj") {
                lanBundle = Bundle.init(path: lprojpath)!
            }
        }
        return (moduleBundle, lanBundle)
    }
    
    public func string(_ key: String) -> String {
        let s = NSLocalizedString(key, tableName: moduleName, bundle: lanBundle, comment: "")
        return s
    }
    
    public func image(_ key: String) -> UIImage? {
        let lan = RAMResource.currentLanguage()
        let lanImage = key + "_" + lan
        if let bundleImage = UIImage(named: lanImage, in: moduleBundle, compatibleWith: nil) {
            return bundleImage
        } else if let bundleImage = UIImage(named: key, in: moduleBundle, compatibleWith: nil) {
            return bundleImage
        } else {
            if !key.isEmpty {
                assert(false, "未找到图片资源文件, imageName:\(key)")
            }
            return UIImage(named: key)
        }
    }
}

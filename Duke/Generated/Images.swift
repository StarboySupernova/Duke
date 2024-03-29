//
//  Images.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/3/22.
//

import Foundation

// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen
#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return
// MARK: - Asset Catalogs
// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Asset {
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let clock = ImageAsset(name: "clock")
  public enum Food {
    public static let food1 = ImageAsset(name: "food1")
    public static let food2 = ImageAsset(name: "food2")
    public static let food3 = ImageAsset(name: "food3")
    public static let food4 = ImageAsset(name: "food4")
    public static let food5 = ImageAsset(name: "food5")
    public static let food6 = ImageAsset(name: "food6")
    public static let food7 = ImageAsset(name: "food7")
  }
  public static let map = ImageAsset(name: "map")
  public static let money = ImageAsset(name: "money")
  public static let phone = ImageAsset(name: "phone")
  public static let star = ImageAsset(name: "star")
  public static let walk = ImageAsset(name: "walk")

  // swiftlint:disable trailing_comma
  public static let allColors: [ColorAsset] = [
    accentColor,
  ]
  public static let allImages: [ImageAsset] = [
    clock,
    Food.food1,
    Food.food2,
    Food.food3,
    Food.food4,
    Food.food5,
    Food.food6,
    Food.food7,
    map,
    money,
    phone,
    star,
    walk,
  ]
  // swiftlint:enable trailing_comma
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name
// MARK: - Implementation Details
public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

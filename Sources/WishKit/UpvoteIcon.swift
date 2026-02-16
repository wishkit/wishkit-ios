//
//  UpvoteIcon.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/16/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public enum WishKitUpvoteIcon {

    case systemName(String)

    case image(Image)

    #if canImport(UIKit)
    case uiImage(UIImage)
    #endif

    case thumbsUpIcon

    case arrowUpvoteIcon
}

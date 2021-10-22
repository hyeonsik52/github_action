//
//  SwiftEntryKit_Any.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import UIKit

import SwiftEntryKit
import Then

extension String: SwiftEntryKitViewBridge {
    
    var sek: SwiftEntryKitViewWrapper<String> {
        return .init {
            return EKNoteMessageView(
                with: .init(
                    text: self,
                    style: .init(
                        font: .bold[15],
                        color: .white,
                        alignment: .center,
                        numberOfLines: 0
                    )
                )
            ).then {
                $0.verticalOffset = 14
            }
        }
    }
}

extension SwiftEntryKitViewWrapper where Base == String {

    func showToast(_ completion: (() -> Void)? = nil) {
        
        var attributes: EKAttributes = .topFloat
        attributes.hapticFeedbackType = .none
        attributes.screenBackground = .clear
        attributes.entryBackground = .color(color: EKColor.init(red: 0, green: 0, blue: 0).with(alpha: 0.5))
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .dismiss
        attributes.roundCorners = .all(radius: 4)
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.5, spring: .init(damping: 0.9, initialVelocity: 0))
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.8, duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 24
        
        attributes.positionConstraints.size = .init(
            width: EKAttributes.PositionConstraints.Edge.ratio(value: 1),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: EKAttributes.PositionConstraints.Edge.ratio(value: 0.8),
            height: EKAttributes.PositionConstraints.Edge.ratio(value: 0.618)
        )
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: false)
        attributes.lifecycleEvents.willDisappear = completion

        self.show(with: attributes)
    }
    
    func showTopNote(color: UIColor, _ completion: (() -> Void)? = nil) {
        
        var attributes: EKAttributes = .topNote
        attributes.displayMode = .inferred
        attributes.hapticFeedbackType = .none
        attributes.displayDuration = 1
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: .init(color))
        attributes.statusBar = .light

        self.show(with: attributes)
    }
}

//
//  SwiftEntryKit_Show.swift
//  ServiceRobotPlatform-iOS
//
//  Created by nexmond on 2020/07/20.
//  Copyright © 2020 Twinny Co.,Ltd. All rights reserved.
//

import SwiftEntryKit

extension SwiftEntryKitExtension {
    
    func showPopup() {
        
        var attributes: EKAttributes = .bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: EKColor(UIColor.black.withAlphaComponent(0.5)))
        attributes.entryBackground = .color(color: EKColor(.white))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .forward
        attributes.entranceAnimation = .init(
            translate: .init(duration: 0.5, spring: .init(damping: 0.9, initialVelocity: 0))
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.8, duration: 0.3)
            )
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.size = .init(
            width: EKAttributes.PositionConstraints.Edge.ratio(value: 1),
            height: .intrinsic
        )
        attributes.positionConstraints.maxSize = .init(
            width: EKAttributes.PositionConstraints.Edge.ratio(value: 1),
            height: EKAttributes.PositionConstraints.Edge.ratio(value: 0.618)
        )
        attributes.statusBar = .dark
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        
        self.show(with: attributes)
    }
    
    func showFullscreen() {
        
        var attributes: EKAttributes = .bottomFloat
        
        attributes.scroll = .disabled
        
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .forward
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)))
        
        attributes.shadow = .none
        
        attributes.positionConstraints.size = .screen
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden

        self.show(with: attributes)
    }
    
    func showBottomSheet() {
        
        var attributes: EKAttributes = .bottomToast
        
        attributes.entryBackground = .color(color: .init(.white))
        attributes.entryInteraction = .forward
        
        attributes.screenBackground = .color(color: .init(UIColor.black.withAlphaComponent(0.5)))
        attributes.screenInteraction = .dismiss
        
        attributes.displayDuration = .infinity
        
        let translateAnimation = EKAttributes.Animation.Translate(
            duration: 0.65,
            spring: .init(damping: 1, initialVelocity: 0)
        )
        attributes.entranceAnimation = .init(translate: translateAnimation)
        attributes.exitAnimation = .init(translate: translateAnimation)
        
        attributes.popBehavior = .animated(animation: .init(translate: translateAnimation))
        
        attributes.positionConstraints.keyboardRelation = .bind(
            offset: .init(bottom: 0, screenEdgeResistance: 0)
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: UIScreen.main.bounds.size.width),
            height: .intrinsic
        )
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        
        attributes.roundCorners = .top(radius: 16)
        
        self.show(with: attributes)
    }
}

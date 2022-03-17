//
//  ServiceArgumentGeneralization.swift
//  TARAS
//
//  Created by nexmond on 2022/03/16.
//

import Foundation

protocol ServiceArgumentType {
    var id: bigint { get }
    var arrayOf: Bool { get }
    var name: String { get }
    var `required`: Bool { get }
    var displayText: String { get }
    var uiComponentType: String { get }
    var uiComponentDefaultValue: String { get }
    var model: String { get }
    var needToSet: Bool { get }
    var generalizedInputType: ServiceArgumentInputType { get }
}

extension ServiceArgumentRawFragment: ServiceArgumentType {
    var generalizedInputType: ServiceArgumentInputType { self.inputType }
}

extension ServiceChildArgumentRawFragment: ServiceArgumentType {
    var generalizedInputType: ServiceArgumentInputType { self.inputType }
}


protocol ServiceArgumentInputType {
    var name: String { get }
    var generalizedChildArguments: [ServiceArgumentType]? { get }
}

extension ServiceArgumentRawFragment.InputType: ServiceArgumentInputType {
    var generalizedChildArguments: [ServiceArgumentType]? { self.childArguments }
}
extension ServiceArgumentRawFragment.InputType.ChildArgument.InputType: ServiceArgumentInputType {
    var generalizedChildArguments: [ServiceArgumentType]? { self.childArguments }
}
extension ServiceArgumentRawFragment.InputType.ChildArgument.InputType.ChildArgument.InputType: ServiceArgumentInputType {
    var generalizedChildArguments: [ServiceArgumentType]? { self.childArguments }
}

extension ServiceChildArgumentRawFragment.InputType: ServiceArgumentInputType {
    var generalizedChildArguments: [ServiceArgumentType]? { nil }
}

extension ServiceArgumentRawFragment.InputType.ChildArgument: ServiceArgumentType {
    var id: bigint { self.fragments.serviceChildArgumentRawFragment.id }
    var arrayOf: Bool { self.fragments.serviceChildArgumentRawFragment.arrayOf }
    var name: String { self.fragments.serviceChildArgumentRawFragment.name }
    var required: Bool { self.fragments.serviceChildArgumentRawFragment.required }
    var displayText: String { self.fragments.serviceChildArgumentRawFragment.displayText }
    var uiComponentType: String { self.fragments.serviceChildArgumentRawFragment.uiComponentType }
    var uiComponentDefaultValue: String { self.fragments.serviceChildArgumentRawFragment.uiComponentDefaultValue }
    var model: String { self.fragments.serviceChildArgumentRawFragment.model }
    var needToSet: Bool { self.fragments.serviceChildArgumentRawFragment.needToSet }
    var generalizedInputType: ServiceArgumentInputType { self.inputType }
}
extension ServiceArgumentRawFragment.InputType.ChildArgument.InputType.ChildArgument: ServiceArgumentType {
    var id: bigint { self.fragments.serviceChildArgumentRawFragment.id }
    var arrayOf: Bool { self.fragments.serviceChildArgumentRawFragment.arrayOf }
    var name: String { self.fragments.serviceChildArgumentRawFragment.name }
    var required: Bool { self.fragments.serviceChildArgumentRawFragment.required }
    var displayText: String { self.fragments.serviceChildArgumentRawFragment.displayText }
    var uiComponentType: String { self.fragments.serviceChildArgumentRawFragment.uiComponentType }
    var uiComponentDefaultValue: String { self.fragments.serviceChildArgumentRawFragment.uiComponentDefaultValue }
    var model: String { self.fragments.serviceChildArgumentRawFragment.model }
    var needToSet: Bool { self.fragments.serviceChildArgumentRawFragment.needToSet }
    var generalizedInputType: ServiceArgumentInputType { self.inputType }
}
extension ServiceArgumentRawFragment.InputType.ChildArgument.InputType.ChildArgument.InputType.ChildArgument: ServiceArgumentType {
    var id: bigint { self.fragments.serviceChildArgumentRawFragment.id }
    var arrayOf: Bool { self.fragments.serviceChildArgumentRawFragment.arrayOf }
    var name: String { self.fragments.serviceChildArgumentRawFragment.name }
    var required: Bool { self.fragments.serviceChildArgumentRawFragment.required }
    var displayText: String { self.fragments.serviceChildArgumentRawFragment.displayText }
    var uiComponentType: String { self.fragments.serviceChildArgumentRawFragment.uiComponentType }
    var uiComponentDefaultValue: String { self.fragments.serviceChildArgumentRawFragment.uiComponentDefaultValue }
    var model: String { self.fragments.serviceChildArgumentRawFragment.model }
    var needToSet: Bool { self.fragments.serviceChildArgumentRawFragment.needToSet }
    var generalizedInputType: ServiceArgumentInputType { self.fragments.serviceChildArgumentRawFragment.inputType }
}


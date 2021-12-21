//
//  FragmentModel.swift
//  TARAS-Dev
//
//  Created by nexmond on 2021/08/09.
//

import Apollo

protocol FragmentModel {
    associatedtype T: GraphQLFragment
    init(_ fragment: T)
    init(option fragment: T?)
}

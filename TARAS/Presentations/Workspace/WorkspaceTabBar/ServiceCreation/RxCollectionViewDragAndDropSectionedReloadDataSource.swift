//
//  RxCollectionViewDragAndDropSectionedReloadDataSource.swift
//  GRaaSS-Dev
//
//  Created by nexmond on 2021/11/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class RxCollectionViewDragAndDropSectionedReloadDataSource<Section: SectionModelType>
    : CollectionViewSectionedDataSource<Section>
    , RxCollectionViewDataSourceType
    , UICollectionViewDragDelegate
    , UICollectionViewDropDelegate {
    
    public typealias Element = [Section]
    
    open func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource.setSections(element)
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }.on(observedEvent)
    }
    
    //Drag
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        return [.init(itemProvider: .init())]
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dragPreviewParametersForItemAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        return .init().then {
            $0.visiblePath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 4)
            $0.backgroundColor = .white
        }
    }
    
    //Drop
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        guard collectionView.hasActiveDrag, session.items.count == 1 else {
            return .init(operation: .cancel)
        }
        return .init(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropPreviewParametersForItemAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        return .init().then {
            $0.visiblePath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 4)
            $0.backgroundColor = .white
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        if let destinationIndexPath = coordinator.destinationIndexPath,
           coordinator.proposal.operation == .move,
           let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates({
                self.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(
                item.dragItem,
                toItemAt: destinationIndexPath
            ).addCompletion { position in
                if position == .end {
                    collectionView.reloadData()
                    collectionView.collectionViewLayout.invalidateLayout()
                }
            }
        }
    }
}

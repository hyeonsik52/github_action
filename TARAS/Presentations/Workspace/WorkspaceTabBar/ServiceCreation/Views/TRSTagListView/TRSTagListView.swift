//
//  TRSTagListView.swift
//  TARAS-Dev
//
//  Created by nexmond on 2022/01/24.
//

import UIKit

protocol TRSTagListViewDelegate: AnyObject {
    func tagListView(_ tagListView: TRSTagListView, didSelect model: TRSTagListViewModel)
    func tagListView(_ tagListView: TRSTagListView, didRemove model: TRSTagListViewModel)
}

class TRSTagListView: UICollectionView {
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    weak var tagListDelegate: TRSTagListViewDelegate?
    
    private var tagList = [TRSTagListViewModel]()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: self.flowLayout)
        
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
        
        self.register(TRSTagListViewCell.self, forCellWithReuseIdentifier: "cell")
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TRSTagListView: UICollectionViewDataSource {
    
    override var numberOfSections: Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TRSTagListViewCell
        let model = self.tagList[indexPath.item]
        cell.bind(model)
        cell.delegate = self
        
        return cell
    }
}

extension TRSTagListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .grayE3E0E3
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .purpleEEE8F4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.tagList[indexPath.item]
        self.tagListDelegate?.tagListView(self, didSelect: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.tagList[indexPath.item]
        let attributes = [NSAttributedString.Key.font: UIFont.regular[14]]
        let titleWidth = (model.title as NSString).boundingRect(
            with: .init(width: .infinity, height: 28.0),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        ).width
        return .init(width: ceil(titleWidth) + 12 + 32, height: 28)
    }
}

extension TRSTagListView: TRSTagListViewCellDelegate {
    
    func tagListCell(_ tagListCell: TRSTagListViewCell, didRemoveSelect model: TRSTagListViewModel) {
        self.tagListDelegate?.tagListView(self, didRemove: model)
    }
}

extension TRSTagListView {
    
    func setTags(_ tags: [String]) {
    
        let current = self.tagList
        let new = tags.map(TRSTagListViewModel.init)
        
        let deleted = NSMutableOrderedSet(array: current)
        deleted.minus(.init(array: new))
        let deletedIndexes = current.enumerated().filter { deleted.contains($0.element) }
        
        let inserted = NSMutableOrderedSet(array: new)
        inserted.minus(.init(array: current))
        let insertedIndexes = new.enumerated().filter { inserted.contains($0.element) }
        
        let moved = new.enumerated().compactMap { to, model -> (Int, (Int, TRSTagListViewModel))? in
            guard let from = current.firstIndex(of: model) else { return nil }
            guard from > to else { return nil }
            return (from, (to, model))
        }
        
        var isInserted = false
        
        self.performBatchUpdates {
            
            if deletedIndexes.count > 0 {
                deletedIndexes.reversed().forEach {
                    self.tagList.remove(at: $0.offset)
                }
                self.deleteItems(at: deletedIndexes.map { .init(item: $0.offset, section: 0) })
            }
            
            if insertedIndexes.count > 0 {
                insertedIndexes.forEach {
                    self.tagList.insert($0.element, at: $0.offset)
                }
                self.insertItems(at: insertedIndexes.map { .init(item: $0.offset, section: 0) })
                isInserted = true
            }
            
            if current.count == new.count, moved.count > 0 {
                moved.reversed().forEach {
                    self.tagList.remove(at: $0.0)
                }
                self.deleteItems(at: moved.map { .init(item: $0.0, section: 0) })
                moved.forEach {
                    self.tagList.insert($1.1, at: $1.0)
                }
                self.insertItems(at: moved.map { .init(item: $1.0, section: 0) })
                isInserted = true
            }
        }
        
        if isInserted {
            self.scrollToItem(at: .init(item: 0, section: 0), at: .right, animated: true)
        }
    }
}

extension TRSTagListView {
    
    @objc override var isKeyboardHideWhenTouch: Bool {
        return false
    }
}

//
//  ViewController.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit
import WooliesAPI

enum ViewSection: Equatable {
    
    case section
}

enum ViewItem: Equatable {
    
    case item(DogImage)
    
    static func == (lhs: ViewItem, rhs: ViewItem) -> Bool {
        
        switch (lhs, rhs) {
            
        case (.item(let lhsContent), .item(let rhsContent)):
            
            return lhsContent == rhsContent
        }
    }
}

class ViewController: JCollectionViewController<ViewSection, ViewItem> {

    private var viewModel: ViewModelProtocol? = ViewModel()
    
    private var refreshControl = UIRefreshControl()
    
    /// generates the items based on the data given by the `ViewModel` that will be rendered on the `CollectionView`
    override var sectionsAndItems: Array<SectionAndItems> {
        
        var items = [ViewItem]()
        
        let isAscending = self.viewModel?.isAscending ?? true
        
        let images = self.viewModel?.images?.sorted {
            
            (($0.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan) < ($1.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan) && isAscending) ||
            (($0.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan) > ($1.firstBreed?.minLifeSpan ?? Breed.greatestLifeSpan) && !isAscending)
        }
        
        images?.forEach {
            
            items.append(.item($0))
        }
        
        return [(.section, items)]
    }
    
    // MARK: - Setup
    
    /// setup the ViewModel callbacks and their behaviours
    private func setupViewModel() {
        
        self.viewModel?.onUpdated = { [weak self] in

            DispatchQueue.main.async {
                
                self?.refreshControl.endRefreshing()

                self?.updateSectionsAndItems()
            }
        }
    }
    
    /// Pull-to-refresh
    private func setupPullToRefresh() {
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        
        self.refreshControl.addTarget(self, action: #selector(onRefresh), for: UIControl.Event.valueChanged)
        
        self.collectionView?.refreshControl = self.refreshControl
    }

    func setupViews() {
        
        if #available(iOS 13.0, *) {
            
            self.view.backgroundColor = .systemGray6
        }
        else {
            
            self.view.backgroundColor = .white
        }
    }
    
    /// Register cells
    override func setupCollectionView() {
        
        super.setupCollectionView()
        
        self.collectionView?.register(cell: ImageCell.self)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupViews()
        
        self.setupViewModel()

        self.setupPullToRefresh()
        
        self.viewModel?.getImages()
    }
    
    // MARK: - UICollectionViewDataSource & UICollectionViewDelegate
    
    /// Renders all the items
    override func collectionView(_ collectionView: UICollectionView, cellForSection section: ViewSection, item: ViewItem, indexPath: IndexPath) -> UICollectionViewCell? {
        
        if case .item(let image) = item {
            
            if let cell = self.collectionView?.dequeueReusable(cell: ImageCell.self, for: indexPath) {
                
                return cell.prepare(image: image)
            }
        }
        
        return nil
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForSection section: ViewSection, item: ViewItem, indexPath: IndexPath) -> CGSize? {
        
        if case .item(let image) = item {
            
            return ImageCell.size(givenWidth: collectionView.frame.width, image: image)
        }
        
        return .zero
    }
    
    // MARK: - Actions
    
    @objc
    func onRefresh() {
        
        self.viewModel?.getImages()
    }
    
    @IBAction func sortButtonTouchUpInside(_ sender: Any) {
        
        let isAscending = self.viewModel?.isAscending ?? true
        
        self.viewModel?.isAscending = !(isAscending)
        
        self.updateSectionsAndItems()
    }
}

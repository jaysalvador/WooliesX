//
//  ViewController.swift
//  WooliesX
//
//  Created by Jay Salvador on 22/4/20.
//  Copyright © 2020 Jay Salvador. All rights reserved.
//

import UIKit
import WooliesAPI
import collection_view_layouts

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

class ViewController: JCollectionViewController<ViewSection, ViewItem>, LayoutDelegate {

    private var viewModel: ViewModelProtocol? = ViewModel()
    
    private var refreshControl = UIRefreshControl()
    
    private lazy var layout: PinterestLayout = {
        
        let layout = PinterestLayout()
        
        layout.delegate = self
        
        layout.cellsPadding = ItemsPadding(horizontal: 20, vertical: 20)
        
        layout.contentPadding = ItemsPadding(horizontal: 20, vertical: 20)
        
        layout.columnsCount = Int(self.columns)
        
        return layout
    }()
    
    private var columns: CGFloat {
        
        if let width = self.view?.frame.width {
            
            return width >= 1024.0 ? 3 : (width > 414.0 ? 2 : 1)
        }
        return 1
    }
    
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
        
        self.viewModel?.onError = { [weak self] in
            
            DispatchQueue.main.async {
                
                let error = self?.viewModel?.error
                
                let alert = UIAlertController(title: error?.title, message: error?.errorDescription, preferredStyle: .alert)
                
                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default,
                        handler: { _ in

                            self?.title = nil
                            
                            self?.updateSectionsAndItems(forced: true)
                            
                            self?.refreshControl.endRefreshing()
                        }
                    )
                )
                
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /// Pull-to-refresh
    private func setupPullToRefresh() {
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        
        self.refreshControl.addTarget(self, action: #selector(onRefresh), for: UIControl.Event.valueChanged)
        
        self.collectionView?.refreshControl = self.refreshControl
    }

    /// setup UI properties and layout
    func setupViews() {
        
        self.collectionView?.setCollectionViewLayout(self.layout, animated: true)
        
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
    
    override func viewWillLayoutSubviews() {
        
        self.layout.columnsCount = Int(self.columns)
        
        self.layout.invalidateLayout()
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
            
            return ImageCell.size(givenWidth: collectionView.frame.width, image: image, columns: self.columns)
        }
        
        return .zero
    }
    
    // MARK: - LayoutDelegate
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        
        if let collectionView = self.collectionView,
            let (section, item) = self.sectionAndItem(atIndexPath: indexPath),
            let size = self.collectionView(
                collectionView,
                layout: self.layout,
                sizeForSection: section,
                item: item,
                indexPath: indexPath
            ) {
            
            return size
        }
        
        return .zero
    }
    
    // MARK: - Actions
    
    @objc
    func onRefresh() {
        
        self.viewModel?.getImages()
    }
    
    @IBAction func sortButtonTouchUpInside() {
        
        let isAscending = self.viewModel?.isAscending ?? true
        
        self.viewModel?.isAscending = !(isAscending)
        
        self.updateSectionsAndItems()
    }
}

extension ViewController {
    
    class func make(withViewModel viewModel: ViewModelProtocol) -> ViewController? {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {

            vc.viewModel = viewModel
            
            return vc
        }
        
        return nil
    }
}

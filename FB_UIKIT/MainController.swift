//
//  MainController.swift
//  FB_UIKIT
//
//  Created by Ata Etgi on 3.02.2021.
//

import UIKit
import LBTATools

class PostCell: LBTAListCell<String> {
    
    let imageView = UIImageView(backgroundColor: .blue)
    let nameLabel = UILabel(text: "Name Label")
    let dateLabel = UILabel(text: "Friday at 11:11AM")
    let postTextLabel = UILabel(text: "Here is my post text")
    
//    let imageViewGrid = UIView(backgroundColor: .yellow)
    
    let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        
        stack(hstack(imageView.withHeight(40).withWidth(40),
                     stack(nameLabel, dateLabel),
                     spacing: 8
        ).padLeft(12).padRight(12).padTop(12),
        postTextLabel,
        photosGridController.view,
        spacing: 8)
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class StoryPhotoCell: LBTAListCell<String> {
    
    override var item: String! {
        didSet{
            imageView.image = UIImage(named: item)
            nameLabel.text = item
        }
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    let nameLabel = UILabel(text: "Jane Doe", font: .boldSystemFont(ofSize: 14), textColor: .white)
    
    override func setupViews() {
        
        imageView.layer.cornerRadius = 10
        stack(imageView)
        
        setupGradientLayer()
        
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    let gradient = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.7, 1.1]
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
}


class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsHorizontalScrollIndicator = false
        self.items = ["jane1", "lady4c","jane2", "lady5c", "jane3", "jane4", "jane1", "kelly2"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.height / 2, height: view.frame.height - 24)
    }
    
    
}

class MainController: LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        self.items = ["hello", "world", "1", "3"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 450)
    }
    
}


import SwiftUI

// USING SWIFTUI PREVIEW WITH UIKIT
// CMD + OPT + P => Resume Preview Shortcut
struct MainPreview: PreviewProvider {
    static var previews: some View {
//        Text("Main preview")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            MainController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

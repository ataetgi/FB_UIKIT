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
        
        imageView.layer.cornerRadius = 20
        
        stack(hstack(imageView.withHeight(40).withWidth(40),
                     stack(nameLabel, dateLabel),
                     spacing: 8
        ).padLeft(12).padRight(12).padTop(12),
        stack(postTextLabel).padLeft(12),
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
        self.items = ["jane1", "lady4c", "jane2", "lady5c", "jane3", "kelly2", "jane4"]
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
        setupNavBar()
    }
    
    let fbLogoImageView = UIImageView(image: #imageLiteral(resourceName: "fb_logo"), contentMode: .scaleAspectFit)
    let titleView = UIView()
    let searchButton = UIButton(image: #imageLiteral(resourceName: "search"), tintColor: .systemBlue)
    let messageButton = UIButton(image: #imageLiteral(resourceName: "messenger"), tintColor: .systemBlue)
    
    fileprivate func setupNavBar() {
//        navigationItem.title = "Facebook"
        
        let coverWidthView = UIView(backgroundColor: .white)
        view.addSubview(coverWidthView)
        coverWidthView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let safeAreaTop = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.top ?? 0
        coverWidthView.constrainHeight(safeAreaTop)

        
        [searchButton, messageButton].forEach { (button) in
            button.imageEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
            button.layer.cornerRadius = 17
//            button.clipsToBounds = true
            button.backgroundColor = .init(white: 0.9, alpha: 1)
            button.withSize(.init(width: 34, height: 34))
        }
        
        let lessWith: CGFloat = 34 + 34 + 120 + 24 + 15
        let width = UIScreen.main.bounds.width - lessWith
        
        titleView.backgroundColor = .clear
//        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        
        titleView.hstack(fbLogoImageView.withWidth(120), UIView().withWidth(width), searchButton, messageButton, spacing: 8).padBottom(8)
        
//        titleView.addSubview(fbLogoImageView)
        navigationItem.titleView = titleView
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.top ?? 0
//        let magicalSafeAreaTop: CGFloat = view.safeAreaInsets.top   /= same =/ let magicalSafeAreaTop = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        
        let offSet = scrollView.contentOffset.y + view.safeAreaInsets.top
        
        print(scrollView.contentOffset.y)
        
        let alpha: CGFloat = 1 - (offSet / safeAreaTop)
        [fbLogoImageView, searchButton].forEach({$0.alpha = alpha})
        fbLogoImageView.alpha = alpha
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
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
            UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

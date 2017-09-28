//
//  ViewController.swift
//  SHSearchBar
//
//  Created by Stefan Herold on 08/01/2016.
//  Copyright (c) 2016 Stefan Herold. All rights reserved.
//

import UIKit
import AddressBookUI
import Contacts
import SHSearchBar

class ViewController: UIViewController, SHSearchBarDelegate {

    var searchBar1: SHSearchBar!
    var searchBar2: SHSearchBar!
    var searchBar3: SHSearchBar!
    var searchBar4: SHSearchBar!
    var addressSearchbarTop: SHSearchBar!
    var addressSearchbarBottom: SHSearchBar!

    var viewConstraints: [NSLayoutConstraint] = []

    let addressFormatter: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rasterSize: CGFloat = 11.0
        let searchGlassIconTemplate = UIImage(named: "icon-search")!.withRenderingMode(.alwaysTemplate)

        view.backgroundColor = UIColor.white

        let leftView1 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        searchBar1 = defaultSearchBar(withRasterSize: rasterSize, leftView: leftView1, rightView: nil, delegate: self)
        view.addSubview(searchBar1)

        let rightView2 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        searchBar2 = defaultSearchBar(withRasterSize: rasterSize, leftView: nil, rightView: rightView2, delegate: self)
        searchBar2.text = NSLocalizedString("sbe.exampleText.simple", comment: "")
        view.addSubview(searchBar2)

        let leftView3 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        let rightView3 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        searchBar3 = defaultSearchBar(withRasterSize: rasterSize, leftView: leftView3, rightView: rightView3, delegate: self)
        searchBar3.text = NSLocalizedString("sbe.exampleText.withLeftView", comment: "")
        view.addSubview(searchBar3)

        // TODO: SearchBar4: centered text lets the icon on the left - this is not intended!
        let leftView4 = imageViewWithIcon(searchGlassIconTemplate, rasterSize: rasterSize)
        searchBar4 = defaultSearchBar(withRasterSize: rasterSize, leftView: leftView4, rightView: nil, delegate: self)
        searchBar4.textAlignment = .center
        searchBar4.text = NSLocalizedString("sbe.exampleText.centered", comment: "")
        view.addSubview(searchBar4)

        let addressTop = CNMutablePostalAddress()
        addressTop.city = "Frankfurt am Main"
        addressTop.street = "Mainzer Landstraße 123"
        addressSearchbarTop = defaultSearchBar(withRasterSize: rasterSize, leftView: nil, rightView: nil, delegate: self)
        addressSearchbarTop.text = addressFormatter.string(from: addressTop)
        addressSearchbarTop.updateBackgroundImage(withRadius: 6, corners: [.topLeft, .topRight], color: UIColor.white)
        view.addSubview(addressSearchbarTop)

        let addressBottom = CNMutablePostalAddress()
        addressBottom.city = "Frankfurt am Main"
        addressBottom.street = "Darmstädter Landstraße 123"
        addressSearchbarBottom = defaultSearchBar(withRasterSize: rasterSize, leftView: nil, rightView: nil, delegate: self)
        addressSearchbarBottom.text = addressFormatter.string(from: addressBottom)
        addressSearchbarBottom.updateBackgroundImage(withRadius: 6, corners: [.bottomLeft, .bottomRight], color: UIColor.white)
        view.addSubview(addressSearchbarBottom)

        setupViewConstraints(usingMargin: rasterSize)

        let allSearchBars: [SHSearchBar] = [searchBar1, searchBar2, searchBar3, searchBar4, addressSearchbarTop, addressSearchbarBottom]

        // Update the searchbar config

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            let rasterSize: CGFloat = 22.0
            for bar in allSearchBars {
                var config = bar.config
                config.cancelButtonTextAttributes = [.foregroundColor : UIColor.red]
                config.rasterSize = rasterSize
                bar.config = config
            }
            self?.setupViewConstraints(usingMargin: rasterSize)
        }
    }
    
    fileprivate func setupViewConstraints(usingMargin margin: CGFloat) {
        let searchbarHeight: CGFloat = 44.0

        // Deactivate old constraints
        for constraint in viewConstraints {
            constraint.isActive = false
        }

        viewConstraints = [
            topLayoutGuide.bottomAnchor.constraint(equalTo: searchBar1.topAnchor, constant: -margin),

            searchBar1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            searchBar1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            searchBar1.bottomAnchor.constraint(equalTo: searchBar2.topAnchor, constant: -margin),
            searchBar1.heightAnchor.constraint(equalToConstant: searchbarHeight),

            searchBar2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            searchBar2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            searchBar2.bottomAnchor.constraint(equalTo: searchBar3.topAnchor, constant: -margin),
            searchBar2.heightAnchor.constraint(equalToConstant: searchbarHeight),

            searchBar3.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            searchBar3.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            searchBar3.bottomAnchor.constraint(equalTo: searchBar4.topAnchor, constant: -margin),
            searchBar3.heightAnchor.constraint(equalToConstant: searchbarHeight),

            searchBar4.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            searchBar4.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            searchBar4.bottomAnchor.constraint(equalTo: addressSearchbarTop.topAnchor, constant: -margin),
            searchBar4.heightAnchor.constraint(equalToConstant: searchbarHeight),

            addressSearchbarTop.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            addressSearchbarTop.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            addressSearchbarTop.bottomAnchor.constraint(equalTo: addressSearchbarBottom.topAnchor, constant: -1.0),
            addressSearchbarTop.heightAnchor.constraint(equalToConstant: searchbarHeight),

            addressSearchbarBottom.leftAnchor.constraint(equalTo: view.leftAnchor, constant: margin),
            addressSearchbarBottom.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -margin),
            addressSearchbarBottom.heightAnchor.constraint(equalToConstant: searchbarHeight),
        ]
        NSLayoutConstraint.activate(viewConstraints)
    }
}



// MARK: - Helper Functions

func defaultSearchBar(withRasterSize rasterSize: CGFloat, leftView: UIView?, rightView: UIView?, delegate: SHSearchBarDelegate) -> SHSearchBar {
    var config = defaultSearchBarConfig(rasterSize)
    config.leftView = leftView
    config.rightView = rightView

    if leftView != nil {
        config.leftViewMode = .always
    }

    if rightView != nil {
        config.rightViewMode = .unlessEditing
    }

    let bar = SHSearchBar(config: config)
    bar.delegate = delegate
    bar.placeholder = NSLocalizedString("sbe.textfieldPlaceholder.default", comment: "")
    bar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
    bar.layer.shadowColor = UIColor.black.cgColor
    bar.layer.shadowOffset = CGSize(width: 0, height: 3)
    bar.layer.shadowRadius = 5
    bar.layer.shadowOpacity = 0.25

    return bar
}

func defaultSearchBarConfig(_ rasterSize: CGFloat) -> SHSearchBarConfig {
    var config: SHSearchBarConfig = SHSearchBarConfig()
    config.rasterSize = rasterSize
    config.cancelButtonTitle = NSLocalizedString("sbe.general.cancel", comment: "")
    config.cancelButtonTextAttributes = [.foregroundColor : UIColor.darkGray]
    config.textContentType = UITextContentType.fullStreetAddress.rawValue
    config.textAttributes = [.foregroundColor : UIColor.gray]
    return config
}

func imageViewWithIcon(_ icon: UIImage, rasterSize: CGFloat) -> UIImageView {
    let imgView = UIImageView(image: icon)
    imgView.frame = CGRect(x: 0, y: 0, width: icon.size.width + rasterSize * 2.0, height: icon.size.height)
    imgView.contentMode = .center
    imgView.tintColor = UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)
    return imgView
}

//
//  NativeAdCell.swift
//  Honest
//
//  Created by Ryan Schefske on 3/16/20.
//  Copyright © 2020 Ryan Schefske. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeAdCell: UICollectionViewCell {
	
	static let reuseID = "AdCell"
	
	var adView = GADUnifiedNativeAdView()
	var iconView = UIImageView()
	var headline = UILabel()
	var advertiser = UILabel()
	var body = UILabel()
	var callToAction = UIButton()
	var price = UILabel()
	var store = UILabel()
	var mediaView = GADMediaView()
	var starRating = UILabel()
	var adLabel = UILabel()
	var tappableOverlay = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureViews()
		configureConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func configureViews() {
		adView = {
			let view = GADUnifiedNativeAdView()
			view.backgroundColor = .tertiarySystemBackground
			view.layer.cornerRadius = 15
			layer.shadowColor = UIColor.black.cgColor
			layer.shadowOpacity = 0.2
			layer.shadowRadius = 15
			view.translatesAutoresizingMaskIntoConstraints = false
			return view
		}()
		
		iconView = {
			let iv = UIImageView()
			iv.translatesAutoresizingMaskIntoConstraints = false
			return iv
		}()
		
		headline = {
			let lbl = UILabel()
			lbl.font = UIFont.systemFont(ofSize: 20)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		advertiser = {
			let lbl = UILabel()
			lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		starRating = {
			let lbl = UILabel()
			lbl.font = UIFont.systemFont(ofSize: 18)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		body = {
			let lbl = UILabel()
			lbl.numberOfLines = 3
			lbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		callToAction = {
			let btn = UIButton()
			btn.setTitleColor(.white, for: .normal)
			btn.backgroundColor = Colors.customBlue
			btn.layer.cornerRadius = 10
			btn.translatesAutoresizingMaskIntoConstraints = false
			return btn
		}()
		
		price = {
			let lbl = UILabel()
			lbl.font = UIFont.systemFont(ofSize: 15)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		store = {
			let lbl = UILabel()
			lbl.font = UIFont.systemFont(ofSize: 15)
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		mediaView = {
			let view = GADMediaView()
			view.translatesAutoresizingMaskIntoConstraints = false
			return view
		}()
		
		adLabel = {
			let lbl = UILabel()
			lbl.text = "Ad"
			lbl.font = UIFont.systemFont(ofSize: 12)
			lbl.textColor = .white
			lbl.backgroundColor = .systemYellow
			lbl.textAlignment = .center
			lbl.translatesAutoresizingMaskIntoConstraints = false
			return lbl
		}()
		
		tappableOverlay = {
			let view = UIView()
			view.translatesAutoresizingMaskIntoConstraints = false
			view.isUserInteractionEnabled = true
			return view
		}()
	}
	
	private func configureConstraints() {
		contentView.addSubview(adView)
		adView.pinToEdges(of: contentView)
		
		adView.addSubviews(iconView, headline, advertiser, starRating, body, mediaView, price, store, callToAction, adLabel, tappableOverlay)
		
		NSLayoutConstraint.activate([
			iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			iconView.heightAnchor.constraint(equalToConstant: 75),
			iconView.widthAnchor.constraint(equalToConstant: 75),
			
			headline.topAnchor.constraint(equalTo: iconView.topAnchor),
			headline.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
			headline.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -10),
			headline.heightAnchor.constraint(equalToConstant: 24),
			
			advertiser.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 10),
			advertiser.leadingAnchor.constraint(equalTo: headline.leadingAnchor),
			advertiser.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -10),
			advertiser.heightAnchor.constraint(equalToConstant: 19),
			
			starRating.topAnchor.constraint(equalTo: advertiser.bottomAnchor, constant: 10),
			starRating.leadingAnchor.constraint(equalTo: headline.leadingAnchor),
			starRating.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -10),
			starRating.heightAnchor.constraint(equalToConstant: 22),
			
			body.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 20),
			body.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 10),
			body.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -10),
			body.heightAnchor.constraint(equalToConstant: 50),
			
			mediaView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 10),
			mediaView.leadingAnchor.constraint(equalTo: body.leadingAnchor),
			mediaView.trailingAnchor.constraint(equalTo: body.trailingAnchor),
			mediaView.heightAnchor.constraint(equalToConstant: 120),
			
			callToAction.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),
			callToAction.trailingAnchor.constraint(equalTo: body.trailingAnchor),
			callToAction.heightAnchor.constraint(equalToConstant: 25),
			callToAction.widthAnchor.constraint(equalToConstant: 100),
			
			store.centerYAnchor.constraint(equalTo: callToAction.centerYAnchor),
			store.trailingAnchor.constraint(equalTo: callToAction.leadingAnchor, constant: -5),
			store.widthAnchor.constraint(equalToConstant: 60),
			store.heightAnchor.constraint(equalToConstant: 25),
			
			price.centerYAnchor.constraint(equalTo: callToAction.centerYAnchor),
			price.trailingAnchor.constraint(equalTo: store.leadingAnchor, constant: -5),
			price.widthAnchor.constraint(equalToConstant: 60),
			price.heightAnchor.constraint(equalToConstant: 25),
			
			adLabel.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 10),
			adLabel.bottomAnchor.constraint(equalTo: adView.bottomAnchor, constant: -10),
			adLabel.heightAnchor.constraint(equalToConstant: 15),
			adLabel.widthAnchor.constraint(equalToConstant: 20)
		])
		
		tappableOverlay.pinToEdges(of: adView)
	}
	
	func set(ad: GADUnifiedNativeAd) {
		ad.register(self.contentView, clickableAssetViews: [GADUnifiedNativeAssetIdentifier.callToActionAsset : tappableOverlay], nonclickableAssetViews: [:])
		
		adView.nativeAd = ad
		
		headline.text = ad.headline
		price.text = ad.price
		body.text = ad.body
		advertiser.text = ad.advertiser
		mediaView.mediaContent = ad.mediaContent
		
		callToAction.isUserInteractionEnabled = false
		callToAction.setTitle(ad.callToAction, for: .normal)
		
		adView.callToActionView = tappableOverlay
		
		if let starRating = ad.starRating {
			self.starRating.text = starRating.description + "\u{2605}"
		} else {
		  starRating.text = nil
		}
		
		if let store = ad.store {
			self.store.text = store
		} else {
			self.store.text = nil
		}
		
		if let icon = (ad.icon)?.image {
			iconView.image = icon
		} else {
			iconView.isHidden = true
		}
	}
}

//
//  PointAnnotations.swift
//  carWash
//
//  Created by Juliett Kuroyan on 04.02.2020.
//  Copyright © 2020 VooDooLab. All rights reserved.
//

import MapKit

private let ClusterID = "ClusterAnnotationView"


// MARK: -  PinAnnotationView

@available(iOS 11.0, *)
class PinAnnotationView: MKAnnotationView {
    
    var label: UILabel!
    
    static let ReuseID = "PinAnnotationView"
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                configureSelectedMode()
//            } else {
//                configureDeselectedMode()
//            }
//        }
//    }
    
    override var annotation: MKAnnotation? {
        willSet { clusteringIdentifier = ClusterID }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        displayPriority = .defaultHigh
        image = UIImage(named: MapViewConstants.pinImageName)
        
        label = UILabel()

        label.textColor = .white
        label.font =  UIFont.systemFont(ofSize: 12, weight: .bold)
        label.tag = MapViewConstants.pinLabelTag
        subviews.forEach({ $0.removeFromSuperview() })
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    /// - Tag: DisplayConfiguration
    @available(iOS 11.0, *)
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let customPointAnnotation = annotation as? CustomPointAnnotation {
            label.text = customPointAnnotation.text
            label.sizeToFit()
            
            let x =  (frame.width - label.frame.width) / 2
            let y = MapViewConstants.pinYOrigin
            label.frame.origin = CGPoint(x: x, y: y)

        }
    }
    
}


//  MARK: - ClusterAnnotationView

@available(iOS 11.0, *)
class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        clusteringIdentifier = ClusterID
        centerOffset = CGPoint(x: 0, y: -10) // Offset center point to animate better with marker annotations
        displayPriority = .required
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - Tag: CustomCluster
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let totalCount = cluster.memberAnnotations.count
            
            image = UIImage(named: "clusterMapPin")
            let label = UILabel()
            
            label.textColor = .white
            label.text = "\(totalCount)"
            label.font =  UIFont.systemFont(ofSize: 12, weight: .bold)
            label.tag = MapViewConstants.pinLabelTag
            label.sizeToFit()
            
            let x =  (frame.width - label.frame.width) / 2
            let y = (frame.height - label.frame.height) / 2
            label.frame.origin = CGPoint(x: x, y: y)
            
            subviews.forEach({ $0.removeFromSuperview() })
            addSubview(label)
        }
    }
    
}

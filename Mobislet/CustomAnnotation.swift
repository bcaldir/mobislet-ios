//
//  CustomAnnotation.swift
//  Mobislet
//
//  Created by Ahmet KÖRÜK on 18/03/16.
//  Copyright © 2016 akoruk. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: MKPointAnnotation {
    
    var item: Mobitem?
    var imageNamed: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        super.init()
        self.coordinate = coordinate
    }
    
}

//
//  MapView.swift
//  MyApp
//
//  Created by Andre on 09/10/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    private let latitude: CLLocationDegrees
    private let longitude: CLLocationDegrees
    private let placeName: String

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeName: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
    }
    
    var body: some View {
        let localCoordenada = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let regiao = MKCoordinateRegion(
            center: localCoordenada,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) 
        )
        
        Map(initialPosition: .region(regiao)) {
            Marker(placeName, coordinate: localCoordenada)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

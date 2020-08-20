//
//  OverviewTab.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 31/07/2020.
//

import SwiftUI
import CoreLocation
import FGRoute

let locationManager = CLLocationManager()
let carrier = CellularData()

struct OverviewTab: View {
    @State var ipv4 = FGRoute.getIPAddress()
    @State var ssid = FGRoute.getSSID()
    @State var carrierInfo = carrier.carrierDetail
    @State var carrierRadioTechnologyRaw = carrier.carrierTechnology
    @State var timer: Timer?
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Wi-Fi")) {
                    if let safeSSID = ssid, let safeIPv4 = ipv4 {
                        WiFiSection(ssid: String(describing: safeSSID), wifiImage: "wifi", ipAddress: safeIPv4)
                    }
                    else {
                        WiFiSection(ssid: "SSID not available", wifiImage: "wifi.slash", ipAddress: "N/A")
                    }
                }
                
                Section(header: Text("Cellular Network")) {
                    if let safeCarrierInfo = carrierInfo, let safeCarrierRadio = carrierRadioTechnologyRaw {
                        CellularSection(carrier: String(describing: safeCarrierInfo.first?.value.carrierName ?? "Not available"), cellularImage: "antenna.radiowaves.left.and.right", radioTechnology: CellularRadioConstants.radioTechnology[safeCarrierRadio.first?.value ?? "N/A"] ?? "N/A")
                    }
                    else {
                        CellularSection(carrier: "Carrier not available", cellularImage: "antenna.radiowaves.left.and.right", radioTechnology: "Not available")
                    }
                }
                
                Section {
                    Banner()
                }
                
                Section(header: Text("Tools")) {
                    NavigationLink(destination: PingView()) {
                        Text("Ping")
                    }
                    NavigationLink(destination: WoLView()) {
                        Text("Wake on LAN")
                    }
                    NavigationLink(destination: WhoisView()) {
                        Text("Whois")
                    }
                    NavigationLink(destination: DNSLookupView()) {
                        Text("DNS Lookup")
                    }
//                    NavigationLink(destination: ScannerView()) {
//                        Text("LAN Scan")
//                    }
//                    NavigationLink(destination: TracerouteView()) {
//                        Text("Visual Traceroute")
//                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Overview")
        }
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                ssid = FGRoute.getSSID()
                ipv4 = FGRoute.getIPAddress()
                carrierInfo = carrier.carrierDetail
                carrierRadioTechnologyRaw = carrier.carrierTechnology
            })
        })
    }
}

struct OverviewTab_Previews: PreviewProvider {
    static var previews: some View {
        OverviewTab()
    }
}

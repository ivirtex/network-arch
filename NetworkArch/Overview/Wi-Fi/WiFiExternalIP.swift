//
//  WiFiExternalIP.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 02/08/2020.
//

import Foundation

let extIPv4URL = URL(string: "https://api.ipify.org")

func getExtIPv4() -> String? {
    do {
        if let url = extIPv4URL {
            let ipAddress = try String(contentsOf: url)
            return ipAddress
        }
    } catch {
        print(error)
    }
    return "N/A"
}

//
//  Network.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import Foundation

class Network {
    
    static func getNetworkResponse(data:Data?, response:URLResponse?, error:Error?) -> Void {
        print("Response: \(response as Any)\n")
        print("Error: \(error)\n")
        guard let data = data else { return }
        print(data, String(data: data, encoding: .utf8) ?? "*unknown encoding*")
    }
    
}

//
//  LoggerPlugin.swift
//  ProductsDisplay
//
//  Created by 9oya on 10/12/24.
//

import Foundation

import Moya

struct LoggerPlugin: PluginType {

    func willSend(_ request: any RequestType, target: any TargetType) {
        print("🌟 ## URL: \(request.request?.url?.absoluteString ?? "")")
        print("🌟 ## HEADERS")
        request.request?.headers.forEach { print("🌟 \($0.name) : \($0.value)") }

        if let body = request.request?.httpBody,
           let bodyStr = String(data: body, encoding: .utf8) {
            print("🌟 ## BODY")
            bodyStr.split(separator: "&").forEach { print("🌟 \($0)") }
        }
    }
}

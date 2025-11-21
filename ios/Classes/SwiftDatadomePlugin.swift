import Flutter
import UIKit
import DataDomeSDK

public class SwiftDatadomePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "datadome", binaryMessenger: registrar.messenger())
        let instance = SwiftDatadomePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("function called \(call.method)")
        guard call.method == "request" else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        guard let params = call.arguments as? [String: Any] else {
            //mal-formatted args, bail out
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Arguments are mal-formatted in the invoke",
                                details: nil))
            return
        }
        
        guard let method = params["method"] as? String else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Method argument should be of type String",
                                details: nil))
            return
        }
        
        guard let url = params["url"] as? String else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "URL argument should be of type String",
                                details: nil))
            return
        }
        
        var headers: [String: String] = [:]
        if let providedHeaders = params["headers"] as? [String: String] {
            headers = providedHeaders
        }
        
        let data = data(from: params["body"]);
        request(method: method.uppercased(), url: url, headers: headers, data: data, result: result)
    }
    
    private func data(from object: Any?) -> Data? {
        guard let input = object else {
            return nil
        }
        
        if input is Data {
            return input as? Data
        }
        
        if let input = input as? FlutterStandardTypedData {
            return input.data
        }
        
        if input is Dictionary<String, Any> || input is Array<Any> {
            return try? JSONSerialization.data(withJSONObject: input, options: [])
        }
        
        return nil
    }
    
    private func request(method: String,
                         url: String,
                         headers: [String: String],
                         data: Data?,
                         result: @escaping FlutterResult) {
        
        guard let requestURL = URL(string: url) else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Invalid provided URL",
                                details: nil))
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = data
        URLSession.shared.protectedDataTask(withRequest: request, captchaDelegate: nil) { (data, response, error) in
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse {
                    let statusCode = NSNumber(value: response.statusCode)
                    var headers: [String: String] = [:]
                    for (key, value) in response.allHeaderFields {
                        headers[String(describing: key)] = String(describing: value)
                    }
                    
                    if let data = data {
                        let bytes = FlutterStandardTypedData(bytes: data)
                        result(["code": statusCode, "headers": headers, "data": bytes])
                    } else {
                        result(["code": statusCode, "headers": headers, "data": nil])
                    }
                } else {
                    result(["code": 0, "headers": [:], "data": nil])
                }
            }
        }.resume()
    }
}

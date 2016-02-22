import Foundation

class Logger{
    class func log(message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) {
            var filename = file
            if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch) {
                filename = filename.substringWithRange(match)
            }
            print("\(NSDate().timeIntervalSince1970):\(filename):L\(line):\(function) \"\(message)\"")
    }
}

import Foundation

extension Data {
    init(hex text: String) {
        var text = text
        var data = Data()
        while(text.characters.count > 0) {
            let c: String = String(text[..<text.index(text.startIndex, offsetBy: 2)])
            text = String(text[text.index(text.startIndex, offsetBy: 2)...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        self = data
    }
}

import Foundation

extension String {
    func checkForSpecialSymbols() -> Bool {
        self.range(of: "^[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+", options: .regularExpression) != nil
    }
}

import Foundation

struct Address {
    let street, city, zipCode, country: String
    var formattedAddress: String {
        "\(street)\n\(city), \(zipCode)\n\(country)"
    }
}

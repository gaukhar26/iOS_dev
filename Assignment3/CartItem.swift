import Foundation

struct CartItem {
    let product: Product
    private(set) var quantity: Int

    var subtotal: Double { product.price * Double(quantity) }

    mutating func updateQuantity(_ newQuantity: Int) {
        guard newQuantity > 0 else { return }
        quantity = newQuantity
    }

    mutating func increaseQuantity(by amount: Int) {
        guard amount > 0 else { return }
        quantity += amount
    }
}

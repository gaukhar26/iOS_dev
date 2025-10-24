import Foundation

final class ShoppingCart {
    private(set) var items: [CartItem] = []
    var discountCode: String?

    func addItem(product: Product, quantity: Int = 1) {
        if let i = items.firstIndex(where: { $0.product.id == product.id }) {
            items[i].increaseQuantity(by: quantity)
        } else {
            items.append(CartItem(product: product, quantity: quantity))
        }
    }

    func removeItem(productId: String) {
        items.removeAll { $0.product.id == productId }
    }

    func updateItemQuantity(productId: String, quantity: Int) {
        if let i = items.firstIndex(where: { $0.product.id == productId }) {
            if quantity == 0 { removeItem(productId: productId) }
            else { items[i].updateQuantity(quantity) }
        }
    }

    func clearCart() { items.removeAll() }

    var subtotal: Double { items.reduce(0) { $0 + $1.subtotal } }
    var discountAmount: Double {
        switch discountCode {
        case "SAVE10": return subtotal * 0.1
        case "SAVE20": return subtotal * 0.2
        default: return 0
        }
    }
    var total: Double { subtotal - discountAmount }
    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }
    var isEmpty: Bool { items.isEmpty }
}

import Foundation  

struct Order {
    let orderId: String
    let items: [CartItem]
    let subtotal, discountAmount, total: Double
    let timestamp: Date
    let shippingAddress: Address

    init(from cart: ShoppingCart, shippingAddress: Address) {
        self.orderId = UUID().uuidString
        self.items = cart.items
        self.subtotal = cart.subtotal
        self.discountAmount = cart.discountAmount
        self.total = cart.total
        self.timestamp = Date()
        self.shippingAddress = shippingAddress
    }

    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }
}

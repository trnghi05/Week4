//
//  Appstore.swift
//  FishStore
//
//  Created by MAY 04 on 8/10/26.
//

import SwiftUI
import Combine

class AppStore: ObservableObject {
    // MARK: - Catalog (read from category.txt and fish.txt)
    @Published var categories: [ProductCategory] = []
    @Published var products: [Product] = []

    // MARK: - User data (each property saves itself automatically)
    @Published var cartItems: [CartItem] = [] {
        didSet { save(cartItems, key: "cartItems") }
    }
    @Published var orders: [Order] = [] {
        didSet { save(orders, key: "orders") }
    }
    @Published var favoriteIDs: Set<String> = [] {
        didSet { save(favoriteIDs, key: "favoriteIDs") }
    }
    @Published var customerName = "" {
        didSet { UserDefaults.standard.set(customerName, forKey: "customerName") }
    }
    @Published var customerPhone = "" {
        didSet { UserDefaults.standard.set(customerPhone, forKey: "customerPhone") }
    }
    @Published var deliveryAddress = "" {
        didSet { UserDefaults.standard.set(deliveryAddress, forKey: "deliveryAddress") }
    }

    // MARK: - Store info
    let storeName = "Pretty Fish Store"
    let storeAddress = "Landmark 81, 720A Dien Bien Phu, Binh Thanh, Ho Chi Minh City"
    let storePhone = "0999 999 999"
    let storeHours = "8:00 - 21:00, every day"

    // Bank transfer info (shown with the payment QR)
    let bankName = "Vietcombank"
    let accountName = "HUYNH THAI HOA"
    let accountNumber = "1032620112"

    let baseShippingFee: Double = 30_000
    let freeShippingThreshold: Double = 500_000

    init() {
        loadCatalog()
        cartItems = load([CartItem].self, key: "cartItems") ?? []
        orders = load([Order].self, key: "orders") ?? []
        favoriteIDs = load(Set<String>.self, key: "favoriteIDs") ?? []

        let defaults = UserDefaults.standard
        customerName = defaults.string(forKey: "customerName") ?? ""
        customerPhone = defaults.string(forKey: "customerPhone") ?? ""
        deliveryAddress = defaults.string(forKey: "deliveryAddress") ?? ""
    }

    // MARK: - Saving and loading user data

    private func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func resetUserData() {
        cartItems = []
        orders = []
        favoriteIDs = []
        customerName = ""
        customerPhone = ""
        deliveryAddress = ""
    }

    // MARK: - Catalog from text files

    // Reads category.txt first, then fish.txt, and rebuilds the lists shown on screen
    func loadCatalog() {
        print("Data files folder:", DataFiles.documentsURL.path)

        // category.txt  ->  id, "name", icon
        categories = DataFiles.readLines(DataFiles.categoryFile).compactMap { line -> ProductCategory? in
            let f = DataFiles.parseFields(line)
            guard f.count >= 2 else { return nil }
            let icon = (f.count > 2 && !f[2].isEmpty) ? f[2] : "tag.fill"
            return ProductCategory(id: f[0], name: f[1], iconName: icon)
        }

        // fish.txt  ->  id, "name", categoryId, price, stock, "description", oldPrice, rating, "careTip"
        products = DataFiles.readLines(DataFiles.fishFile).compactMap { line -> Product? in
            let f = DataFiles.parseFields(line)
            guard f.count >= 5,
                  let price = Double(f[3]),
                  let stock = Int(f[4]) else { return nil }

            let categoryId = f[2]
            let icon = categories.first(where: { $0.id == categoryId })?.iconName ?? "drop.fill"
            let oldPrice = f.count > 6 ? Double(f[6]) : nil
            let rating = f.count > 7 ? (Double(f[7]) ?? 4.5) : 4.5

            return Product(id: f[0],
                           name: f[1],
                           categoryId: categoryId,
                           description: f.count > 5 ? f[5] : "",
                           price: price,
                           oldPrice: (oldPrice ?? 0) > 0 ? oldPrice : nil,
                           imageName: icon,
                           stock: stock,
                           rating: rating,
                           careTip: f.count > 8 ? f[8] : "")
        }
    }

    // Adds a new line to fish.txt, then reads the file again so the screen matches the file
    func addFish(name: String,
                 categoryId: String,
                 price: Double,
                 stock: Int,
                 description: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanName.isEmpty else { return }

        let line = [makeID(from: cleanName),
                    DataFiles.quote(cleanName),
                    categoryId,
                    String(Int(price)),
                    String(stock),
                    DataFiles.quote(description),
                    "0",
                    "4.5",
                    DataFiles.quote("")]
            .joined(separator: ", ")

        DataFiles.append(line, to: DataFiles.fishFile)
        loadCatalog()
    }

    // Brings back the original category.txt and fish.txt from the project
    func restoreDefaultCatalog() {
        DataFiles.restoreFromBundle(DataFiles.categoryFile)
        DataFiles.restoreFromBundle(DataFiles.fishFile)
        loadCatalog()
    }

    // "Cá bảy màu" -> "ca-bay-mau" (made unique if it already exists)
    private func makeID(from name: String) -> String {
        let folded = name.lowercased()
            .replacingOccurrences(of: "đ", with: "d")
            .folding(options: .diacriticInsensitive, locale: .current)

        var slug = folded
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
        if slug.isEmpty { slug = "fish" }

        var candidate = slug
        var number = 2
        while products.contains(where: { $0.id == candidate }) {
            candidate = "\(slug)-\(number)"
            number += 1
        }
        return candidate
    }

    // MARK: - Products

    func filteredProducts(for destination: ProductListDestination) -> [Product] {
        products.filter { product in
            (destination.categoryId == nil || product.categoryId == destination.categoryId)
            && (!destination.onSaleOnly || product.oldPrice != nil)
        }
    }

    // MARK: - Favorites

    var favoriteProducts: [Product] {
        products.filter { favoriteIDs.contains($0.id) }
    }

    func isFavorite(_ product: Product) -> Bool {
        favoriteIDs.contains(product.id)
    }

    func toggleFavorite(_ product: Product) {
        if favoriteIDs.contains(product.id) {
            favoriteIDs.remove(product.id)
        } else {
            favoriteIDs.insert(product.id)
        }
    }

    // MARK: - Cart

    var cartCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    var cartSubtotal: Double {
        cartItems.reduce(0) { $0 + $1.total }
    }

    var shippingFee: Double {
        if cartItems.isEmpty || cartSubtotal >= freeShippingThreshold {
            return 0
        }
        return baseShippingFee
    }

    var cartTotal: Double {
        cartSubtotal + shippingFee
    }

    func quantityInCart(of product: Product) -> Int {
        cartItems.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }

    // Never lets the cart go above the stock
    func addToCart(_ product: Product, quantity: Int = 1) {
        let allowed = min(quantity, product.stock - quantityInCart(of: product))
        guard allowed > 0 else { return }

        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += allowed
        } else {
            cartItems.append(CartItem(product: product, quantity: allowed))
        }
    }

    func changeQuantity(of item: CartItem, by amount: Int) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        let newQuantity = cartItems[index].quantity + amount

        if newQuantity <= 0 {
            cartItems.remove(at: index)
        } else if newQuantity <= item.product.stock {
            cartItems[index].quantity = newQuantity
        }
    }

    func removeItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }

    // MARK: - Orders

    func placeOrder(customerName: String,
                    phone: String,
                    address: String,
                    payment: PaymentMethod,
                    note: String) {
        guard !cartItems.isEmpty else { return }

        let order = Order(customerName: customerName,
                          phone: phone,
                          address: address,
                          items: cartItems,
                          orderDate: Date(),
                          status: .pending,
                          shippingFee: shippingFee,
                          paymentMethod: payment,
                          note: note)
        orders.insert(order, at: 0)
        cartItems.removeAll()
    }

    func cancelOrder(_ order: Order) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        orders[index].status = .cancelled
    }

    
    func advanceStatus(of order: Order) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        switch orders[index].status {
        case .pending: orders[index].status = .preparing
        case .preparing: orders[index].status = .shipping
        case .shipping: orders[index].status = .delivered
        default: break
        }
    }
}

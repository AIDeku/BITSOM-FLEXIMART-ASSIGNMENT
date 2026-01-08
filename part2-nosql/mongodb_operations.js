// MongoDB Operations for FlexiMart Product Catalog
// Student: Aditya Singh

// --- Operation 1: Load Data ---
// In a real terminal, I would run:
// mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray
print("Step 1: Data should be loaded using mongoimport or Compass.");

// --- Operation 2: Basic Query ---
// Find all Electronics with price < 50000. 
// Returning only name, price, and stock to keep the output clean.
print("\n--- Querying Electronics under 50,000 ---");
db.products.find(
    { category: "Electronics", price: { $lt: 50000 } },
    { name: 1, price: 1, stock: 1, _id: 0 }
).forEach(printjson);

// --- Operation 3: Review Analysis ---
// I need to calculate the average rating from the nested 'reviews' array.
// First I 'unwind' the array to treat each review as a single document.
print("\n--- Products with Avg Rating >= 4.0 ---");
db.products.aggregate([
    { $unwind: "$reviews" },
    {
        $group: {
            _id: "$product_id",
            name: { $first: "$name" },
            avgRating: { $avg: "$reviews.rating" }
        }
    },
    { $match: { avgRating: { $gte: 4.0 } } },
    { $project: { _id: 0, product_id: "$_id", name: 1, avgRating: 1 } }
]).forEach(printjson);

// --- Operation 4: Update Operation ---
// Adding a new customer review to product ELEC001.
// Using $push to add to the end of the existing reviews array.
print("\n--- Adding new review to product ELEC001 ---");
db.products.updateOne(
    { product_id: "ELEC001" },
    {
        $push: {
            reviews: {
                user: "U999",
                rating: 4,
                comment: "Good value",
                date: new Date()
            }
        }
    }
);

// --- Operation 5: Complex Aggregation ---
// Calculating stats per category: Average price and count.
// Sorting by avg_price DESC to show most expensive categories first.
print("\n--- Category Pricing Summary ---");
db.products.aggregate([
    {
        $group: {
            _id: "$category",
            avg_price: { $avg: "$price" },
            product_count: { $sum: 1 }
        }
    },
    {
        $project: {
            _id: 0,
            category: "$_id",
            avg_price: 1,
            product_count: 1
        }
    },
    { $sort: { avg_price: -1 } }
]).forEach(printjson);

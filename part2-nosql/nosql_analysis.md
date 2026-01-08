# NoSQL Database Analysis: MongoDB for FlexiMart

## Section A: Limitations of RDBMS (approx. 150 words)

The traditional relational database management system (RDBMS) like MySQL or PostgreSQL, while excellent for structured transactions, faces significant hurdles when managing a modern, diverse e-commerce catalog. One primary issue is **schema rigidity**. In a relational world, every product must fit into a predefined set of columns. If we sell laptops with "RAM" and "Processor" attributes alongside shoes that have "Size" and "Color," we end up with a sparse table full of NULL values or a complex "Entity-Attribute-Value" (EAV) model that is slow to query.

Furthermore, **schema evolution** in RDBMS is painful. Adding a new product type requires a `ALTER TABLE` command, which can lock the database and cause downtime for large datasets. Lastly, storing **hierarchical data** like customer reviews is inefficient. In MySQL, reviews must live in a separate table, requiring expensive JOIN operations every time we want to display a product page. This overhead significantly hampers the speed and scalability needed for a responsive user experience in high-traffic e-commerce environments.

## Section B: NoSQL Benefits (approx. 150 words)

MongoDB addresses these relational bottlenecks through its **document-oriented model**. By using JSON-like BSON documents, MongoDB allows for a **flexible schema**. Each product document can contain unique attributes relevant only to that item; a laptop document stores hardware specs, while a clothing document stores fabric types, all within the same "products" collection. This eliminates the NULL-value problem and the need for complex table joins.

Another major advantage is the use of **embedded documents**. We can store customer reviews directly inside the product document as an array. This ensures that a single read operation retrieves all the data needed for a product detail page, dramatically improving performance. Additionally, MongoDB is built for **horizontal scalability** through sharding. As FlexiMart's catalog grows from thousands to millions of products, MongoDB can distribute data across multiple servers easily. This "scale-out" approach is far simpler and more cost-effective than the traditional "scale-up" approach required by most relational databases.

## Section C: Trade-offs (approx. 100 words)

While MongoDB offers great flexibility, it comes with specific trade-offs compared to MySQL. First is the **lack of complex multi-document JOINs**. While MongoDB has `$lookup`, it is not as efficient as relational SQL joins for complex reports, often requiring data to be duplicated or processed in the application layer. Second is the **increased storage overhead**. Because each document stores its own field names (keys), and data is often denormalized/duplicated to avoid joins, MongoDB typically consumes more disk space than a highly normalized relational database. This makes data consistency harder to manage, as an update to a shared attribute might need to be replicated across many documents manually.

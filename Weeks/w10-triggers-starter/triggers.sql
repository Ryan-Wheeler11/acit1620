--Automatically updating stock when an order is placed
CREATE TRIGGER reduce_stock_after_order
AFTER INSERT ON "Order_Items"
FOR EACH ROW
BEGIN
    UPDATE "Products"
    SET "stock_quantity" = "stock_quantity" - NEW."quantity"
    WHERE "product_id" = NEW."product_id";
END;
-- Fires after inserting a row in Order_Items
-- Subtracts the order quanitity from Products.stock_quantity
-- Ensures inventory is automatically updated

-- 2. Preventing purchases if stock is too low
CREATE TRIGGER prevent_out_of_stock_orders
BEFORE INSERT ON "Order_Items"
FOR EACH ROW 
BEGIN   
    SELECT CASE
    WHEN (SELECT "stock_quantity" FROM "Products" WHERE 
    "product_id" = NEW."product_id") < NEW."quantity"
    THEN RAISE(ABORT, 'Not enough stock available')
END;
-- Stops an order if the stock is too low
-- fires BEFORE inserting an order time
-- If the requested quantity exceeds available stock, it block the transaction
-- Prevents Overselling

-- Try inserting a new row in the Order_Items
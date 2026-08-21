import Data.Functor.Identity (Identity, runIdentity)

class Discount m where
  discountAmount :: Int -> m Int

class Shipping m where
  shippingFee :: Int -> m Int

calculateTotal :: (Monad m, Discount m, Shipping m) => Int -> m Int
calculateTotal subtotal = do
  discount <- discountAmount subtotal
  shipping <- shippingFee subtotal
  pure (subtotal - discount + shipping)

instance Discount Identity where
  discountAmount subtotal = pure (subtotal `div` 10)

instance Shipping Identity where
  shippingFee subtotal = pure (if subtotal >= 5000 then 0 else 500)

main :: IO ()
main = print (runIdentity (calculateTotal 3000))

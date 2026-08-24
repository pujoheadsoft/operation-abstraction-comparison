{-# LANGUAGE LambdaCase #-}
import Control.Monad.Freer

data Discount a where
  DiscountAmount :: Int -> Discount Int

data Shipping a where
  ShippingFee :: Int -> Shipping Int

discountAmount :: Member Discount effects => Int -> Eff effects Int
discountAmount subtotal = send (DiscountAmount subtotal)

shippingFee :: Member Shipping effects => Int -> Eff effects Int
shippingFee subtotal = send (ShippingFee subtotal)

calculateTotal :: (Member Discount effects, Member Shipping effects) => Int -> Eff effects Int
calculateTotal subtotal = do
  discount <- discountAmount subtotal
  shipping <- shippingFee subtotal
  pure (subtotal - discount + shipping)

handleDiscount :: Eff (Discount ': effects) a -> Eff effects a
handleDiscount = interpret $ \case
  DiscountAmount subtotal -> pure (subtotal `div` 10)

handleShipping :: Eff (Shipping ': effects) a -> Eff effects a
handleShipping = interpret $ \case
  ShippingFee subtotal -> pure (if subtotal >= 5000 then 0 else 500)

main :: IO ()
main =
  print
    . run
    . handleShipping
    . handleDiscount
    $ calculateTotal 3000

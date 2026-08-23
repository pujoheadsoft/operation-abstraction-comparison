module Main (result) where

import Prelude

import Control.Monad.Free (Free, foldFree, liftF)
import Data.Identity (Identity(..))

data DiscountInstruction a
  = DiscountAmount Int (Int -> a)

data ShippingInstruction a
  = ShippingFee Int (Int -> a)

data PricingInstruction a
  = Discount (DiscountInstruction a)
  | Shipping (ShippingInstruction a)

discountAmount :: Int -> Free PricingInstruction Int
discountAmount subtotal =
  liftF (Discount (DiscountAmount subtotal identity))

shippingFee :: Int -> Free PricingInstruction Int
shippingFee subtotal =
  liftF (Shipping (ShippingFee subtotal identity))

calculateTotal :: Int -> Free PricingInstruction Int
calculateTotal subtotal = do
  discount <- discountAmount subtotal
  shipping <- shippingFee subtotal
  pure (subtotal - discount + shipping)

runInstruction :: forall a. PricingInstruction a -> Identity a
runInstruction (Discount (DiscountAmount subtotal reply)) =
  Identity (reply (subtotal / 10))
runInstruction (Shipping (ShippingFee subtotal reply)) =
  Identity (reply (if subtotal >= 5000 then 0 else 500))

runPricing :: forall a. Free PricingInstruction a -> a
runPricing program = case foldFree runInstruction program of
  Identity value -> value

result :: Int
result = runPricing (calculateTotal 3000)

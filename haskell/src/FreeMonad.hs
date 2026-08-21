import Control.Monad.Free (Free, iterM, liftF)
import Data.Functor.Identity (Identity, runIdentity)

data DiscountInstruction next
  = DiscountAmount Int (Int -> next)

instance Functor DiscountInstruction where
  fmap f (DiscountAmount subtotal continue) = DiscountAmount subtotal (f . continue)

data ShippingInstruction next
  = ShippingFee Int (Int -> next)

instance Functor ShippingInstruction where
  fmap f (ShippingFee subtotal continue) = ShippingFee subtotal (f . continue)

data PricingInstruction next
  = Discount (DiscountInstruction next)
  | Shipping (ShippingInstruction next)

instance Functor PricingInstruction where
  fmap f (Discount instruction) = Discount (fmap f instruction)
  fmap f (Shipping instruction) = Shipping (fmap f instruction)

discountAmount :: Int -> Free PricingInstruction Int
discountAmount subtotal = liftF (Discount (DiscountAmount subtotal id))

shippingFee :: Int -> Free PricingInstruction Int
shippingFee subtotal = liftF (Shipping (ShippingFee subtotal id))

calculateTotal :: Int -> Free PricingInstruction Int
calculateTotal subtotal = do
  discount <- discountAmount subtotal
  shipping <- shippingFee subtotal
  pure (subtotal - discount + shipping)

runPricing :: Free PricingInstruction a -> Identity a
runPricing = iterM runInstruction
  where
    runInstruction (Discount (DiscountAmount subtotal continue)) =
      continue (subtotal `div` 10)
    runInstruction (Shipping (ShippingFee subtotal continue)) =
      continue (if subtotal >= 5000 then 0 else 500)

main :: IO ()
main = print (runIdentity (runPricing (calculateTotal 3000)))

import Data.Functor.Identity (Identity, runIdentity)

class ManufacturingCost m where
  materialCost :: Int -> m Int
  assemblyCost :: Int -> m Int

class PackagingCost m where
  packagingCost :: Int -> m Int

calculateTotalCost :: (Monad m, ManufacturingCost m, PackagingCost m) => Int -> m Int
calculateTotalCost quantity = do
  material <- materialCost quantity
  assembly <- assemblyCost quantity
  packaging <- packagingCost quantity
  pure (material + assembly + packaging)

instance ManufacturingCost Identity where
  materialCost quantity = pure (quantity * 100)
  assemblyCost quantity = pure (quantity * 50)

instance PackagingCost Identity where
  packagingCost quantity = pure (quantity * 20)

main :: IO ()
main = print . runIdentity $ calculateTotalCost 10

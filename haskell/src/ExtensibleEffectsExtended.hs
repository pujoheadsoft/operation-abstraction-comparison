{-# LANGUAGE LambdaCase #-}
import Control.Monad.Freer

data ManufacturingCost a where
  MaterialCost :: Int -> ManufacturingCost Int
  AssemblyCost :: Int -> ManufacturingCost Int

data PackagingCost a where
  PackagingCost :: Int -> PackagingCost Int

materialCost :: Member ManufacturingCost effects => Int -> Eff effects Int
materialCost quantity = send (MaterialCost quantity)

assemblyCost :: Member ManufacturingCost effects => Int -> Eff effects Int
assemblyCost quantity = send (AssemblyCost quantity)

packagingCost :: Member PackagingCost effects => Int -> Eff effects Int
packagingCost quantity = send (PackagingCost quantity)

calculateTotalCost :: (Member ManufacturingCost effects, Member PackagingCost effects) => Int -> Eff effects Int
calculateTotalCost quantity = do
  material <- materialCost quantity
  assembly <- assemblyCost quantity
  packaging <- packagingCost quantity
  pure (material + assembly + packaging)

handleManufacturingCost :: Eff (ManufacturingCost ': effects) a -> Eff effects a
handleManufacturingCost = interpret $ \case
  MaterialCost quantity -> pure (quantity * 100)
  AssemblyCost quantity -> pure (quantity * 50)

handlePackagingCost :: Eff (PackagingCost ': effects) a -> Eff effects a
handlePackagingCost = interpret $ \case
  PackagingCost quantity -> pure (quantity * 20)

main :: IO ()
main =
  print
    . run
    . handlePackagingCost
    . handleManufacturingCost
    $ calculateTotalCost 10

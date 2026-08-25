module Extended (result) where

import Prelude

import Control.Monad.Free (Free, foldFree, liftF)
import Data.Identity (Identity(..))

data ManufacturingCostInstruction a
  = MaterialCost Int (Int -> a)
  | AssemblyCost Int (Int -> a)

data PackagingCostInstruction a
  = PackagingCost Int (Int -> a)

data CostInstruction a
  = ManufacturingCost (ManufacturingCostInstruction a)
  | Packaging (PackagingCostInstruction a)

materialCost :: Int -> Free CostInstruction Int
materialCost quantity =
  liftF (ManufacturingCost (MaterialCost quantity identity))

assemblyCost :: Int -> Free CostInstruction Int
assemblyCost quantity =
  liftF (ManufacturingCost (AssemblyCost quantity identity))

packagingCost :: Int -> Free CostInstruction Int
packagingCost quantity =
  liftF (Packaging (PackagingCost quantity identity))

calculateTotalCost :: Int -> Free CostInstruction Int
calculateTotalCost quantity = do
  material <- materialCost quantity
  assembly <- assemblyCost quantity
  packaging <- packagingCost quantity
  pure (material + assembly + packaging)

runInstruction :: forall a. CostInstruction a -> Identity a
runInstruction (ManufacturingCost (MaterialCost quantity reply)) =
  Identity (reply (quantity * 100))
runInstruction (ManufacturingCost (AssemblyCost quantity reply)) =
  Identity (reply (quantity * 50))
runInstruction (Packaging (PackagingCost quantity reply)) =
  Identity (reply (quantity * 20))

runCost :: forall a. Free CostInstruction a -> a
runCost program = case foldFree runInstruction program of
  Identity value -> value

result :: Int
result = runCost $ calculateTotalCost 10

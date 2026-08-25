module Basic (result) where

import Prelude

import Control.Monad.Free (Free, foldFree, liftF)
import Data.Identity (Identity(..))

data ManufacturingCostInstruction a
  = MaterialCost Int (Int -> a)
  | AssemblyCost Int (Int -> a)

materialCost :: Int -> Free ManufacturingCostInstruction Int
materialCost quantity =
  liftF (MaterialCost quantity identity)

assemblyCost :: Int -> Free ManufacturingCostInstruction Int
assemblyCost quantity =
  liftF (AssemblyCost quantity identity)

calculateTotalCost :: Int -> Free ManufacturingCostInstruction Int
calculateTotalCost quantity = do
  material <- materialCost quantity
  assembly <- assemblyCost quantity
  pure (material + assembly)

runInstruction :: forall a. ManufacturingCostInstruction a -> Identity a
runInstruction (MaterialCost quantity reply) =
  Identity (reply (quantity * 100))
runInstruction (AssemblyCost quantity reply) =
  Identity (reply (quantity * 50))

runCost :: forall a. Free ManufacturingCostInstruction a -> a
runCost program = case foldFree runInstruction program of
  Identity value -> value

result :: Int
result = runCost $ calculateTotalCost 10

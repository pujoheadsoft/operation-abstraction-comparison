import Control.Monad.Freer

data NameEffect a where
  LookupName :: Int -> NameEffect String

data LogEffect a where
  RecordGreeting :: String -> LogEffect ()

lookupName :: Member NameEffect effects => Int -> Eff effects String
lookupName userId = send (LookupName userId)

recordGreeting :: Member LogEffect effects => String -> Eff effects ()
recordGreeting name = send (RecordGreeting name)

greet :: (Member NameEffect effects, Member LogEffect effects) => Int -> Eff effects String
greet userId = do
  name <- lookupName userId
  recordGreeting name
  pure ("Hello, " ++ name ++ "!")

handleNames :: Eff (NameEffect ': effects) a -> Eff effects a
handleNames = interpret $ \case
  LookupName userId -> pure (if userId == 1 then "Ada" else "Unknown")

handleLogs :: Eff '[LogEffect, IO] a -> Eff '[IO] a
handleLogs = interpretM runLog
  where
    runLog :: LogEffect value -> IO value
    runLog (RecordGreeting name) = putStrLn ("log: greeted " ++ name)

program :: Eff '[NameEffect, LogEffect, IO] String
program = greet 1

main :: IO ()
main = runM (handleLogs (handleNames program)) >>= putStrLn


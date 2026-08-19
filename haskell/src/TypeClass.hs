class Monad m => NameLookup m where
  lookupName :: Int -> m String

class Monad m => GreetingRecorder m where
  recordGreeting :: String -> m ()

greet :: (NameLookup m, GreetingRecorder m) => Int -> m String
greet userId = do
  name <- lookupName userId
  recordGreeting name
  pure ("Hello, " ++ name ++ "!")

instance NameLookup IO where
  lookupName userId = pure (if userId == 1 then "Ada" else "Unknown")

instance GreetingRecorder IO where
  recordGreeting name = putStrLn ("log: greeted " ++ name)

main :: IO ()
main = greet 1 >>= putStrLn


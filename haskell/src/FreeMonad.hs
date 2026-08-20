import Control.Monad.Free (Free, iterM, liftF)

data NameInstruction next
  = LookupName Int (String -> next)

instance Functor NameInstruction where
  fmap f (LookupName userId continue) = LookupName userId (f . continue)

data LogInstruction next
  = RecordGreeting String next

instance Functor LogInstruction where
  fmap f (RecordGreeting name next) = RecordGreeting name (f next)

data GreetingInstruction next
  = Name (NameInstruction next)
  | Log (LogInstruction next)

instance Functor GreetingInstruction where
  fmap f (Name instruction) = Name (fmap f instruction)
  fmap f (Log instruction) = Log (fmap f instruction)

lookupName :: Int -> Free GreetingInstruction String
lookupName userId = liftF (Name (LookupName userId id))

recordGreeting :: String -> Free GreetingInstruction ()
recordGreeting name = liftF (Log (RecordGreeting name ()))

greet :: Int -> Free GreetingInstruction String
greet userId = do
  name <- lookupName userId
  recordGreeting name
  pure ("Hello, " ++ name ++ "!")

runConsole :: Free GreetingInstruction a -> IO a
runConsole = iterM runInstruction
  where
    runInstruction (Name (LookupName userId continue)) =
      continue (if userId == 1 then "Ada" else "Unknown")
    runInstruction (Log (RecordGreeting name next)) = do
      putStrLn ("log: greeted " ++ name)
      next

main :: IO ()
main = runConsole (greet 1) >>= putStrLn

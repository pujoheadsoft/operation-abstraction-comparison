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

data Free instruction a
  = Pure a
  | Suspend (instruction (Free instruction a))

instance Functor instruction => Functor (Free instruction) where
  fmap f (Pure value) = Pure (f value)
  fmap f (Suspend instruction) = Suspend (fmap (fmap f) instruction)

instance Functor instruction => Applicative (Free instruction) where
  pure = Pure
  Pure f <*> value = fmap f value
  Suspend instruction <*> value = Suspend (fmap (<*> value) instruction)

instance Functor instruction => Monad (Free instruction) where
  Pure value >>= continue = continue value
  Suspend instruction >>= continue = Suspend (fmap (>>= continue) instruction)

liftInstruction :: Functor instruction => instruction a -> Free instruction a
liftInstruction instruction = Suspend (fmap Pure instruction)

lookupName :: Int -> Free GreetingInstruction String
lookupName userId = liftInstruction (Name (LookupName userId id))

recordGreeting :: String -> Free GreetingInstruction ()
recordGreeting name = liftInstruction (Log (RecordGreeting name ()))

greet :: Int -> Free GreetingInstruction String
greet userId = do
  name <- lookupName userId
  recordGreeting name
  pure ("Hello, " ++ name ++ "!")

runConsole :: Free GreetingInstruction a -> IO a
runConsole (Pure value) = pure value
runConsole (Suspend (Name (LookupName userId continue))) =
  runConsole (continue (if userId == 1 then "Ada" else "Unknown"))
runConsole (Suspend (Log (RecordGreeting name next))) = do
  putStrLn ("log: greeted " ++ name)
  runConsole next

main :: IO ()
main = runConsole (greet 1) >>= putStrLn


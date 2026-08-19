package operationabstraction.scalaexample

trait NameLookup:
  def lookupName(userId: Int): String

trait GreetingRecorder:
  def recordGreeting(name: String): Unit

def greet(lookup: NameLookup, recorder: GreetingRecorder, userId: Int): String =
  val name = lookup.lookupName(userId)
  recorder.recordGreeting(name)
  s"Hello, $name!"

object ConsoleNameLookup extends NameLookup:
  def lookupName(userId: Int): String =
    if userId == 1 then "Ada" else "Unknown"

object ConsoleGreetingRecorder extends GreetingRecorder:
  def recordGreeting(name: String): Unit =
    println(s"log: greeted $name")

object Main:
  def main(args: Array[String]): Unit =
    println(greet(ConsoleNameLookup, ConsoleGreetingRecorder, 1))


ThisBuild / scalaVersion := "3.8.4"

lazy val root = (project in file("."))
  .settings(
    name := "interface-implementation-scala",
    Compile / run / mainClass := Some("operationabstraction.scalaexample.Main")
  )


lazy val root = (project in file("."))
  .settings(
    organization := "",
    name := "my-scala",
    version := "1.0.0",
    scalaVersion := "3.3.3",
    assembly / assemblyMergeStrategy := {
      case "module-info.class" => MergeStrategy.discard
      case x => (assembly / assemblyMergeStrategy).value.apply(x)
    }
  )
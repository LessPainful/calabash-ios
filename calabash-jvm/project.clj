(defproject calabash-jvm "1.0.0-SNAPSHOT"
  :description "JVM client for calabash-ios-server for automated iOS functional testing"
  :dependencies [[org.clojure/clojure "1.3.0"]
                 [http.async.client "0.4.0-SNAPSHOT"]]
  :dev-dependencies [[swank-clojure "1.4.0-SNAPSHOT"]
                     [clojure-source "1.3.0"]]
  :jvm-opts ["-agentlib:jdwp=transport=dt_socket,server=y,suspend=n"])

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

object FrontOfficeCrawlSimulation {
  val httpBaseUrlFO  = System.getProperty("httpBaseUrlFO")
  val pageFeeder = csv("/opt/gatling/user-files/resources/frontoffice-crawl-urls.csv").circular

  val browseFO = scenario("Browse FO")
    // repeat will loop into csv feeder, each time it loads only one page
    .repeat(10) {
      feed(pageFeeder)
      .exec(http("${name}")
        .get(httpBaseUrlFO + "${location}"))
        .pause("${pauseAfter}")
    }
}

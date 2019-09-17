import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class LoadSimulation extends Simulation {
  val httpBaseUrlFO  = System.getProperty("httpBaseUrlFO")

  val httpConf = http
    .baseUrl(httpBaseUrlFO) // Here is the root for all relative URLs
    .acceptHeader("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8") // Here are the common headers
    .doNotTrackHeader("1")
    .acceptLanguageHeader("en-US,en;q=0.5")
    .acceptEncodingHeader("gzip, deflate")
    .userAgentHeader("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20100101 Firefox/16.0")

  val users = scenario("FO Crawl").exec(FrontOfficeCrawlSimulation.browseFO)
  val customers = scenario("FO Cart").exec(FrontOfficeCartSimulation.buy)
  val admins = scenario("BO Crawl").exec(BackOfficeCrawlSimulation.browseBO)

  val userCount = Integer.getInteger("usersCount", 1)
  val customerCount = Integer.getInteger("customersCount", 1)
  val adminCount = Integer.getInteger("adminsCount", 1)
  val durationInSeconds  = java.lang.Long.getLong("rampDurationInSeconds", 0L)
  setUp(
    users.inject(rampUsers(userCount) during (durationInSeconds seconds)),
    customers.inject(rampUsers(customerCount) during (durationInSeconds seconds)),
    admins.inject(rampUsers(adminCount) during (durationInSeconds seconds))
    //scn.inject(atOnceUsers(1))
  ).protocols(httpConf)
}
